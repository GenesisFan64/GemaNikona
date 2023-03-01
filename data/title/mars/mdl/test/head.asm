MarsObj_test:
		dc.w 6,8
		dc.l TH|.vert,TH|.face,TH|.vrtx,TH|.mtrl
.vert:		binclude "data/title/mars/mdl/test/vert.bin"
.face:		binclude "data/title/mars/mdl/test/face.bin"
.vrtx:		binclude "data/title/mars/mdl/test/vrtx.bin"
.mtrl:		include "data/title/mars/mdl/test/mtrl.asm"
		align 4