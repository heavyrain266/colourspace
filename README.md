# colourspace

*A pragmatic set of modern colour space transforms*

## Overview

The `colourspace` package provides correct, perceptual colour space transforms optimised for UI frameworks and creative tooling. Out-of-gamut values are passed through as-is, with gamut mappings left to the caller — typically shader-side in a display pipeline.

### Colour Spaces

Each one of the spaces covered below comes with related non-linear transfer curves and procedures (`encode_*`/`decode_*`).

- **Perceptual**:
	- *OkLab*, *OkLCh*,
- **Standard Dynamic Range**:
	- *sRGB*, *Display P3*, *Adobe RGB (1998)*,
- **High Dynamic Range**:
	- *Rec. 2020*, *Rec. 2100* (via PQ and HLG)

Furthermore, any "missing" tristimulus spaces are trivial to add using [`tools/builder.odin`](tools/builder.odin) script, which generates the bidirectional transform matrices.

## References

### Björn Ottosson

- [A perceptual color space for image processing](https://bottosson.github.io/posts/oklab/)

### International Color Consortium (ICC)

- [sRGB transfer function (IEC 61966-2-1)](https://registry.color.org/rgb-registry/srgb)

- [Adobe RGB (1998) Color Encoding](https://registry.color.org/rgb-registry/adobergb)

- [Display P3 Color Encoding](https://registry.color.org/rgb-registry/displayp3)


### ITU-R

- [Recommendation ITU-R BT.709-6 - Parameter values for the HDTV standards](https://www.itu.int/rec/R-REC-BT.709)

- [Recommendation ITU-R BT.2020-2 - Parameter values for ultra-high definition television systems](https://www.itu.int/rec/R-REC-BT.2020)
