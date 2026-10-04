package colourspace

import "core:math"


oklab_to_oklch :: proc "contextless" (lab: Colour) -> Colour #no_bounds_check {
	c: f32 = math.hypot(lab.g, lab.b)
	h: f32 = math.atan2(lab.b, lab.g) if (c >= math.F32_EPSILON) else 0.0

	return Colour{lab.r, c, h}
}

oklab_from_oklch :: proc "contextless" (lch: Colour) -> Colour #no_bounds_check {
	a: f32 = (lch.g * math.cos(lch.b))
	b: f32 = (lch.g * math.sin(lch.b))

	return Colour{lch.r, a, b}
}


srgb_to_oklab :: proc "contextless" (srgb: Colour) -> Colour #no_bounds_check {
	lms: Colour = (LINEAR_SRGB_TO_LINEAR_LMS * srgb)

	return (LINEAR_LMS_TO_OKLAB * Colour{
		math.cbrt(lms.r),
		math.cbrt(lms.g),
		math.cbrt(lms.b),
	})
}

srgb_from_oklab :: proc "contextless" (lab: Colour) -> Colour #no_bounds_check {
	lms: Colour = (OKLAB_TO_LINEAR_LMS * lab)

	return (LINEAR_LMS_TO_LINEAR_SRGB * Colour{
		(lms.r * lms.r * lms.r),
		(lms.g * lms.g * lms.g),
		(lms.b * lms.b * lms.b),
	})
}


p3_to_oklab :: proc "contextless" (p3: Colour) -> Colour #no_bounds_check {
	lms: Colour = (LINEAR_DISPLAY_P3_TO_LINEAR_LMS * p3)

	return (LINEAR_LMS_TO_OKLAB * Colour{
		math.cbrt(lms.x),
		math.cbrt(lms.y),
		math.cbrt(lms.z),
	})
}

p3_from_oklab :: proc "contextless" (lab: Colour) -> Colour #no_bounds_check {
	lms: Colour = (OKLAB_TO_LINEAR_LMS * lab)

	return (LINEAR_LMS_TO_LINEAR_DISPLAY_P3 * Colour{
		(lms.r * lms.r * lms.r),
		(lms.g * lms.g * lms.g),
		(lms.b * lms.b * lms.b),
	})
}


adobe_to_oklab :: proc "contextless" (rgb: Colour) -> Colour #no_bounds_check {
	lms: Colour = (LINEAR_ADOBE_RGB_TO_LINEAR_LMS * rgb)

	return (LINEAR_LMS_TO_OKLAB * Colour{
		math.cbrt(lms.r),
		math.cbrt(lms.g),
		math.cbrt(lms.b),
	})
}

adobe_from_oklab :: proc "contextless" (lab: Colour) -> Colour #no_bounds_check {
	lms: Colour = (OKLAB_TO_LINEAR_LMS * lab)

	return (LINEAR_LMS_TO_LINEAR_ADOBE_RGB * Colour{
		(lms.r * lms.r * lms.r),
		(lms.g * lms.g * lms.g),
		(lms.b * lms.b * lms.b),
	})
}


rec2020_to_oklab :: proc "contextless" (rec2020: Colour) -> Colour #no_bounds_check {
	lms: Colour = (LINEAR_REC2020_TO_LINEAR_LMS * rec2020)

	return (LINEAR_LMS_TO_OKLAB * Colour{
		math.cbrt(lms.x),
		math.cbrt(lms.y),
		math.cbrt(lms.z),
	})
}

rec2020_from_oklab :: proc "contextless" (lab: Colour) -> Colour #no_bounds_check {
	lms: Colour = (OKLAB_TO_LINEAR_LMS * lab)

	return (LINEAR_LMS_TO_LINEAR_REC2020 * Colour{
		(lms.r * lms.r * lms.r),
		(lms.g * lms.g * lms.g),
		(lms.b * lms.b * lms.b),
	})
}
