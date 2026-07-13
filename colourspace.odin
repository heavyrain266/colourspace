package colourspace

import "core:math"


ENABLE_HDR :: #config(COLOURSPACE_ENABLE_HDR, false)


// Polar to cartesian coordinate de-composition.
@(require_results) oklch_to_oklab :: #force_inline proc "contextless" (lch: OkLch) -> OkLab {
	// a = chroma * cos(hue)
	a: f32 = (lch.y * math.cos(lch.z))

	// b = chroma * sin(hue)
	b: f32 = (lch.y * math.sin(lch.z))

	return OkLab{lch.x, a, b}
}

// Cartesian to polar coordinate re-composition.
@(require_results) oklab_to_oklch :: #force_inline proc "contextless" (lab: OkLab) -> OkLch {
	// hypot(a, b) gives chroma as the vector length sqrt(a*a + b*b),
	// avoiding overflow/underflow issues from squaring directly.
	c: f32 = math.hypot(lab.y, lab.z)

	// atan2(b, a) gives the hue angle, using both signs to get the correct quadrant.
	// Near the origin (near-zero chroma) hue is undefined, so default to 0.
	h: f32 = math.atan2(lab.z, lab.y) if (c >= math.F32_EPSILON) else 0.0

	return OkLch{lab.x, c, h}
}
