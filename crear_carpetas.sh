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
BKT="gs://crp-dev-iac-testing-bkt07"
init $PROYECTO $BKT

msg "Creacion de carpetas"
mkdir DATA

if [[ $(gsutil ls $BKT/$ARCHIVO | wc -l) -ne 100 ]]; then 
  for I in $(seq -f "%03g" 100); do
    ARCHIVO="carpeta-$I/sinceramente.txt"
    mkdir DATA/carpeta-$I
    touch DATA/$ARCHIVO
  done
  msg "Copiado de datos al Bucket"
  gsutil -m cp -r DATA/* $BKT
fi

rm -rf DATA 2>/dev/null
msg "Carpetas en el Bucket $BKT: $(gsutil ls $BKT | wc -l)"
echo "============================================="
echo
info_team
