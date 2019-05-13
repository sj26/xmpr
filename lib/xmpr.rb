# XMPR
#
# XMP reader
#
# XMPR has some known namespaces, like "dc" for dublin core. See the NAMESPACES
# constants for a complete list.
#
# ## Example
#
#   xmp = XMPR.parse(File.read('xmp.xml'))
#   xmp["dc", "title"] # => "Amazing Photo"
#   xmp["photoshop", "Category"] # => "summer"
#   xmp["photoshop", "SupplementalCategories"] # => ["morning", "sea"]
#
# ## References
#
# * https://www.aiim.org/documents/standards/xmpspecification.pdf
#
module XMPR
  # Namespace shortcuts, and fallbacks for undeclared namespaces.
  NAMESPACES = {
    "aux" => "http://ns.adobe.com/exif/1.0/aux/",
    "crs" => "http://ns.adobe.com/camera-raw-settings/1.0/",  
    "cc" => "http://creativecommons.org/ns#",
    "dc" => "http://purl.org/dc/elements/1.1/",
    "exif" => "http://ns.adobe.com/exif/1.0/",
    "Iptc4xmpCore" => "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/",
    "pdf" => "http://ns.adobe.com/pdf/1.3/",
    "photoshop" => "http://ns.adobe.com/photoshop/1.0/",
    "rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "tiff" => "http://ns.adobe.com/tiff/1.0/",
    "x" => "adobe:ns:meta/",
    "xap" => "http://ns.adobe.com/xap/1.0/",
    "xmp" => "http://ns.adobe.com/xap/1.0/",
    "xmpidq" => "http://ns.adobe.com/xmp/Identifier/qual/1.0/",
    "xmpBJ" => "http://ns.adobe.com/xap/1.0/bj/",
    "xmpRights" => "http://ns.adobe.com/xap/1.0/rights/",
    "xmpMM" => "http://ns.adobe.com/xap/1.0/mm/",
    "xmpTPg" => "http://ns.adobe.com/xap/1.0/t/pg/",
  }

  DEFAULT_NAMESPACE = "http://ns.adobe.com/xap/1.0/"

  def self.parse(value)
    XMP.new(value)
  end

  class XMP
    # Nokogiri document of parsed xml
    attr_reader :xml

    def initialize(source)
      require "nokogiri"
      @xml = Nokogiri::XML(source)
    end

    def [](namespace_or_name, name=nil, **options)
      if name
        namespace = namespace_or_name
      else
        namespace, name = DEFAULT_NAMESPACE, namespace_or_name
      end

      if NAMESPACES.has_key? namespace
        namespace = NAMESPACES[namespace]
      end

      embedded_attribute(namespace, name) ||
        standalone_attribute(namespace, name, **options)
    end

    def to_hash
      {}.tap do |hash|
        xml.at("//rdf:Description", NAMESPACES).attributes.each do |(_, attribute)|
          hash[attribute.namespace.href] ||= {}
          hash[attribute.namespace.href][attribute.name] = attribute.value
        end
        xml.xpath("//rdf:Description/*", NAMESPACES).each do |element|
          hash[element.namespace.href] ||= {}
          hash[element.namespace.href][element.name] = standalone_value(element, lang: nil)
        end
      end
    end

    private

    def embedded_attribute(namespace, name)
      if element = xml.at("//rdf:Description[@ns:#{name}]", "rdf" => NAMESPACES["rdf"], "ns" => namespace)
        element.attribute_with_ns(name, namespace).text
      end
    end

    def standalone_attribute(namespace, name, lang: nil)
      if element = xml.xpath("//ns:#{name}", "ns" => namespace).first
        standalone_value(element, lang: lang)
      end
    end

    def standalone_value(element, lang:)
      if alt_element = element.xpath("./rdf:Alt", NAMESPACES).first
        alt_value(alt_element, lang: lang)
      elsif array_element = element.xpath("./rdf:Bag | ./rdf:Seq", NAMESPACES).first
        array_value(array_element)
      else
        raise "Don't know how to handle:\n#{element}"
      end
    end

    def alt_value(element, lang:)
      if lang && item = element.xpath("./rdf:li[@xml:lang=#{lang.inspect}]", NAMESPACES).first
        item.text
      elsif item = element.xpath(%{./rdf:li[@xml:lang="x-default"]}, NAMESPACES).first
        item.text
      elsif item = element.xpath("./rdf:li", NAMESPACES).first
        item.text
      end
    end

    def array_value(element)
      element.xpath("./rdf:li", NAMESPACES).map(&:text)
    end
  end
end
