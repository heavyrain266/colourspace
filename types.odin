package colourspace


Colour           :: [3]f32
Chromaticity     :: [2]f32

OKLCh            :: distinct Colour
@(private) OKHSV :: distinct Colour
@(private) OKHSL :: distinct Colour
OKLab            :: distinct Colour

CIE_XYZ          :: distinct Colour
CIE_YXY          :: distinct Colour

Linear_sRGB      :: distinct Colour
Linear_P3        :: distinct Colour
Linear_Rec2020   :: distinct Colour

sRGB             :: distinct Colour
Display_P3       :: distinct Colour
Rec2020          :: distinct Colour


// OKLab <-> Linear LMS transforms
// Björn Ottosson, https://bottosson.github.io/posts/oklab/

_OKLAB_TO_LMS :: #row_major matrix[3, 3]f32{
	1.0,  0.3963377774,  0.2158037573,
	1.0, -0.1055613458, -0.0638541728,
	1.0, -0.0894841775, -1.2914855480,
}

_LMS_TO_OKLAB :: #row_major matrix[3, 3]f32{
	0.2104542553,  0.7936177850, -0.0040720468,
	1.9779984951, -2.4285922050,  0.4505937099,
	0.0259040371,  0.7827717662, -0.8086757660,
}
