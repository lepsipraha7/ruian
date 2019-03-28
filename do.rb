require 'fileutils'
# match_list = File.read("StavebniObjekty.list").split("\n")
#
# @list = {}
# match_list.each_slice(2) { |starts, ends|
#   puts starts.match(/gml:id="SO(.*)"/)[1]
#   @list[starts.match(/gml:id="SO\.(.*)"/)[1]]=[
#   starts.split(":").first,
#   ends.split(":").first
#   ] }
#
# puts list
#
parcely = []

stavebni_objekty = Dir.glob("stavebni_objekty/*").collect{|filename|
  content = File.read(filename)
  id = content.match(/gml:id="SO\.(.*)"/)[1]
  parcely << $1 if content.match(/<pai:Id>(.*)<\/pai:Id>/)
  File.rename(filename, "stavebni_objekty/#{id}.xml")
  id
}

ulice = []

Dir.glob("adresni_mista/*").each{|filename|
  content = File.read(filename)
  puts filename
  id = content.match(/gml:id="AD\.(.*)"/)[1]
  soi = content.match(/<soi:Kod>(.*)<\/soi:Kod>/)[1]
  ulice << $1 if content.match(/<uli:Kod>(.*)<\/uli:Kod>/)
  if stavebni_objekty.member?(soi)
    File.rename(filename, "adresni_mista/#{id}.xml")
  else
    FileUtils.rm(filename)
  end
}

Dir.glob("ulice/*").each{|filename|
  puts filename
  id = File.read(filename).match(/gml:id="UL\.(.*)"/)[1]
  if ulice.member?(id)
    File.rename(filename, "ulice/#{id}.xml")
  else
    FileUtils.rm(filename)
  end
}

Dir.glob("parcely/*").each{|filename|
  puts filename
  id = File.read(filename).match(/gml:id="PA\.(.*)"/)[1]
  if parcely.member?(id)
    File.rename(filename, "parcely/#{id}.xml")
  else
    FileUtils.rm(filename)
  end
}
