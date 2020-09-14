#!/bin/bash

for var in $(compgen -v | grep -Ev '^(BASH)'); do
    echo "$var=${!var}"
done
