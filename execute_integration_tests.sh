#!/usr/bin/env sh
if [ ${#1} -eq 0 ]
then
    for filename in integration_test/*_test.dart; do
        flutter drive --driver=test_driver/integration_test_driver.dart --target="$filename" | tee test_output/"$filename".txt
    done
else
    for filename in "$@"; do
        flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/"$filename"  | tee test_output/integration_test/"$filename".txt
    done
fi

