package colourspace


_LINEAR_P3_TO_LINEAR_SRGB :: #row_major matrix[3, 3]f32{
	 1.2249401763, -0.2249401763, -0.0000000000,
	-0.0420569547,  1.0420569547,  0.0000000000,
	-0.0196375546, -0.0786360456,  1.0982736001,
}

_LINEAR_P3_TO_LINEAR_REC2020 :: #row_major matrix[3, 3]f32{
	 0.7538330344, 0.1985973691, 0.0475695966,
	 0.0457438490, 0.9417772198, 0.0124789312,
	-0.0012103404, 0.0176017173, 0.9836086231,
}


@(require_results)
p3_to_srgb :: #force_inline proc "contextless" (p3: Linear_P3) -> Linear_sRGB {
	return (_LINEAR_P3_TO_LINEAR_SRGB * Linear_sRGB{p3.r, p3.g, p3.b})
}

@(require_results)
p3_to_rec2020 :: #force_inline proc "contextless" (p3: Linear_P3) -> Linear_Rec2020 {
	return (_LINEAR_P3_TO_LINEAR_REC2020 * Linear_Rec2020{p3.r, p3.g, p3.b})
}
