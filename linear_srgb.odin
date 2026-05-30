package colourspace


_LINEAR_SRGB_TO_LINEAR_P3 :: #row_major matrix[3, 3]f32{
	0.8224619687, 0.1775380313,  0.0000000000,
	0.0331941989, 0.9668058011, -0.0000000000,
	0.0170826307, 0.0723974407,  0.9105199286,
}

_LINEAR_SRGB_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
	0.6274038959, 0.3292830384, 0.0433130657,
	0.0690972894, 0.9195403951, 0.0113623156,
	0.0163914389, 0.0880133079, 0.8955952532,
}


@(require_results)
srgb_to_p3 :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> Linear_P3 {
	return (_LINEAR_SRGB_TO_LINEAR_P3 * Linear_P3{srgb.r, srgb.g, srgb.b})
}

@(require_results)
srgb_to_rec2020 :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> Linear_Rec2020 {
	return (_LINEAR_SRGB_TO_LINEAR_REC2020 * Linear_Rec2020{srgb.r, srgb.g, srgb.b})
}
