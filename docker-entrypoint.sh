#!/bin/bash

REPO="https://$GITHUB_KEY@github.com/lepsipraha7/ruian.git"
git config --global user.email "bot@lepsipraha7.cz"
git config --global user.name "LepsiPraha7 import bot"

cd /source
echo "Fetching from github.com..."
git pull origin source
current_url=`curl -s "http://vdp.cuzk.cz/vdp/ruian/vymennyformat/seznamlinku?vf.pu=S&_vf.pu=on&_vf.pu=on&vf.cr=U&vf.up=OB&vf.ds=Z&vf.vu=Z&_vf.vu=on&_vf.vu=on&_vf.vu=on&_vf.vu=on&vf.uo=O&ob.kod=554782&search=Vyhledat" | head -1`

if [[ $(< last_url.txt) != "$current_url" ]]; then
  cd .. &&
  echo "Fetching from vdp.cuzk.cz..." &&
  curl "$current_url" | bsdtar -xvf- &&
  ./1-extract.sh *_OB_554782_UZSZ.xml &&
  ./2-cleanup.rb &&
  echo $current_url > source/last_url.txt &&
  echo "Pushing to github.com..." &&
  cd /source &&
  commit_message="Import from $(< last_url.txt)" &&
  git add . &&
  git diff --quiet &&
  git diff --staged --quiet ||
  (git commit -am "$commit_message" && git push $REPO source)
else
  echo "Already processed"
fi
