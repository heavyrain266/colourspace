package colourspace

import "core:math"


ENABLE_HDR :: #config(COLOURSPACE_ENABLE_HDR, false)


@(require_results) // Hue in degrees, converted to radians internally
oklch :: #force_inline proc "contextless" (l, c, h: f32) -> OKLCh {
	return OKLCh{l, c, math.to_radians(h)}
}

@(private) // Hue in degrees, converted to radians internally
okhsv :: #force_inline proc "contextless" (h, s, v: f32) -> OKHSV {
	return OKHSV{math.to_radians(h), s, v}
}

@(private) // Hue in degrees, converted to radians internally
okhsl :: #force_inline proc "contextless" (h, s, l: f32) -> OKHSL {
	return OKHSL{math.to_radians(h), s, l}
}

@(require_results)
oklab :: #force_inline proc "contextless" (l, a, b: f32) -> OKLab {
	return OKLab{l, a, b}
}



@(require_results)
linear_srgb :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_sRGB {
	return Linear_sRGB{r, g, b}
}

@(require_results)
linear_p3 :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_P3 {
	return Linear_P3{r, g, b}
}

when ENABLE_HDR {
	@(require_results)
	linear_rec2020 :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_Rec2020 {
		return Linear_Rec2020{r, g, b}
	}
}

@(require_results)
srgb :: #force_inline proc "contextless" (r, g, b: f32) -> sRGB {
	return linear_srgb_encode(Linear_sRGB{r, g, b})
}

@(require_results)
display_p3 :: #force_inline proc "contextless" (r, g, b: f32) -> Display_P3 {
	return linear_p3_encode(Linear_P3{r, g, b})
}

when ENABLE_HDR {
	@(require_results)
	rec2020 :: #force_inline proc "contextless" (r, g, b: f32) -> Rec2020 {
		return linear_rec2020_encode(Linear_Rec2020{r, g, b})
	}
}


@(private, require_results)
cube :: #force_inline proc "contextless" (x: f32) -> f32 {
	return x * x * x
}
