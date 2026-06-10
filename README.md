# colourspace

*A pragmatic set of modern colour space transforms*


## Overview

`colourspace` provides correct, minimal colour space transforms optimised for UI frameworks and creative tooling, covering *OkLCh*, *OkLab*, *sRGB*, *Display P3*, *Rec. 2020*, and *Rec. 2100*. Transforms are direct matrix multiplications with pre-computed matrices derived with `tools/builder.odin`. Perceptual manipulation and colour appearance work uses OkLab as the working space.

Gamut mapping is explicitly **out of scope**. Out-of-gamut values are passed through as-is, and handling is left to the caller — typically shader-side in a display pipeline.


### High Dynamic Range (HDR) Support

*Rec. 2020* and *Rec. 2100* spaces along with *Rec. 709*, *Perceptual Quantizer* and *Hybrid Log-Gamma* transfer functions can be enabled with: `-define:COLOURSPACE_ENABLE_HDR`


## References

### Björn Ottosson

- [A perceptual color space for image processing](https://bottosson.github.io/posts/oklab/)


### International Color Consortium (ICC)

- [sRGB transfer function (IEC 61966-2-1)](https://www.color.org/chardata/rgb/srgb.xalter)
- [Display P3 Color Encoding](https://registry.color.org/rgb-registry/displayp3)


### ITU-R (Rec. 2020)

- [Recommendation ITU-R BT.2020-2 - Parameter values for ultra-high definition television systems](https://www.itu.int/rec/R-REC-BT.2020)
