package colourspace

import "core:math"


ENABLE_HDR :: #config(COLOURSPACE_ENABLE_HDR, false)


@(require_results)
oklch_to_oklab :: #force_inline proc "contextless" (lch: OkLch) -> OkLab {
	a: f32 = (lch.y * math.cos(lch.z))
	b: f32 = (lch.y * math.sin(lch.z))

	return OkLab{lch.x, a, b}
}

@(require_results)
oklab_to_oklch :: #force_inline proc "contextless" (lab: OkLab) -> OkLch {
	c: f32 = math.hypot(lab.y, lab.z)
	h: f32 = math.atan2(lab.z, lab.y) if c >= math.F32_EPSILON else 0.0

	return OkLch{lab.x, c, h}
}
