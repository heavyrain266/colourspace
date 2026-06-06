package colourspace

import "core:math"


@(require_results)
srgb_encode :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> sRGB {
	return sRGB{
		_transfer_encode(srgb.r),
		_transfer_encode(srgb.g),
		_transfer_encode(srgb.b),
	}
}

@(require_results)
srgb_decode :: #force_inline proc "contextless" (srgb: sRGB) -> Linear_sRGB {
	return Linear_sRGB{
		_transfer_decode(srgb.r),
		_transfer_decode(srgb.g),
		_transfer_decode(srgb.b),
	}
}


@(require_results)
p3_encode :: #force_inline proc "contextless" (p3: Linear_P3) -> Display_P3 {
	return Display_P3{
		_transfer_encode(p3.r),
		_transfer_encode(p3.g),
		_transfer_encode(p3.b),
	}
}

@(require_results)
p3_decode :: #force_inline proc "contextless" (p3: Display_P3) -> Linear_P3 {
	return Linear_P3{
		_transfer_decode(p3.r),
		_transfer_decode(p3.g),
		_transfer_decode(p3.b),
	}
}


// IEC 61966-2-1 transfer functions
// gamma threshold: 0.0031308, linearisation threshold: 0.04045

@(require_results)
_transfer_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
	return (1.055 * math.pow(x, 1.0 / 2.4) - 0.055) if (x >= 0.0031308) else (x * 12.92)
}

@(require_results)
_transfer_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
	return math.pow((x + 0.055) / 1.055, 2.4) if (x >= 0.04045) else (x / 12.92)
}


when ENABLE_HDR {
	@(require_results)
	rec_2020_encode :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2020 {
		return Rec_2020{
			_transfer_encode_rec709(rec.r),
			_transfer_encode_rec709(rec.g),
			_transfer_encode_rec709(rec.b),
		}
	}

	@(require_results)
	rec_2020_decode :: #force_inline proc "contextless" (rec: Rec_2020) -> Linear_Rec_2020 {
		return Linear_Rec_2020{
			_transfer_decode_rec709(rec.r),
			_transfer_decode_rec709(rec.g),
			_transfer_decode_rec709(rec.b),
		}
	}


	// ITU-R BT.2020 / BT.709 transfer functions
	// gamma threshold: 0.018, linearisation threshold: 0.081

	@(require_results)
	_transfer_encode_rec709 :: #force_inline proc "contextless" (x: f32) -> f32 {
		return (1.099 * math.pow(x, 0.45) - 0.099) if (x >= 0.018) else (x * 4.5)
	}

	@(require_results)
	_transfer_decode_rec709 :: #force_inline proc "contextless" (x: f32) -> f32 {
		return math.pow((x + 0.099) / 1.099, 1.0 / 0.45) if (x >= 0.081) else (x / 4.5)
	}


	@(require_results)
	rec_2020_encode_pq :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2100_PQ {
		return Rec_2100_PQ{
			_transfer_encode_pq(rec.r),
			_transfer_encode_pq(rec.g),
			_transfer_encode_pq(rec.b),
		}
	}

	@(require_results)
	rec_2020_decode_pq :: #force_inline proc "contextless" (rec: Rec_2100_PQ) -> Linear_Rec_2020 {
		return Linear_Rec_2020{
			_transfer_decode_pq(rec.r),
			_transfer_decode_pq(rec.g),
			_transfer_decode_pq(rec.b),
		}
	}

	@(require_results)
	rec_2020_encode_hlg :: #force_inline proc "contextless" (rec: Linear_Rec_2020) -> Rec_2100_HLG {
		return Rec_2100_HLG{
			_transfer_encode_hlg(rec.r),
			_transfer_encode_hlg(rec.g),
			_transfer_encode_hlg(rec.b),
		}
	}

	@(require_results)
	rec_2020_decode_hlg :: #force_inline proc "contextless" (rec: Rec_2100_HLG) -> Linear_Rec_2020 {
		return Linear_Rec_2020{
			_transfer_decode_hlg(rec.r),
			_transfer_decode_hlg(rec.g),
			_transfer_decode_hlg(rec.b),
		}
	}


	// ITU-R BT.2100 PQ (Perceptual Quantizer) transfer functions

	@(require_results)
	_transfer_encode_pq :: #force_inline proc "contextless" (x: f32) -> f32 {
		y: f32 = math.pow(x, 0.1593017578125)

		return math.pow((0.8359375 + 18.8515625 * y) / (1.0 + 18.6875 * y), 78.84375)
	}

	@(require_results)
	_transfer_decode_pq :: #force_inline proc "contextless" (x: f32) -> f32 {
		p:   f32 = math.pow(x, (1.0 / 78.84375))
		num: f32 = math.max(0.0, (p - 0.8359375))
		den: f32 = math.max(math.F32_MIN, (18.8515625 - 18.6875 * p))

		return math.pow((num / den), (1.0 / 0.1593017578125))
	}


	// ITU-R BT.2100 HLG (Hybrid Log-Gamma) transfer functions
	// threshold: 1/12 (encode), 0.5 (decode)

	@(require_results)
	_transfer_encode_hlg :: #force_inline proc "contextless" (x: f32) -> f32 {
		return math.sqrt(3.0 * x) if (x <= (1.0 / 12.0)) else (0.17883277 * math.ln(12.0 * x - 0.28466892) + 0.55991073)
	}

	@(require_results)
	_transfer_decode_hlg :: #force_inline proc "contextless" (x: f32) -> f32 {
		return ((x * x) / 3.0) if (x <= 0.5) else ((math.exp((x - 0.55991073) / 0.17883277) + 0.28466892) / 12.0)
	}
}
