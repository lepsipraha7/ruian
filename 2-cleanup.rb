#!/usr/bin/env ruby

require 'fileutils'

parcely = []

puts "Stavebni objekty"
stavebni_objekty = Dir.glob("source/stavebni_objekty/*").collect{|filename|
  content = File.read(filename)
  id = content.match(/gml:id="SO\.(.*)"/)[1]
  parcely << $1 if content.match(/<pai:Id>(.*)<\/pai:Id>/)
  File.rename(filename, "source/stavebni_objekty/#{id}.xml")
  id
}

ulice = []

puts "Adresni mista"
Dir.glob("source/adresni_mista/*").each{|filename|
  content = File.read(filename)
  id = content.match(/gml:id="AD\.(.*)"/)[1]
  soi = content.match(/<soi:Kod>(.*)<\/soi:Kod>/)[1]
  if stavebni_objekty.member?(soi)
    File.rename(filename, "source/adresni_mista/#{id}.xml")
    ulice << $1 if content.match(/<uli:Kod>(.*)<\/uli:Kod>/)
  else
    FileUtils.rm(filename)
  end
}

puts "Ulice"
Dir.glob("source/ulice/*").each{|filename|
  id = File.read(filename).match(/gml:id="UL\.(.*)"/)[1]
  if ulice.member?(id)
    File.rename(filename, "source/ulice/#{id}.xml")
  else
    FileUtils.rm(filename)
  end
}

puts "Parcely"
Dir.glob("source/parcely/*").each{|filename|
  id = File.read(filename).match(/gml:id="PA\.(.*)"/)[1]
  if parcely.member?(id)
    File.rename(filename, "source/parcely/#{id}.xml")
  else
    FileUtils.rm(filename)
  end
}
