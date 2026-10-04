package colourspace

import "core:math"
import "core:testing"


@(test)
test_encode_decode_piecewise_roundtrip :: proc(t: ^testing.T) {
	values: []f32 = {0.0, 0.0005, 0.0031308, 0.01, 0.05, 0.18, 0.5, 0.8, 1.0}

	for v in values {
		enc: f32 = encode_piecewise(v)
		dec: f32 = decode_piecewise(enc)
		testing.expectf(t, abs(dec - v) <= 1e-6, "got %.8f, want %.8f", dec, v)
	}
}

@(test)
test_piecewise_known_values :: proc(t: ^testing.T) {
	// black and white
	testing.expectf(t, abs(encode_piecewise(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", encode_piecewise(0.0), 0.0)
	testing.expectf(t, abs(encode_piecewise(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", encode_piecewise(1.0), 1.0)
	testing.expectf(t, abs(decode_piecewise(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", decode_piecewise(0.0), 0.0)
	testing.expectf(t, abs(decode_piecewise(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", decode_piecewise(1.0), 1.0)

	// threshold points
	testing.expectf(t, abs(encode_piecewise(0.0031308) - (0.0031308 * 12.92)) <= 1e-6, "got %.8f, want %.8f", encode_piecewise(0.0031308), 0.0031308 * 12.92)
	testing.expectf(t, abs(decode_piecewise(0.04045) - (0.04045 / 12.92)) <= 1e-6, "got %.8f, want %.8f", decode_piecewise(0.04045), 0.04045 / 12.92)
}


@(test)
test_encode_decode_rec709_roundtrip :: proc(t: ^testing.T) {
	values: []f32 = {0.0, 0.001, 0.018, 0.05, 0.18, 0.5, 0.8, 1.0}

	for v in values {
		enc: f32 = encode_rec_709(v)
		dec: f32 = decode_rec_709(enc)
		testing.expectf(t, abs(dec - v) <= 1e-6, "got %.8f, want %.8f", dec, v)
	}
}

@(test)
test_rec709_known_values :: proc(t: ^testing.T) {
	// black and white
	testing.expectf(t, abs(encode_rec_709(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", encode_rec_709(0.0), 0.0)
	testing.expectf(t, abs(encode_rec_709(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", encode_rec_709(1.0), 1.0)
	testing.expectf(t, abs(decode_rec_709(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", decode_rec_709(0.0), 0.0)
	testing.expectf(t, abs(decode_rec_709(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", decode_rec_709(1.0), 1.0)

	// linear segment threshold
	testing.expectf(t, abs(encode_rec_709(0.018) - (0.018 * 4.5)) <= 1e-3, "got %.8f, want %.8f", encode_rec_709(0.018), 0.018 * 4.5)
	testing.expectf(t, abs(decode_rec_709(0.081) - (0.081 / 4.5)) <= 1e-3, "got %.8f, want %.8f", decode_rec_709(0.081), 0.081 / 4.5)
 }


@(test)
test_encode_decode_adobe_rgb_roundtrip :: proc(t: ^testing.T) {
	values: []f32 = {0.0, 0.001, 0.01, 0.05, 0.18, 0.5, 0.8, 1.0}

	for v in values {
		enc: f32 = encode_adobe_rgb(v)
		dec: f32 = decode_adobe_rgb(enc)
		testing.expectf(t, abs(dec - v) <= 1e-6, "got %.8f, want %.8f", dec, v)
	}
}

@(test)
test_adobe_rgb_known_values :: proc(t: ^testing.T) {
	// black and white
	testing.expectf(t, abs(encode_adobe_rgb(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", encode_adobe_rgb(0.0), 0.0)
	testing.expectf(t, abs(encode_adobe_rgb(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", encode_adobe_rgb(1.0), 1.0)
	testing.expectf(t, abs(decode_adobe_rgb(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", decode_adobe_rgb(0.0), 0.0)
	testing.expectf(t, abs(decode_adobe_rgb(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", decode_adobe_rgb(1.0), 1.0)

	// mid-grey sanity (gamma ≈ 2.2)
	mid: f32 = encode_adobe_rgb(0.18)
	want_mid: f32 = math.pow(cast(f32)0.18, cast(f32)(1.0 / 2.19921875))
	testing.expectf(t, abs(mid - want_mid) <= 1e-6, "got %.8f, want %.8f", mid, want_mid)
 }


@(test)
test_encode_decode_pq_roundtrip :: proc(t: ^testing.T) {
	// PQ is defined on absolute luminance; we test normalised [0,1] range
	values: []f32 = {0.0, 0.0001, 0.001, 0.01, 0.1, 0.5, 0.9, 1.0}

	for v in values {
		enc: f32 = encode_pq(v)
		dec: f32 = decode_pq(enc)

		// PQ has high numerical sensitivity across non-linear bounds
		eps: f32 = 1e-4
		testing.expectf(t, abs(dec - v) <= eps, "got %.8f, want %.8f (eps %.1e)", dec, v, eps)
	}
}

@(test)
test_pq_known_values :: proc(t: ^testing.T) {
	// black and white
	testing.expectf(t, abs(encode_pq(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", encode_pq(0.0), 0.0)
	testing.expectf(t, abs(encode_pq(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", encode_pq(1.0), 1.0)
	testing.expectf(t, abs(decode_pq(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", decode_pq(0.0), 0.0)
	testing.expectf(t, abs(decode_pq(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", decode_pq(1.0), 1.0)
}


@(test)
test_encode_decode_hlg_roundtrip :: proc(t: ^testing.T) {
	values: []f32 = {0.0, 0.01, 0.05, (1.0 / 12.0), 0.2, 0.5, 0.8, 1.0}

	for v in values {
		enc: f32 = encode_hlg(v)
		dec: f32 = decode_hlg(enc)
		testing.expectf(t, abs(dec - v) <= 1e-6, "got %.8f, want %.8f", dec, v)
	}
}

@(test)
test_hlg_known_values :: proc(t: ^testing.T) {
	// black and white
	testing.expectf(t, abs(encode_hlg(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", encode_hlg(0.0), 0.0)
	testing.expectf(t, abs(encode_hlg(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", encode_hlg(1.0), 1.0)
	testing.expectf(t, abs(decode_hlg(0.0) - 0.0) <= 1e-6, "got %.8f, want %.8f", decode_hlg(0.0), 0.0)
	testing.expectf(t, abs(decode_hlg(1.0) - 1.0) <= 1e-6, "got %.8f, want %.8f", decode_hlg(1.0), 1.0)

	// threshold between square-root and log segments
	testing.expectf(t, abs(encode_hlg(1.0 / 12.0) - 0.5) <= 1e-6, "got %.8f, want %.8f", encode_hlg(1.0 / 12.0), 0.5)
	testing.expectf(t, abs(decode_hlg(0.5) - (1.0 / 12.0)) <= 1e-6, "got %.8f, want %.8f", decode_hlg(0.5), 1.0 / 12.0)
}
