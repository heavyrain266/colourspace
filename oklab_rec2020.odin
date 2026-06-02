package colourspace

import "core:math"


when ENABLE_HDR {
	// composed Linear LMS <-> Linear Rec. 2020 transforms
	// product of XYZ <-> Rec. 2020 and XYZ <-> LMS matrices

	_LINEAR_LMS_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
		 2.13990672, -1.24638932,  0.10648233,
		-0.88473587,  2.16323093, -0.27849495,
		-0.04857366, -0.45450337,  1.50307693,
	}

	_LINEAR_REC2020_TO_LMS :: #row_major matrix[3, 3]f32{
		0.61675579, 0.36019838, 0.02304595,
		0.26513306, 0.63583937, 0.09902758,
		0.10010263, 0.20390659, 0.69599085,
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
