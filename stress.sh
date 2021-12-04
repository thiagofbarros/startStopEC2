#!/bin/bash

while [ $1 -le 10000 ]; do
    curl s -o /dev/null -v 157.230.202.219:80
done    