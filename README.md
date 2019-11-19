# XMP Reader

[![Build Status](https://travis-ci.org/sj26/xmpr?branch=master)](https://travis-ci.org/sj26/xmpr)

XMP Reader in Ruby. Parse XMP data extracted from an image into rich data types.

## Usage

Use something like imagemagick to extract the XMP, then read it with this class:

```ruby
require "xmpr"
raw_xmp = `convert image.jpg xmp:-`
xmp = XMPR.parse(raw_xmp)
xmp["dc", "title"] # => "Amazing Photo"
xmp["photoshop", "Category"] # => "summer"
xmp["photoshop", "SupplementalCategories"] # => ["morning", "sea"]
```

The xmp instance fetches namespaced attributes. You can use fully qualified namespaces, or some namespaces have shortcuts:

```
xmp["http://purl.org/dc/elements/1.1/", "title"] # => "Amazing Photo"
xmp["dc", "title"] # => "Amazing Photo" (same thing)
```

The following namespaces have shortcuts:

 * `aux` — `http://ns.adobe.com/exif/1.0/aux/`
 * `cc` — `http://creativecommons.org/ns#` ([Creative Commons](http://creativecommons.org))
 * `crs` — `http://ns.adobe.com/camera-raw-settings/1.0/`
 * `dc` — `http://purl.org/dc/elements/1.1/` ([Dublin Core](http://dublincore.org/))
 * `exif` — `http://ns.adobe.com/exif/1.0/`
 * `Iptc4xmpCore` — `http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/` ([IPTC](http://iptc.org/))
 * `pdf` — `http://ns.adobe.com/pdf/1.3/`
 * `photoshop` — `http://ns.adobe.com/photoshop/1.0/`
 * `rdf` — `http://www.w3.org/1999/02/22-rdf-syntax-ns#`
 * `tiff` — `http://ns.adobe.com/tiff/1.0/`
 * `x` — `adobe:ns:meta/`
 * `xap` — `http://ns.adobe.com/xap/1.0/`
 * `xmp` — `http://ns.adobe.com/xap/1.0/` ([XMP](http://www.adobe.com/products/xmp.html))
 * `xmpidq` — `http://ns.adobe.com/xmp/Identifier/qual/1.0/`
 * `xmpBJ` — `http://ns.adobe.com/xap/1.0/bj/`
 * `xmpRights` — `http://ns.adobe.com/xap/1.0/rights/`
 * `xmpMM` — `http://ns.adobe.com/xap/1.0/mm/`
 * `xmpTPg` — `http://ns.adobe.com/xap/1.0/t/pg/`

## Thanks

Refactored from [XMP][xmp-gem]. Inspired by [ExifTool][exiftool].

  [xmp-gem]: https://github.com/amberbit/xmp
  [exiftool]: http://www.sno.phy.queensu.ca/~phil/exiftool/

## References

* XMP specification
  ([Part 1](http://www.adobe.com/content/dam/Adobe/en/devnet/xmp/pdfs/XMPSpecificationPart1.pdf),
  [Part 2](http://www.adobe.com/content/dam/Adobe/en/devnet/xmp/pdfs/XMPSpecificationPart2.pdf),
  [Part 3](http://www.adobe.com/content/dam/Adobe/en/devnet/xmp/pdfs/XMPSpecificationPart3.pdf))

## License

MIT license, see [LICENSE](LICENSE).
