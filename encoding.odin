package colourspacespace

import "core:math"


encode_piecewise :: proc "contextless" (x: f32) -> f32 {
	// sRGB EOTF^-1: linear light to gamma-encoded signal.
	// Piecewise to avoid infinite slope of the power curve near zero; linear segment below threshold.
	return (1.055 * math.pow(x, 1.0 / 2.4) - 0.055) if (x >= 0.0031308) else (x * 12.92)
}

decode_piecewise :: proc "contextless" (x: f32) -> f32 {
	// sRGB EOTF: gamma-encoded signal to linear light.
	// Inverse of encode_piecewise, same piecewise threshold (mapped through the encode curve).
	return math.pow((x + 0.055) / 1.055, 2.4) if (x >= 0.04045) else (x / 12.92)
}


encode_adobe_rgb :: proc "contextless" (x: f32) -> f32 {
	// Adobe RGB (1998) encoding: linear light to gamma-encoded signal.
	return math.pow(x, 1.0 / 2.19921875)
}

decode_adobe_rgb :: proc "contextless" (x: f32) -> f32 {
	// Adobe RGB (1998) decoding: gamma-encoded signal to linear light.
	// Inverse of encode_adobe_rgb (pure power 2.19921875).
	return math.pow(x, 2.19921875)
}


encode_rec_709 :: proc "contextless" (x: f32) -> f32 {
	// Rec. 709 OETF: linear light to gamma-encoded signal.
	// Piecewise to avoid infinite slope of the power curve near zero; linear segment below threshold.
	return (1.099 * math.pow(x, 0.45) - 0.099) if (x >= 0.018) else (x * 4.5)
}

decode_rec_709 :: proc "contextless" (x: f32) -> f32 {
	// Rec. 709 inverse OETF: gamma-encoded signal to linear light.
	// Inverse of encode_rec_709, same piecewise threshold (mapped through the encode curve).
	return math.pow((x + 0.099) / 1.099, 1.0 / 0.45) if (x >= 0.081) else (x / 4.5)
}


encode_pq :: proc "contextless" (x: f32) -> f32 {
	// Rational function of (x ^ m1), then raised to power m2 (both fixed PQ constants).
	y: f32 = math.pow(x, 0.1593017578125)

	// SMPTE ST 2084 (PQ) inverse EOTF: linear light to PQ signal.
	return math.pow((0.8359375 + 18.8515625 * y) / (1.0 + 18.6875 * y), 78.84375)
}

decode_pq :: proc "contextless" (x: f32) -> f32 {
	// Inverse of (x ^ m2) (fixed PQ constant).
	p: f32 = math.pow(x, (1.0 / 78.84375))

	// Numerator of the rational inverse, clamped against floating point error.
	num: f32 = math.max(0.0, (p - 0.8359375))

	// Denominator of the rational inverse, clamped against floating point error.
	den: f32 = math.max(math.F32_MIN, (18.8515625 - 18.6875 * p))

	// SMPTE ST 2084 (PQ) EOTF: PQ signal to linear light.
	// Inverse of the first pow in encode_pq (power m1).
	return math.pow((num / den), (1.0 / 0.1593017578125))
}


encode_hlg :: proc "contextless" (x: f32) -> f32 {
	// Hybrid Log-Gamma OETF: linear light to HLG signal.
	// Square-root segment below threshold, logarithmic segment above.
	return math.sqrt(3.0 * x) if (x <= (1.0 / 12.0)) else (0.17883277 * math.ln(12.0 * x - 0.28466892) + 0.55991073)
}

decode_hlg :: proc "contextless" (x: f32) -> f32 {
	// Hybrid Log-Gamma inverse OETF: HLG signal to linear light.
	// Inverse of encode_hlg, same piecewise threshold (mapped through the encode curve).
	return ((x * x) / 3.0) if (x <= 0.5) else ((math.exp((x - 0.55991073) / 0.17883277) + 0.28466892) / 12.0)
}
