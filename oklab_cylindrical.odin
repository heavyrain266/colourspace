package colourspace

import "core:math"


@(require_results)
oklch_to_oklab :: #force_inline proc "contextless" (lch: OKLCh) -> OKLab {
	l : f32 = lch.x
	a : f32 = lch.y * math.cos(lch.z)
	b : f32 = lch.y * math.sin(lch.z)

	return OKLab{l, a, b}
}

@(require_results)
oklab_to_oklch :: #force_inline proc "contextless" (lab: OKLab) -> OKLCh {
	l : f32 = lab.x
	c : f32 = math.sqrt(lab.y * lab.y + lab.z * lab.z)
	h : f32 = math.atan2(lab.z, lab.y)

	return OKLCh{l, c, h}
}



@(private)
okhsl_to_oklab :: #force_inline proc "contextless" (hsl: OKHSL) -> OKLab {
	return OKLab{}
}

@(private)
oklab_to_okhsl :: #force_inline proc "contextless" (lab: OKLab) -> OKHSL {
	return OKHSL{}
}



@(private)
okhsv_to_oklab :: #force_inline proc "contextless" (hsv: OKHSV) -> OKLab {
	return OKLab{}
}

@(private)
oklab_to_okhsv :: #force_inline proc "contextless" (lab: OKLab) -> OKHSV {
	return OKHSV{}
}
