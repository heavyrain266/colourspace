package colourspace


_LINEAR_REC2020_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
	 1.6604910021, -0.5876411388, -0.0728498633,
	-0.1245504745,  1.1328998971, -0.0083494226,
	-0.0181507634, -0.1005788980,  1.1187296614,
}

_LINEAR_REC2020_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
	 1.3435782526, -0.2821796705, -0.0613985821,
	-0.0652974528,  1.0757879158, -0.0104904631,
	 0.0028217873, -0.0195984945,  1.0167767073,
}


@(require_results)
rec2020_to_srgb :: #force_inline proc "contextless" (rec: Linear_Rec2020) -> Linear_sRGB {
	return (_LINEAR_REC2020_TO_LINEAR_SRGB * Linear_sRGB{rec.r, rec.g, rec.b})
}

@(require_results)
rec2020_to_p3 :: #force_inline proc "contextless" (rec: Linear_Rec2020) -> Linear_P3 {
	return (_LINEAR_REC2020_TO_LINEAR_P3 * Linear_Rec2020{rec.r, rec.g, rec.b})
}
