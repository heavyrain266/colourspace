package colourspace

import "core:math"


_LMS_TO_P3 :: #row_major matrix[3, 3]f32{
	 2.4934969, -0.9312640, -0.4026590,
	-0.8291050,  1.7628300,  0.0236240,
	 0.0358460, -0.0761720,  0.9568840,
}

_P3_TO_LMS :: #row_major matrix[3, 3]f32{
	0.4865709484, 0.2656739190, 0.1981876872,
	0.2289738040, 0.6917393736, 0.0792868224,
	0.0000000000, 0.0451133819, 1.0439443682,
}


@(require_results)
oklab_to_p3 :: #force_inline proc "contextless" (lab: OKLab) -> Linear_P3 {
	lms : Colour = _OKLAB_TO_LMS * lab

	return _LMS_TO_P3 * Linear_P3{
		lms.x * lms.x * lms.x,
		lms.y * lms.y * lms.y,
		lms.z * lms.z * lms.z,
	}
}

@(require_results)
p3_to_oklab :: #force_inline proc "contextless" (p3: Linear_P3) -> OKLab {
	lms : Colour = _P3_TO_LMS * p3

	return _LMS_TO_OKLAB * OKLab{
		math.cbrt(lms.x),
		math.cbrt(lms.y),
		math.cbrt(lms.z),
	}
}


@(require_results)
oklch_to_p3 :: #force_inline proc "contextless" (lch: OKLCh) -> Linear_P3 {
	return oklab_to_p3(oklch_to_oklab(lch))
}

@(require_results)
p3_to_oklch :: #force_inline proc "contextless" (p3: Linear_P3) -> OKLCh {
	return oklab_to_oklch(p3_to_oklab(p3))
}
