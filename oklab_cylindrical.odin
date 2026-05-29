package colourspace

import "core:math"


@(require_results)
oklch_to_oklab :: #force_inline proc "contextless" (lch: OKLCh) -> OKLab {
	return OKLab{lch.x, (lch.y * math.cos(lch.z)), (lch.y * math.sin(lch.z))}
}

@(require_results) // Hue in radians; use `math.to_degrees(h)` if needed
oklab_to_oklch :: #force_inline proc "contextless" (lab: OKLab) -> OKLCh {
	return OKLCh{lab.x, math.hypot(lab.y, lab.z), math.atan2(lab.z, lab.y)}
}


@(private)
okhsv_to_oklab :: #force_inline proc "contextless" (hsv: OKHSV) -> OKLab {
	return OKLab{}
}

@(private)
oklab_to_okhsv :: #force_inline proc "contextless" (lab: OKLab) -> OKHSV {
	return OKHSV{}
}


@(private)
okhsl_to_oklab :: #force_inline proc "contextless" (hsl: OKHSL) -> OKLab {
	return OKLab{}
}

@(private)
oklab_to_okhsl :: #force_inline proc "contextless" (lab: OKLab) -> OKHSL {
	return OKHSL{}
}
