package colourspace

import "core:math"


@(require_results) srgb_encode :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> sRGB {
	return sRGB{_gamma_encode(srgb.r), _gamma_encode(srgb.g), _gamma_encode(srgb.b)}
}

@(require_results) srgb_decode :: #force_inline proc "contextless" (srgb: sRGB) -> Linear_sRGB {
	return Linear_sRGB{_gamma_decode(srgb.r), _gamma_decode(srgb.g), _gamma_decode(srgb.b)}
}


@(require_results) p3_encode :: #force_inline proc "contextless" (p3: Linear_P3) -> Display_P3 {
	return Display_P3{_gamma_encode(p3.r), _gamma_encode(p3.g), _gamma_encode(p3.b)}
}

@(require_results) p3_decode :: #force_inline proc "contextless" (p3: Display_P3) -> Linear_P3 {
	return Linear_P3{_gamma_decode(p3.r), _gamma_decode(p3.g), _gamma_decode(p3.b)}
}


@(require_results) _gamma_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
	// sRGB EOTF^-1: linear light to gamma-encoded signal.
	// Piecewise to avoid infinite slope of the power curve near zero; linear segment below threshold.
	return (1.055 * math.pow(x, 1.0 / 2.4) - 0.055) if (x >= 0.0031308) else (x * 12.92)
}

@(require_results) _gamma_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
	// sRGB EOTF: gamma-encoded signal to linear light.
	// Inverse of _transfer_encode, same piecewise threshold (mapped through the encode curve).
	return math.pow((x + 0.055) / 1.055, 2.4) if (x >= 0.04045) else (x / 12.92)
}


when ENABLE_HDR {
	@(require_results) rec_2020_encode :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2020 {
		return Rec_2020{_rec_709_encode(rec.r), _rec_709_encode(rec.g), _rec_709_encode(rec.b)}
	}

	@(require_results) rec_2020_decode :: #force_inline proc "contextless" (rec: Rec_2020) -> Linear_Rec_2020 {
		return Linear_Rec_2020{_rec_709_decode(rec.r), _rec_709_decode(rec.g), _rec_709_decode(rec.b)}
	}


	@(require_results) _rec_709_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Rec.709 OETF: linear light to gamma-encoded signal.
		// Piecewise to avoid infinite slope of the power curve near zero; linear segment below threshold.
		return (1.099 * math.pow(x, 0.45) - 0.099) if (x >= 0.018) else (x * 4.5)
	}

	@(require_results) _rec_709_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Rec.709 inverse OETF: gamma-encoded signal to linear light.
		// Inverse of _transfer_encode_rec_709, same piecewise threshold (mapped through the encode curve).
		return math.pow((x + 0.099) / 1.099, 1.0 / 0.45) if (x >= 0.081) else (x / 4.5)
	}


	@(require_results) rec_2020_encode_pq :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2100_PQ {
		return Rec_2100_PQ{_pq_encode(rec.r), _pq_encode(rec.g), _pq_encode(rec.b)}
	}

	@(require_results) rec_2020_decode_pq :: #force_inline proc "contextless" (rec: Rec_2100_PQ) -> Linear_Rec_2020 {
		return Linear_Rec_2020{_pq_decode(rec.r), _pq_decode(rec.g), _pq_decode(rec.b)}
	}

	@(require_results) rec_2020_encode_hlg :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2100_HLG {
		return Rec_2100_HLG{_hlg_encode(rec.r), _hlg_encode(rec.g), _hlg_encode(rec.b)}
	}

	@(require_results) rec_2020_decode_hlg :: #force_inline proc "contextless" (rec: Rec_2100_HLG) -> Linear_Rec_2020 {
		return Linear_Rec_2020{_hlg_decode(rec.r), _hlg_decode(rec.g), _hlg_decode(rec.b)}
	}


	@(require_results) _pq_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Rational function of x ^ m1, then raised to power m2 (both fixed PQ constants).
		y: f32 = math.pow(x, 0.1593017578125)

		// SMPTE ST 2084 (PQ) inverse EOTF: linear light to PQ signal.
		return math.pow((0.8359375 + 18.8515625 * y) / (1.0 + 18.6875 * y), 78.84375)
	}

	@(require_results) _pq_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Inverse of x ^ m2 (fixed PQ constant).
		p: f32 = math.pow(x, (1.0 / 78.84375))

		// Numerator of the rational inverse, clamped against floating point error.
		num: f32 = math.max(0.0, (p - 0.8359375))

		// Denominator of the rational inverse, clamped against floating point error.
		den: f32 = math.max(math.F32_MIN, (18.8515625 - 18.6875 * p))

		// SMPTE ST 2084 (PQ) EOTF: PQ signal to linear light.
		// Inverse of the first pow in _transfer_encode_pq (power m1).
		return math.pow((num / den), (1.0 / 0.1593017578125))
	}


	@(require_results) _hlg_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Hybrid Log-Gamma OETF: linear light to HLG signal.
		// Square-root segment below threshold, logarithmic segment above.
		return math.sqrt(3.0 * x) if (x <= (1.0 / 12.0)) else (0.17883277 * math.ln(12.0 * x - 0.28466892) + 0.55991073)
	}

	@(require_results) _hlg_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
		// Hybrid Log-Gamma inverse OETF: HLG signal to linear light.
		// Inverse of _transfer_encode_hlg, same piecewise threshold (mapped through the encode curve).
		return ((x * x) / 3.0) if (x <= 0.5) else ((math.exp((x - 0.55991073) / 0.17883277) + 0.28466892) / 12.0)
	}
}
