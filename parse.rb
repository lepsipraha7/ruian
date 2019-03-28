require 'nokogiri'
require 'json'
require 'rails'

File.open("data/ulice.json","w") do |f|
  @ulice = Dir.glob("ulice/*").collect{|filename|
    data = Nokogiri::XML.parse(File.read("ruian_head.xml")+File.read(filename))
    {
      id: data.at("//uli:Kod").inner_text,
      nazev: data.at("//uli:Nazev").inner_text
    }
  }
  f << JSON.pretty_generate(@ulice)
end

File.open("data/adresni_mista.json","w") do |f|
  @adresni_mista = Dir.glob("adresni_mista/*").collect{|filename|
    data = Nokogiri::XML.parse(File.read("ruian_head.xml")+File.read(filename))
    if ulice_xml = data.at("//uli:Kod")
      ulice_kod = ulice_xml.inner_text
    end
    {
      id: data.at("//ami:Kod").inner_text,
      cislo_domovni: data.at("//ami:CisloDomovni").inner_text,
      cislo_orientacni: data.at("//ami:CisloOrientacni").try(:inner_text),
      stavebni_objekt_kod: data.at("//soi:Kod").inner_text,
      ulice: @ulice.detect{|u| u[:id]==ulice_kod}
    }
  }
  f << JSON.pretty_generate(@adresni_mista)
end

File.open("data/stavebni_objekty.json","w") do |f|
  @stavebni_objekty = Dir.glob("stavebni_objekty/*").collect{|filename|
    data = Nokogiri::XML.parse(File.read("ruian_head.xml")+File.read(filename))
    puts filename
    id = data.at("//soi:Kod").inner_text
    if cast_obce_xml = data.at("//coi:Kod")
      cast_obce = cast_obce_xml.inner_text
    end
    objekt = {
      id: id,
      cast_obce: cast_obce,
      adresni_mista: @adresni_mista.select{|m| m[:stavebni_objekt_kod]==id},
      typ_stavebniho_objektu: data.at("//soi:TypStavebnihoObjektuKod").inner_text,
      zpusob_vyuziti: data.at("//soi:ZpusobVyuzitiKod").try(:inner_text),
      druh_konstrukce_kdo: data.at("//soi:DruhKonstrukceKod").try(:inner_text),
      pocet_bytu: data.at("//soi:PocetBytu").try(:inner_text),
      pocet_podlazi: data.at("//soi:PocetPodlazi").try(:inner_text),
      pripojeni_kanalizace_kod: data.at("//soi:PripojeniKanalizaceKod").try(:inner_text),
      pripojeni_plyn_kod: data.at("//soi:PripojeniPlynKod").try(:inner_text),
      propojeni_vodovod_kod: data.at("//soi:PripojeniVodovodKod").try(:inner_text),
      vybaveni_vytahem_kod: data.at("//soi:VybaveniVytahemKod").try(:inner_text),
      zpusob_vytapeni_kod: data.at("//soi:ZpusobVytapeniKod").try(:inner_text)
    }
  }
  f << JSON.pretty_generate(@stavebni_objekty)
end
