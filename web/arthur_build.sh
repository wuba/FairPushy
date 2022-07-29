#!/usr/bin/env bash
# Author: zhangkaixiao
#Date & Time: 2022-05-13 15:46:02
#Description: build arthur need

# 1. build flutter web app
flutter clean && flutter build web --base-href /git/fair_dynamic/web/fair_management_web
if [[ $? -ne 0 ]]; then
		echo "build flutter web app failed."
		exit 100
fi

# 2. clean and move
rm -rf dist
mv  ./build/web  ./dist

# 3. rename and replace
head=`git rev-parse --short HEAD`
echo "current git head: $head"

main_dart_old='main.dart.js'
main_dart_new="main.dart.${head}.js"
mv "./dist/${main_dart_old}" "./dist/${main_dart_new}"

for targetFile in `grep -lr ${main_dart_old} ./dist`
  do
    echo "do replace ${targetFile} ..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' -e "s|${main_dart_old}|${main_dart_new}|g" ${targetFile}
    else
      sed -i -e "s|${main_dart_old}|${main_dart_new}|g" ${targetFile}
    fi
  done

echo "finished arthur building..."



