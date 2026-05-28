package colourspace

import "core:math"


@(require_results)
srgb_encode :: #force_inline proc "contextless" (linear: Linear_sRGB) -> sRGB {
	return sRGB{
		_transfer_encode(linear.r),
		_transfer_encode(linear.g),
		_transfer_encode(linear.b),
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
p3_encode :: #force_inline proc "contextless" (linear: Linear_P3) -> Display_P3 {
	return Display_P3{
		_transfer_encode(linear.r),
		_transfer_encode(linear.g),
		_transfer_encode(linear.b),
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
// linearisation threshold: 0.04045, gamma threshold: 0.0031308

@(require_results)
_transfer_encode :: #force_inline proc "contextless" (x: f32) -> f32 {
	return (1.055 * math.pow(x, 1.0 / 2.4) - 0.055) if (x >= 0.0031308) else (x * 12.92)
}

@(require_results)
_transfer_decode :: #force_inline proc "contextless" (x: f32) -> f32 {
	return math.pow((x + 0.055) / 1.055, 2.4) if (x >= 0.04045) else (x / 12.92)
}
