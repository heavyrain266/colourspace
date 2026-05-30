package colourspace

import "core:math"


@(require_results)
linear_srgb_encode :: #force_inline proc "contextless" (srgb: Linear_sRGB) -> sRGB {
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
linear_p3_encode :: #force_inline proc "contextless" (p3: Linear_P3) -> Display_P3 {
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


@(require_results)
linear_rec2020_encode :: #force_inline proc "contextless" (rec: Linear_Rec2020) -> Rec2020 {
	return Rec2020{
		_transfer_encode(rec.r),
		_transfer_encode(rec.g),
		_transfer_encode(rec.b),
	}
}

@(require_results)
rec2020_decode :: #force_inline proc "contextless" (rec: Rec2020) -> Linear_Rec2020 {
	return Linear_Rec2020{
		_transfer_decode(rec.r),
		_transfer_decode(rec.g),
		_transfer_decode(rec.b),
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
