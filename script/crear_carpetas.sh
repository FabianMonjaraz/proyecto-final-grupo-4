#!/usr/bin/env bash

PROYECTO=crp-dev-iac-testing
BKT="gs://crp-dev-iac-testing-bkt07"

info_team() {
  echo "========= ᕦ(ò_óˇ)ᕤ =========="
  echo "\\\\\\ Made by: Team 4 ///"
  echo "\\\\\\ Executed by: $USER  ///"
  echo "\\\\\\ Powered by: $(grep "^NAME" /etc/os-release | cut -d= -f2 | tr -d '"')  ///"
  echo "__________________________"
}

msg() {
  echo "> $1"
}

init(){
  if [[ $PROYECTO != $(gcloud info | grep project | awk '{print $2}' |tr -d "[]") ]]; then
    gcloud config set project crp-dev-iac-testing
  fi
  if [[ -z "$(gsutil ls | grep $BKT)" ]]; then
    gsutil mb -p crp-dev-iac-testing -c standard -l us -b on $BKT
    gsutil label ch -l grupo:grupo4 $BKT
    gsutil label ch -l proyecto:golondrinas $BKT
    echo "> Creando bucket $BKT"
  else
    echo "> El bucket $BKT ya existe, omitiendo su creacion"
  fi
}

crear_carpetas() {
msg "Subida de datos al Bucket"
msg "Limpieza del Bucket"
gsutil -m rm -r $BKT/*
mkdir grupo-04/
for I in $(seq -f "%03g" 100); do
  mkdir grupo-04/carpeta-$I
  touch grupo-04/carpeta-$I/sinceramente.txt
done
gsutil -m cp -r grupo-04 $BKT
rm -rf grupo-04
}

test_bucket_formateado() {
  NUM_CARPETAS=$(gsutil du $BKT | grep -vE "carpeta-.../sinceramente.txt|grupo-04/$" | wc -l)
[[ $NUM_CARPETAS -eq 100 ]] && echo 1 || echo 0
}

buscar_archivos_no_vacios() {
  gsutil du $BKT | grep -vE "sinceramente.txt|grupo-04/$" | grep "^[^0]" | awk '{print $2}'

}


init
[[ $(test_bucket_formateado) -eq 0 ]] && crear_carpetas || msg "Omitiendo creacion de carpetas"
msg "Busqueda de archivos no vacios dentro del bucket"
LOG=grupo-04-$(date +"%d-%m-%y-%H-%M-%S").log
buscar_archivos_no_vacios 
#buscar_archivos_no_vacios | tee $LOG

echo "grupo-04, $(grep "^NAME" /etc/os-release | cut -d= -f2 | tr -d '"'), $USER" >> $LOG

info_team
