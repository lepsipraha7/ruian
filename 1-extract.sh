XML_FILE=../../$1

cd ./source
rm stavebni_objekty/* adresni_mista/* ulice/* parcely/*

echo "Stavebni objekty"
cd stavebni_objekty
cat $XML_FILE |
sed '1,/^      <vf:StavebniObjekty>$/d' |
sed '/^      <\/vf:StavebniObjekty>/,$d' |
csplit -s -z -n10 - "/<vf:StavebniObjekt/" '{*}'
find . -name "x*"  -type f | xargs grep -L '500186' | xargs rm
cd ..

echo "Adresni mista"
cd adresni_mista
cat $XML_FILE |
sed '1,/^      <vf:AdresniMista>$/d' |
sed '/^      <\/vf:AdresniMista>/,$d' |
csplit -s -z -n10 - "/<vf:AdresniMisto/" '{*}'
cd ..

echo "Ulice"
cd ulice
cat $XML_FILE |
sed '1,/^      <vf:Ulice>$/d' |
sed '/^      <\/vf:Ulice>/,$d' |
csplit -s -z -n10 - "/<vf:Ulice/" '{*}'
cd ..

echo "Parcely"
cd parcely
cat $XML_FILE |
sed '1,/^      <vf:Parcely>$/d' |
sed '/^      <\/vf:Parcely>/,$d' |
csplit -s -z -n10 - "/<vf:Parcela/" '{*}'
cd ..

cd ..
