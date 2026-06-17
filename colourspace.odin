package colourspace

import "core:math"


ENABLE_HDR :: #config(COLOURSPACE_ENABLE_HDR, false)


@(require_results)
oklch_to_oklab :: #force_inline proc "contextless" (lch: OkLCh) -> OkLab {
	a: f32 = (lch.y * math.cos(lch.z))
	b: f32 = (lch.y * math.sin(lch.z))

	return OkLab{lch.x, a, b}
}

@(require_results) // Hue in radians; use `math.to_degrees(h)` if needed
oklab_to_oklch :: #force_inline proc "contextless" (lab: OkLab) -> OkLCh {
	c: f32 = math.hypot(lab.y, lab.z)
	h: f32 = math.atan2(lab.z, lab.y) if c >= math.F32_EPSILON else 0.0

	return OkLCh{lab.x, c, h}
}


@(require_results) // Hue in degrees, converted to radians internally
oklch :: #force_inline proc "contextless" (l, c, h: f32) -> OkLCh {
	return OkLCh{l, c, math.to_radians(h)}
}

@(require_results)
oklab :: #force_inline proc "contextless" (l, a, b: f32) -> OkLab {
	return OkLab{l, a, b}
}


@(require_results)
linear_srgb :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_sRGB {
	return Linear_sRGB{r, g, b}
}

@(require_results)
linear_p3 :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_P3 {
	return Linear_P3{r, g, b}
}


@(require_results)
srgb :: #force_inline proc "contextless" (r, g, b: f32) -> sRGB {
	return srgb_encode(Linear_sRGB{r, g, b})
}

@(require_results)
display_p3 :: #force_inline proc "contextless" (r, g, b: f32) -> Display_P3 {
	return p3_encode(Linear_P3{r, g, b})
}


when ENABLE_HDR {
	@(require_results)
	linear_rec_2020 :: #force_inline proc "contextless" (r, g, b: f32) -> Linear_Rec_2020 {
		return Linear_Rec_2020{r, g, b}
	}

	@(require_results)
	rec_2020 :: #force_inline proc "contextless" (r, g, b: f32) -> Rec_2020 {
		return rec_2020_encode(Linear_Rec_2020{r, g, b})
	}

	@(require_results)
	rec_2100_pq :: #force_inline proc "contextless" (r, g, b: f32) -> Rec_2100_PQ {
		return rec_2020_encode_pq(Linear_Rec_2020{r, g, b})
	}

	@(require_results)
	rec_2100_hlg :: #force_inline proc "contextless" (r, g, b: f32) -> Rec_2100_HLG {
		return rec_2020_encode_hlg(Linear_Rec_2020{r, g, b})
	}
}
