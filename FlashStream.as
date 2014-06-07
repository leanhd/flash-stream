package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    
    
    [SWF(frameRate="30", backgroundColor="0x000000")]
    public class FlashStream extends Sprite {
    
        private var video:Video;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var callback:String;
        private var id:String;

        public function FlashStream() {
            // Init stage scaling
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.align = StageAlign.TOP_LEFT;
            
            callback = this.loaderInfo.parameters.callback;
            id = this.loaderInfo.parameters.id;

            // Add addedToStage listener
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private function addedToStageHandler(e:Event):void {
            // Create the video object and add it to the scene 
            video = new Video();
            video.width = this.stage.stageWidth;
            video.height = this.stage.stageHeight;
            this.addChild(video);

            // Export JS API
            ExternalInterface.addCallback('connect', connect);
            ExternalInterface.addCallback('play', play);
            ExternalInterface.addCallback('close', close);
            ExternalInterface.addCallback('pause', pause);
            ExternalInterface.addCallback('resume', resume);
            
            // Add a listener on stage resize
            this.stage.addEventListener(Event.RESIZE, stageResizeHandler);
            
            ExternalInterface.call(callback, id, new Array('Flash.Ready'));
        }
        
        private function connect(url:String):void {
            // Create a new connection and connect to the specified url
            nc = new NetConnection();
            nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            nc.connect(url);
        }
        
        private function play(name:String, peerID:String = null):void {
            if(peerID != null) {
                ns = new NetStream(nc, peerID);    
            } else {
                ns = new NetStream(nc);
            }

            ns.client = this;
            
            ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            ns.play(name);
            video.attachNetStream(ns);
        }
        
        private function close():void {
            video.attachNetStream(null);
            ns.close();
        }
        
        private function pause():void {
            ns.pause();
        }
        
        private function resume():void {
            ns.resume();
        }
        
        private function stageResizeHandler(event:Event):void {
            video.width = this.stage.stageWidth;
            video.height = this.stage.stageHeight;
        }
        
        private function netStatusHandler(event:NetStatusEvent):void {
            
            if (event.info.code == 'NetStream.Play.Stop') {
                // Prepare a new player for the next round
                this.removeChild(video);
                video = new Video();
                video.width = this.stage.stageWidth;
                video.height = this.stage.stageHeight;
                this.addChild(video);
            } 
            else if(event.info.code == 'NetStream.Video.DimensionChange') {

                ExternalInterface.call(callback, id, new Array(event.info.code, video.videoWidth, video.videoHeight));
                return;
            }
        
            ExternalInterface.call(callback, id, new Array(event.info.code));
        }

        public function onMetaData(info:Object):void {
            this.log('meta');

        }

        private function log(text:String):void {
            ExternalInterface.call('console.log', text)
        }
        
    }
}
