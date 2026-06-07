package colourspace

import "core:math"


// Products of XYZ <-> P3 and XYZ <-> LMS matrices.

_LINEAR_LMS_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
	3.1281106472, -2.2570750713, 0.1293047816,
	-1.0911281109, 2.4132666588, -0.3221681714,
	-0.0260136500, -0.5080276728, 1.5333167315,
}

_LINEAR_P3_TO_LINEAR_LMS :: #row_major matrix[3, 3]f32{
	0.4813272953, 0.4620679021, 0.0564956032,
	0.2288381010, 0.6532344222, 0.1179544106,
	0.0839860141, 0.2242727876, 0.6922208667,
}


@(require_results)
oklab_to_p3 :: #force_inline proc "contextless" (lab: OkLab) -> Linear_P3 {
	lms: _Linear_LMS = (_OKLAB_TO_LINEAR_LMS * lab)

	return (_LINEAR_LMS_TO_LINEAR_P3 * Linear_P3{
		lms.x * lms.x * lms.x,
		lms.y * lms.y * lms.y,
		lms.z * lms.z * lms.z,
	})
}

@(require_results)
p3_to_oklab :: #force_inline proc "contextless" (p3: Linear_P3) -> OkLab {
	lms: _Linear_LMS = (_LINEAR_P3_TO_LINEAR_LMS * p3)

	return (_LINEAR_LMS_TO_OKLAB * OkLab{
		math.cbrt(lms.x),
		math.cbrt(lms.y),
		math.cbrt(lms.z),
	})
}


@(require_results)
oklch_to_p3 :: #force_inline proc "contextless" (lch: OkLCh) -> Linear_P3 {
	return oklab_to_p3(oklch_to_oklab(lch))
}

@(require_results)
p3_to_oklch :: #force_inline proc "contextless" (p3: Linear_P3) -> OkLCh {
	return oklab_to_oklch(p3_to_oklab(p3))
}
