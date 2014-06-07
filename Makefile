%.swf: %.as
	mxmlc $<

all: FlashStream.swf

.PHONY: all
