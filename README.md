flash-stream
============
### A lightweight Javascript Flash Stream component

This is a very lightweight (under 2KB) SWF stream playing component that can be used as a fallback where WebRTC is not available.

The component is entirely Javascript-driven, and is in fact a thin wrapper around the flash Stream component. It supports stream playing through both RTMP and RTMFP (p2p, as in WebRTC).

Usage
-----

`example.html` should get you started. The example uses RTMFP so you will need a Stratus key which can easily be obtained here [http://labs.adobe.com/technologies/cirrus/](http://labs.adobe.com/technologies/cirrus/). When the page is loaded open your browser console to get a peek at the internals. To test the component you will need the peerID of a published webcam. You can get one by running the flash-camera component.

The API being very close to the original Flash API, when in doubt look as the Actionscript source and refer to the corresponding documentation.

Building
--------

You can rebuild a modified `FlashStream.as` with the included Makefile. You will need to have the Flex SDK installed and `mxmlc` in your PATH. Then simply run

```bash
$ make
```
