#egrep -n "<.?vf:StavebniObjekt[ >]" 20190301_OB_554782_UZSZ.xml > StavebniObjekty.list

cd stavebni_objekt
split -a10 -p "<vf:StavebniObjekt" 20190301_OB_554782_UZSZ.xml
find . -name "x*"  -type f | xargs grep -Z -L '500186' | xargs rm
rm xaaaaaaaaaa
#oeditovat posledni
cd ..

cd adresni_misto
split -a10 -p "<vf:AdresniMisto" ../20190301_OB_554782_UZSZ.xml
rm xaaaaaaaaaa
# oeditovat posledni
cd ..

cd ulice
split -a10 -p "<vf:Ulice" ../20190301_OB_554782_UZSZ.xml
rm xaaaaaaaaaa
rm xaaaaaaaaab
# oeditovat posledni
cd ..

cd parcely
split -a10 -p "<vf:Parcela" ../20190301_OB_554782_UZSZ.xml
rm xaaaaaaaaaa
# oeditovat posledni
cd ..
