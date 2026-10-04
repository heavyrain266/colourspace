package colourspace

import "core:testing"


@(private="file")
expect_close3 :: proc(t: ^testing.T, got, want: Colour, eps: f32 = 1e-6, loc := #caller_location) {
	testing.expectf(t,
		(abs(got[0] - want[0]) <= eps) &&
		(abs(got[1] - want[1]) <= eps) &&
		(abs(got[2] - want[2]) <= eps),
		"got %v, want %v (eps %.1e)", got, want, eps, loc = loc,
	)
}


@(test)
test_oklab_oklch_roundtrip :: proc(t: ^testing.T) {
	SAMPLES :: []Colour{
		{0.0,   0.0,   0.0},
		{1.0,   0.0,   0.0},
		{0.5,   0.1,   0.1},
		{0.7,  -0.12,  0.05},
		{0.3,   0.0,   0.0},
		{0.85,  0.15, -0.08},
	}

	for c in SAMPLES {
		expect_close3(t, oklab_from_oklch(oklab_to_oklch(c)), c)
	}
}

@(test)
test_oklab_oklch_known_values :: proc(t: ^testing.T) {
	expect_close3(t, oklab_to_oklch(Colour{0.0, 0.0, 0.0}), Colour{0.0, 0.0, 0.0})
	expect_close3(t, oklab_to_oklch(Colour{1.0, 0.0, 0.0}), Colour{1.0, 0.0, 0.0}, 2e-4)
	expect_close3(t, oklab_to_oklch(Colour{0.62795536, 0.22486316, 0.12584629}), Colour{0.6279554, 0.2576834, 0.5102274})
}


@(test)
test_srgb_oklab_roundtrip :: proc(t: ^testing.T) {
	SAMPLES :: []Colour{
		{0, 0, 0},
		{1, 1, 1},
		{1, 0, 0},
		{0, 1, 0},
		{0, 0, 1},
		{0.5, 0.5, 0.5},
		{0.2, 0.4, 0.8},
		{0.18, 0.18, 0.18},
	}

	for c in SAMPLES {
		expect_close3(t, srgb_from_oklab(srgb_to_oklab(c)), Colour{c.r, c.g, c.b})
	}
}

@(test)
test_srgb_oklab_known_values :: proc(t: ^testing.T) {
	expect_close3(t, srgb_to_oklab(Colour{0.0, 0.0, 0.0}), Colour{0.0, 0.0, 0.0})
	expect_close3(t, srgb_to_oklab(Colour{1.0, 1.0, 1.0}), Colour{1.0, 0.0, 0.0}, 2e-4)
	expect_close3(t, srgb_to_oklab(Colour{1.0, 0.0, 0.0}), Colour{0.6279536, 0.22482856, 0.12579221})
	expect_close3(t, srgb_to_oklab(Colour{0.0, 1.0, 0.0}), Colour{0.8664392, -0.23391807, 0.17941916})
	expect_close3(t, srgb_to_oklab(Colour{0.0, 0.0, 1.0}), Colour{0.45201367, -0.032432374, -0.311636})
}


@(test)
test_p3_oklab_roundtrip :: proc(t: ^testing.T) {
	SAMPLES :: []Colour{
		{0, 0, 0},
		{1, 1, 1},
		{1, 0, 0},
		{0, 1, 0},
		{0, 0, 1},
		{0.5, 0.5, 0.5},
		{0.3, 0.6, 0.1},
	}

	for c in SAMPLES {
		expect_close3(t, p3_from_oklab(p3_to_oklab(c)), c)
	}
}

@(test)
test_p3_oklab_known_values :: proc(t: ^testing.T) {
	expect_close3(t, p3_to_oklab(Colour{0.0, 0.0, 0.0}), Colour{0.0, 0.0, 0.0})
	expect_close3(t, p3_to_oklab(Colour{1.0, 1.0, 1.0}), Colour{1.0, 0.0, 0.0}, 2e-4)
	expect_close3(t, p3_to_oklab(Colour{0.0, 1.0, 0.0}), Colour{0.84882915, -0.30427128, 0.20789427})
}


@(test)
test_adobe_oklab_roundtrip :: proc(t: ^testing.T) {
	SAMPLES :: []Colour{
		{0, 0, 0},
		{1, 1, 1},
		{1, 0, 0},
		{0, 1, 0},
		{0, 0, 1},
		{0.5, 0.5, 0.5},
		{0.25, 0.4, 0.7},
	}

	for c in SAMPLES {
		expect_close3(t, adobe_from_oklab(adobe_to_oklab(c)), c)
	}
}

@(test)
test_adobe_oklab_known_values :: proc(t: ^testing.T) {
	expect_close3(t, adobe_to_oklab(Colour{0.0, 0.0, 0.0}), Colour{0.0, 0.0, 0.0})
	expect_close3(t, adobe_to_oklab(Colour{1.0, 1.0, 1.0}), Colour{1.0, 0.0, 0.0}, 2e-4)
	expect_close3(t, adobe_to_oklab(Colour{0.0, 1.0, 0.0}), Colour{0.81487155, -0.34715095, 0.18785919})
}


@(test)
test_rec2020_oklab_roundtrip :: proc(t: ^testing.T) {
	SAMPLES :: []Colour{
		{0, 0, 0},
		{1, 1, 1},
		{1, 0, 0},
		{0, 1, 0},
		{0, 0, 1},
		{0.5, 0.5, 0.5},
		{0.1, 0.3, 0.9},
	}

	for c in SAMPLES {
		expect_close3(t, rec2020_from_oklab(rec2020_to_oklab(c)), c)
	}
}

@(test)
test_rec2020_oklab_known_values :: proc(t: ^testing.T) {
	expect_close3(t, rec2020_to_oklab(Colour{0.0, 0.0, 0.0}), Colour{0.0, 0.0, 0.0})
	expect_close3(t, rec2020_to_oklab(Colour{1.0, 1.0, 1.0}), Colour{1.0, 0.0, 0.0}, 2e-4)
	expect_close3(t, rec2020_to_oklab(Colour{1.0, 0.0, 0.0}), Colour{0.6870868, 0.33268848, 0.14938195})
}
