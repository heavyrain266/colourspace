package colourspace

import "core:math"


when ENABLE_HDR {
	// composed Linear LMS <-> Linear Rec. 2020 transforms
	// product of XYZ <-> Rec. 2020 and XYZ <-> LMS matrices

	_LINEAR_LMS_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
		2.1401402950, -1.2463558912, 0.1064317226,
		-0.8848324418, 2.1631727219, -0.2783615887,
		-0.0485790595, -0.4544909000, 1.5023562908,
	}

	_LINEAR_REC2020_TO_LINEAR_LMS :: #row_major matrix[3, 3]f32{
		0.6166884303, 0.3601590693, 0.0230432935,
		0.2651402056, 0.6358565092, 0.0990302339,
		0.1001506448, 0.2040043175, 0.6963247061,
	}


	@(require_results)
	oklab_to_rec2020 :: #force_inline proc "contextless" (lab: OKLab) -> Linear_Rec2020 {
		lms : _Linear_LMS = (_OKLAB_TO_LINEAR_LMS * lab)

		return (_LINEAR_LMS_TO_LINEAR_REC2020 * Linear_Rec2020{
			cube(lms.x),
			cube(lms.y),
			cube(lms.z)
		})
	}

	@(require_results)
	rec2020_to_oklab :: #force_inline proc "contextless" (rec2020: Linear_Rec2020) -> OKLab {
		lms : _Linear_LMS = (_LINEAR_REC2020_TO_LMS * rec2020)

		return (_LINEAR_LMS_TO_OKLAB * OKLab{
			math.cbrt(lms.x),
			math.cbrt(lms.y),
			math.cbrt(lms.z)
		})
	}


	@(require_results)
	oklch_to_rec2020 :: #force_inline proc "contextless" (lch: OKLCh) -> Linear_Rec2020 {
		return oklab_to_rec2020(oklch_to_oklab(lch))
	}

	@(require_results)
	rec2020_to_oklch :: #force_inline proc "contextless" (rec2020: Linear_Rec2020) -> OKLCh {
		return oklab_to_oklch(rec2020_to_oklab(rec2020))
	}


	@(private)
	okhsv_to_rec2020 :: #force_inline proc "contextless" (hsv: OKHSV) -> Linear_Rec2020 {
		return oklab_to_rec2020(okhsv_to_oklab(hsv))
	}

	@(private)
	rec2020_to_okhsv :: #force_inline proc "contextless" (rec2020: Linear_Rec2020) -> OKHSV {
		return oklab_to_okhsv(rec2020_to_oklab(rec2020))
	}


	@(private)
	okhsl_to_rec2020 :: #force_inline proc "contextless" (hsl: OKHSL) -> Linear_Rec2020 {
		return oklab_to_rec2020(okhsl_to_oklab(hsl))
	}

	@(private)
	rec2020_to_okhsl :: #force_inline proc "contextless" (rec2020: Linear_Rec2020) -> OKHSL {
		return oklab_to_okhsl(rec2020_to_oklab(rec2020))
	}
}
