package colourspace


// Products of XYZ <-> sRGB and XYZ <-> P3 matrices.

_LINEAR_SRGB_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
	0.8224619627, 0.1775380373, -0.0000000000,
	0.0331941992, 0.9668058157, -0.0000000000,
	0.0170826316, 0.0723974407, 0.9105199575,
}

_LINEAR_P3_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
	1.2249401808, -0.2249401808, 0.0000000000,
	-0.0420569554, 1.0420569181, 0.0000000000,
	-0.0196375549, -0.0786360428, 1.0982736349,
}


@(require_results)
srgb_to_p3 :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> Linear_P3 {
	return (_LINEAR_SRGB_TO_LINEAR_P3 * Linear_P3{srgb.r, srgb.g, srgb.b})
}

@(require_results)
p3_to_srgb :: #force_inline proc "contextless" (p3: Linear_P3) -> Linear_sRGB {
	return (_LINEAR_P3_TO_LINEAR_SRGB * Linear_sRGB{p3.r, p3.g, p3.b})
}


when ENABLE_HDR {
	// Products of XYZ <-> sRGB and XYZ <-> Rec. 2020 matrices.

	_LINEAR_SRGB_TO_LINEAR_REC_2020 :: #row_major matrix[3, 3]f32{
		0.6274039149, 0.3292830288, 0.0433130674,
		0.0690972880, 0.9195404053, 0.0113623152,
		0.0163914394, 0.0880133063, 0.8955952525,
	}

	_LINEAR_REC_2020_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
		1.6604909897, -0.5876411200, -0.0728498623,
		-0.1245504767, 1.1328998804, -0.0083494224,
		-0.0181507636, -0.1005788967, 1.1187297106,
	}


	// Products of XYZ <-> P3 and XYZ <-> Rec. 2020 matrices.

	_LINEAR_P3_TO_LINEAR_REC_2020 :: #row_major matrix[3, 3]f32{
		0.7538330555, 0.1985973716, 0.0475695953,
		0.0457438491, 0.9417772293, 0.0124789309,
		-0.0012103403, 0.0176017173, 0.9836086035,
	}

	_LINEAR_REC_2020_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
		1.3435782194, -0.2821796834, -0.0613985807,
		-0.0652974546, 1.0757879019, -0.0104904631,
		0.0028217873, -0.0195984952, 1.0167766809,
	}


	@(require_results)
	srgb_to_rec_2020 :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> Linear_Rec_2020 {
		return (_LINEAR_SRGB_TO_LINEAR_REC_2020 * Linear_Rec_2020{srgb.r, srgb.g, srgb.b})
	}

	@(require_results)
	p3_to_rec_2020 :: #force_inline proc "contextless" (p3: Linear_P3) -> Linear_Rec_2020 {
		return (_LINEAR_P3_TO_LINEAR_REC_2020 * Linear_Rec_2020{p3.r, p3.g, p3.b})
	}

	@(require_results)
	rec_2020_to_srgb :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Linear_sRGB {
		return (_LINEAR_REC_2020_TO_LINEAR_SRGB * Linear_sRGB{rec.r, rec.g, rec.b})
	}

	@(require_results)
	rec_2020_to_p3 :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Linear_P3 {
		return (_LINEAR_REC_2020_TO_LINEAR_P3 * Linear_Rec_2020{rec.r, rec.g, rec.b})
	}
}
