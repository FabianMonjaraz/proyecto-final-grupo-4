#!/usr/bin/env bash
info_team() {
  echo "\\\\\\ Made by: Team 4 ///"
  echo "\\\\\\     ᕦ(ò_óˇ)ᕤ    ///"
  echo "__________________________"
}
msg() {
  echo "> $1"
}
BKT="gs://crp-dev-cloudsrv-test-bkt07/"
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
