package colourspace

import "core:math"


Colour       :: [3]f32
Chromaticity :: [2]f32

OKLCh            :: distinct Colour
@(private) OKHSL :: distinct Colour
@(private) OKHSV :: distinct Colour
OKLab            :: distinct Colour

CIE_XYZ     :: distinct Colour
CIE_YXY     :: distinct Colour

Linear_P3   :: distinct Colour
Linear_sRGB :: distinct Colour

sRGB        :: distinct Colour
Display_P3  :: distinct Colour


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



@(require_results)
oklch :: #force_inline proc "contextless" (l, c, h: f32) -> OKLCh {
	return OKLCh{l, c, math.to_radians(h)}
}

@(private)
okhsl :: #force_inline proc "contextless" (h, s, l: f32) -> OKHSL {
	return OKHSL{math.to_radians(h), s, l}
}

@(private)
okhsv :: #force_inline proc "contextless" (h, s, v: f32) -> OKHSV {
	return OKHSV{math.to_radians(h), s, v}
}

@(require_results)
oklab :: #force_inline proc "contextless" (l, a, b: f32) -> OKLab {
	return OKLab{l, a, b}
}


@(require_results)
srgb :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_sRGB {
	return Linear_sRGB{r, g, b}
}

@(require_results)
p3 :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_P3 {
	return Linear_P3{r, g, b}
}
