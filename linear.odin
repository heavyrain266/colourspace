package colourspace


_LINEAR_SRGB_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
	0.8224619687, 0.1775380313,  0.0000000000,
	0.0331941989, 0.9668058011, -0.0000000000,
	0.0170826307, 0.0723974407,  0.9105199286,
}

_LINEAR_P3_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
	 1.2249401763, -0.2249401763, -0.0000000000,
	-0.0420569547,  1.0420569547,  0.0000000000,
	-0.0196375546, -0.0786360456,  1.0982736001,
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
	_LINEAR_SRGB_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
		0.6274038959, 0.3292830384, 0.0433130657,
		0.0690972894, 0.9195403951, 0.0113623156,
		0.0163914389, 0.0880133079, 0.8955952532,
	}

	_LINEAR_REC2020_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
		 1.6604910021, -0.5876411388, -0.0728498633,
		-0.1245504745,  1.1328998971, -0.0083494226,
		-0.0181507634, -0.1005788980,  1.1187296614,
	}


	_LINEAR_P3_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
		 0.7538330344, 0.1985973691, 0.0475695966,
		 0.0457438490, 0.9417772198, 0.0124789312,
		-0.0012103404, 0.0176017173, 0.9836086231,
	}

	_LINEAR_REC2020_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
		 1.3435782526, -0.2821796705, -0.0613985821,
		-0.0652974528,  1.0757879158, -0.0104904631,
		 0.0028217873, -0.0195984945,  1.0167767073,
	}


	@(require_results)
	srgb_to_rec2020 :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> Linear_Rec2020 {
		return (_LINEAR_SRGB_TO_LINEAR_REC2020 * Linear_Rec2020{srgb.r, srgb.g, srgb.b})
	}

	@(require_results)
	p3_to_rec2020 :: #force_inline proc "contextless" (p3: Linear_P3) -> Linear_Rec2020 {
		return (_LINEAR_P3_TO_LINEAR_REC2020 * Linear_Rec2020{p3.r, p3.g, p3.b})
	}

	@(require_results)
	rec2020_to_srgb :: #force_inline proc "contextless" (rec: Linear_Rec2020) -> Linear_sRGB {
		return (_LINEAR_REC2020_TO_LINEAR_SRGB * Linear_sRGB{rec.r, rec.g, rec.b})
	}

	@(require_results)
	rec2020_to_p3 :: #force_inline proc "contextless" (rec: Linear_Rec2020) -> Linear_P3 {
		return (_LINEAR_REC2020_TO_LINEAR_P3 * Linear_Rec2020{rec.r, rec.g, rec.b})
	}
}
