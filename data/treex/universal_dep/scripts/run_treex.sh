#!/bin/bash

treex -L$1 Read::CoNLLU from="$2" Write::ManateeGeneral format=UD2.2 to=$3 unique_ids=1
