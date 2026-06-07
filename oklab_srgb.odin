package colourspace

import "core:math"


// Products of XYZ <-> sRGB and XYZ <-> LMS matrices.

_LINEAR_LMS_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
	4.0771870613, -3.3076224327, 0.2308591902,
	-1.2685765028, 2.6096870899, -0.3411557376,
	-0.0041965423, -0.7033996582, 1.7067960501,
}

_LINEAR_SRGB_TO_LINEAR_LMS :: #row_major matrix[3, 3]f32{
	0.4121764600, 0.5362739563, 0.0514403731,
	0.2119092047, 0.6807178855, 0.1073998436,
	0.0883448124, 0.2818539739, 0.6302808523,
}


@(require_results)
oklab_to_srgb :: #force_inline proc "contextless" (lab: OkLab) -> Linear_sRGB {
	lms: _Linear_LMS = (_OKLAB_TO_LINEAR_LMS * lab)

	return (_LINEAR_LMS_TO_LINEAR_SRGB * Linear_sRGB{
		lms.x * lms.x * lms.x,
		lms.y * lms.y * lms.y,
		lms.z * lms.z * lms.z,
	})
}

@(require_results)
srgb_to_oklab :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> OkLab {
	lms: _Linear_LMS = (_LINEAR_SRGB_TO_LINEAR_LMS * srgb)

	return (_LINEAR_LMS_TO_OKLAB * OkLab{
		math.cbrt(lms.r),
		math.cbrt(lms.g),
		math.cbrt(lms.b),
	})
}


@(require_results)
oklch_to_srgb :: #force_inline proc "contextless" (lch: OkLCh) -> Linear_sRGB {
	return oklab_to_srgb(oklch_to_oklab(lch))
}

@(require_results)
srgb_to_oklch :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> OkLCh {
	return oklab_to_oklch(srgb_to_oklab(srgb))
}
