#!/usr/bin/env bash

init(){
  PROYECTO=$1
  BKT=$2
  if [[ $PROYECTO != $(gcloud info | grep project | awk '{print $2}' |tr -d "[]") ]]; then
    gcloud config set project crp-dev-iac-testing
  fi
  if [[ -z "$(gsutil ls | grep $BKT)" ]]; then
    gsutil mb -p crp-dev-iac-testing -c standard -l us -b on $BKT
    echo "> Creando bucket $BKT"
  else
    echo "> El bucket $BKT ya existe"
  fi
}

info_team() {
  echo "\\\\\\ Made by: Team 4 ///"
  echo "\\\\\\ Executed by: $USER  ///"
  echo "\\\\\\ Powered by: $(grep "^NAME" /etc/os-release | cut -d= -f2 | tr -d '"')  ///"
  echo "\\\\\\     ᕦ(ò_óˇ)ᕤ    ///"
  echo "__________________________"
}
msg() {
  echo "> $1"
}

PROYECTO=crp-dev-iac-testing
BKT="gs://crp-dev-iac-testing-bkt07/"
init $PROYECTO $BKT

msg "Creacion de carpetas"
mkdir DATA
for I in $(seq 100); do
  mkdir DATA/carpeta-$I
  touch DATA/carpeta-$I/sinceramente.txt
done
msg "Copiado de datos al Bucket"
gsutil -m cp -r DATA/* $BKT
rm -rf DATA
msg "Carpetas en el Bucket $BKT: $(gsutil ls $BKT | wc -l)"
echo "============================================="
echo
info_team
