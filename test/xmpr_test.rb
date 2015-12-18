# encoding: UTF-8

require "test_helper"

class XMPRTest < MiniTest::Test
  def xmp
    XMPR.parse(File.read("test/fixtures/xmp.xml"))
  end

  def test_embedded_attribute
    assert_equal "Kategoria", xmp["photoshop", "Category"]
  end

  def test_explicit_namespace
    assert_equal "Miejsce", xmp["http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/", "Location"]
  end

  def test_standalone_alt_attribute
    assert_equal "Tytuł zdjęcia", xmp["dc", "title"]
  end

  def test_standalone_alt_attribute_with_lang
    assert_equal "Something else", xmp["dc", "title", lang: "en-US"]
  end

  def test_standalone_bag_attribute
    assert_equal ["Słowa kluczowe", "Opis zdjęcia"], xmp["dc", "subject"]
  end

  def test_standalone_seq_attribute
    assert_equal ["John Doe", "Jane Smith"], xmp["dc", "creator"]
  end

  def test_to_hash
    assert_equal({"http://www.w3.org/1999/02/22-rdf-syntax-ns#"=>{"about"=>""}, "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/"=>{"Location"=>"Miejsce"}, "http://ns.adobe.com/photoshop/1.0/"=>{"Category"=>"Kategoria"}, "http://purl.org/dc/elements/1.1/"=>{"title"=>"Tytuł zdjęcia", "subject"=>["Słowa kluczowe", "Opis zdjęcia"], "creator"=>["John Doe", "Jane Smith"]}}, xmp.to_hash)
  end
end
