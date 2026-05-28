package colourspace

import "core:math"


@(private="file")
LMS_TO_SRGB :: #row_major matrix[3, 3]f32{
	 4.0767416621, -3.3077115913,  0.2309699292,
	-1.2684380046,  2.6097574011, -0.3413193965,
	-0.0041960863, -0.7034186147,  1.7076147010,
}

@(private="file")
SRGB_TO_LMS :: #row_major matrix[3, 3]f32{
	0.4122214708, 0.5363325363, 0.0514459929,
	0.2119034982, 0.6806995451, 0.1073969566,
	0.0883024619, 0.2817188376, 0.6299787005,
}


@(require_results)
oklab_to_srgb :: #force_inline proc "contextless" (lab: OKLab) -> Linear_sRGB {
	lms : Colour = _OKLAB_TO_LMS * lab

	return LMS_TO_SRGB * Linear_sRGB{
		lms.x * lms.x * lms.x,
		lms.y * lms.y * lms.y,
		lms.z * lms.z * lms.z,
	}
}

@(require_results)
srgb_to_oklab :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> OKLab {
	lms : Colour = SRGB_TO_LMS * srgb

	return _LMS_TO_OKLAB * OKLab{
		math.cbrt(lms.r),
		math.cbrt(lms.g),
		math.cbrt(lms.b),
	}
}

@(require_results)
oklch_to_srgb :: #force_inline proc "contextless" (lch: OKLCh) -> Linear_sRGB {
	return oklab_to_srgb(oklch_to_oklab(lch))
}

@(require_results)
srgb_to_oklch :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> OKLCh {
	return oklab_to_oklch(srgb_to_oklab(srgb))
}
