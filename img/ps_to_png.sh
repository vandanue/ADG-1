#!/bin/bash

for f in *.ps; do
    convert ${f} ${f%.ps}.png
done
