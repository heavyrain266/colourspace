# colourspace

*A pragmatic set of modern colour space transforms*


## Overview

`colourspace` provides correct, minimal colour space transforms for UI frameworks and creative tooling, covering OKLCh, OKLab, sRGB, Display P3, and Rec. 2020. Transforms between linear RGB spaces are direct matrix multiplications with pre-computed matrices. Perceptual manipulation and colour appearance work uses OKLab as the working space.

Gamut mapping (in progress) follows Björn Ottosson's cusp-projection approach rather than the chroma-reduction method in CSS Color Module 4, which produces hue drift on sRGB displays, most visibly P3 blues rendering as purple.


### High Dynamic Range (HDR) Support

Rec. 2020 alongside (in-progress) Perceptual Quantizer and Hybrid Log-Gamma transfer functions are kept behind a compile-time flag `-define:COLOURSPACE_ENABLE_HDR`.


### Quick Start

Construct colours in any covered space, convert between them freely, and encode for display. All conversions are hue-preserving and operate in linear light unless explicitly encoded.


```odin
package main

import "core:fmt"
import cs "colourspace"


main :: proc() {
	// Construct colours
	lch:  cs.OKLCh       = cs.oklch(0.6456, 0.1003, 71.27)
	lab:  cs.OKLab       = cs.oklab(0.6456, 0.0337, 0.0942)
	srgb: cs.Linear_sRGB = cs.linear_srgb(0.5, 0.3, 0.1)
	p3:   cs.Linear_P3   = cs.linear_p3(0.5, 0.3, 0.1)

	// OKLab roundtrip
	linear_from_lch: cs.Linear_sRGB = cs.oklch_to_srgb(lch)
	lch_from_linear: cs.OKLCh       = cs.srgb_to_oklch(linear_from_lch)
	linear_from_lab: cs.Linear_sRGB = cs.oklab_to_srgb(lab)

	// Linear roundtrip
	p3_to_srgb: cs.Linear_sRGB = cs.p3_to_srgb(p3)
	srgb_to_p3: cs.Linear_P3   = cs.srgb_to_p3(srgb)

	// Gamma (de)compression
	decoded: cs.Linear_sRGB = cs.srgb_decode(cs.sRGB{0.5, 0.3, 0.1})
	encoded: cs.sRGB        = cs.linear_srgb_encode(decoded)

	fmt.println(linear_from_lch, lch_from_linear, linear_from_lab, p3_to_srgb, srgb_to_p3, decoded, encoded)
}
```


## References

### Björn Ottosson

- [A perceptual color space for image processing](https://bottosson.github.io/posts/oklab/)
- [Two new color spaces for color picking - Okhsv and Okhsl](https://bottosson.github.io/posts/colorpicker/)
- [sRGB gamut clipping](https://bottosson.github.io/posts/gamutclipping/)


### International Color Consortium (ICC)

- [sRGB transfer function (IEC 61966-2-1)](https://www.color.org/chardata/rgb/srgb.xalter)
- [Display P3 Color Encoding](https://registry.color.org/rgb-registry/displayp3)


### ITU-R (Rec. 2020)

- [Recommendation ITU-R BT.2020-2 - Parameter values for ultra-high definition television systems](https://www.itu.int/rec/R-REC-BT.2020)
