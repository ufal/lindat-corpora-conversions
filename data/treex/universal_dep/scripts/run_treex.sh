#!/bin/bash

echo treex -L$1 Read::CoNLLU from=\"${@:3}\" Write::ManateeGeneral format=UD2.2 to=$2 unique_ids=1
treex -L$1 Read::CoNLLU from=\"${@:3}\" Write::ManateeGeneral format=UD2.2 to=$2 unique_ids=1
