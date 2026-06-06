package builder

import "core:fmt"
import "core:math/linalg"


D65 :: linalg.Vector2f64{0.3127, 0.3290}
XYZ :: linalg.Vector3f64


SRGB_PRIMARIES :: linalg.Matrix3f64{
	0.64, 0.33, 0.03,
	0.30, 0.60, 0.10,
	0.15, 0.06, 0.79,
}

P3_PRIMARIES :: linalg.Matrix3f64{
	0.680, 0.320, 0.000,
	0.265, 0.690, 0.045,
	0.150, 0.060, 0.790,
}

BT2020_PRIMARIES :: linalg.Matrix3f64{
	0.708, 0.292, 0.000,
	0.170, 0.797, 0.033,
	0.131, 0.046, 0.823,
}

XYZ_TO_LINEAR_LMS :: linalg.Matrix3f64{
	0.8189330101, 0.3618667424, -0.1288597137,
	0.0329845436, 0.9293118715, 0.0361456387,
	0.0482003018, 0.2643662691, 0.6338517070,
}

@(require_results)
rgb_to_xyz :: #force_inline proc "contextless" (p: linalg.Matrix3f64) -> linalg.Matrix3f64 {
	r: XYZ = {p[0, 0], p[0, 1], p[0, 2]} / p[0, 1]
	g: XYZ = {p[1, 0], p[1, 1], p[1, 2]} / p[1, 1]
	b: XYZ = {p[2, 0], p[2, 1], p[2, 2]} / p[2, 1]
	m: linalg.Matrix3f64 = linalg.Matrix3f64 {
		r.x, g.x, b.x,
		r.y, g.y, b.y,
		r.z, g.z, b.z,
	}

	w: XYZ = XYZ{D65.x, D65.y, 1.0 - D65.x - D65.y} / D65.y
	s: XYZ = linalg.mul(linalg.inverse(m), w)
	diag_s: linalg.Matrix3f64 = linalg.Matrix3f64{
		s.x, 0,   0,
		0,   s.y, 0,
		0,   0,   s.z,
	}

	return linalg.mul(m, diag_s)
}

@(require_results)
rgb_to_lms :: #force_inline proc "contextless" (m: linalg.Matrix3f64) -> linalg.Matrix3f64 {
	return linalg.mul(XYZ_TO_LINEAR_LMS, rgb_to_xyz(m))
}

emit :: #force_inline proc(name: string, m: linalg.Matrix3f32) {
	fmt.println(name, ":: #row_major matrix[3, 3]f32{")
	for row in 0..<3 do fmt.printfln("\t% .10f, % .10f, % .10f,", m[row, 0], m[row, 1], m[row, 2])
	fmt.println("}\n")
}


main :: proc() {
	srgb_to_lms:    linalg.Matrix3f64 = rgb_to_lms(SRGB_PRIMARIES)
	p3_to_lms:      linalg.Matrix3f64 = rgb_to_lms(P3_PRIMARIES)
	bt2020_to_lms:  linalg.Matrix3f64 = rgb_to_lms(BT2020_PRIMARIES)

	srgb_to_p3:     linalg.Matrix3f64 = linalg.mul(linalg.inverse(p3_to_lms), srgb_to_lms)
	srgb_to_bt2020: linalg.Matrix3f64 = linalg.mul(linalg.inverse(bt2020_to_lms), srgb_to_lms)
	p3_to_bt2020:   linalg.Matrix3f64 = linalg.mul(linalg.inverse(bt2020_to_lms), p3_to_lms)


	fmt.println("// Products of XYZ <-> sRGB and XYZ <-> LMS matrices.\n")
	emit("_LINEAR_LMS_TO_LINEAR_SRGB", cast(linalg.Matrix3f32)(linalg.inverse(srgb_to_lms)))
	emit("_LINEAR_SRGB_TO_LINEAR_LMS", cast(linalg.Matrix3f32)(srgb_to_lms))


	fmt.println("// Products of XYZ <-> P3 and XYZ <-> LMS matrices.\n")
	emit("_LINEAR_LMS_TO_LINEAR_P3", cast(linalg.Matrix3f32)(linalg.inverse(p3_to_lms)))
	emit("_LINEAR_P3_TO_LINEAR_LMS", cast(linalg.Matrix3f32)(p3_to_lms))


	fmt.println("// Products of XYZ <-> Rec. 2020 and XYZ <-> LMS matrices.\n")
	emit("_LINEAR_LMS_TO_LINEAR_REC_2020", cast(linalg.Matrix3f32)(linalg.inverse(bt2020_to_lms)))
	emit("_LINEAR_REC_2020_TO_LINEAR_LMS", cast(linalg.Matrix3f32)(bt2020_to_lms))



	fmt.println("// Products of XYZ <-> sRGB and XYZ <-> P3 matrices.\n")
	emit("_LINEAR_SRGB_TO_LINEAR_P3", cast(linalg.Matrix3f32)(srgb_to_p3))
	emit("_LINEAR_P3_TO_LINEAR_SRGB", cast(linalg.Matrix3f32)(linalg.inverse(srgb_to_p3)))


	fmt.println("// Products of XYZ <-> sRGB and XYZ <-> Rec. 2020 matrices.\n")
	emit("_LINEAR_SRGB_TO_LINEAR_REC_2020", cast(linalg.Matrix3f32)(srgb_to_bt2020))
	emit("_LINEAR_REC_2020_TO_LINEAR_SRGB", cast(linalg.Matrix3f32)(linalg.inverse(srgb_to_bt2020)))


	fmt.println("// Products of XYZ <-> P3 and XYZ <-> Rec. 2020 matrices.\n")
	emit("_LINEAR_P3_TO_LINEAR_REC_2020", cast(linalg.Matrix3f32)(p3_to_bt2020))
	emit("_LINEAR_REC_2020_TO_LINEAR_P3", cast(linalg.Matrix3f32)(linalg.inverse(p3_to_bt2020)))
}
