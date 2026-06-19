package colourspace


Colour       :: [3]f32
Chromaticity :: [2]f32

OkLch        :: distinct Colour
OkLab        :: distinct Colour

CIE_XYZ      :: distinct Colour

_Linear_LMS  :: distinct Colour
Linear_sRGB  :: distinct Colour
Linear_P3    :: distinct Colour

sRGB         :: distinct Colour
Display_P3   :: distinct Colour

when ENABLE_HDR {
	Linear_Rec_2020 :: distinct Colour

	Rec_2020        :: distinct Colour
	Rec_2100_PQ     :: distinct Colour
	Rec_2100_HLG    :: distinct Colour
}


// OKLab <-> Linear LMS transforms
// Björn Ottosson, https://bottosson.github.io/posts/oklab/

_OKLAB_TO_LINEAR_LMS :: #row_major matrix[3, 3]f32{
	1.0,  0.3963377774,  0.2158037573,
	1.0, -0.1055613458, -0.0638541728,
	1.0, -0.0894841775, -1.2914855480,
}

_LINEAR_LMS_TO_OKLAB :: #row_major matrix[3, 3]f32{
	0.2104542553,  0.7936177850, -0.0040720468,
	1.9779984951, -2.4285922050,  0.4505937099,
	0.0259040371,  0.7827717662, -0.8086757660,
}
