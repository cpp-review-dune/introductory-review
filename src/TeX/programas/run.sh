#!/usr/bin/env bash

set -u
set -x
# ------------------------------------------------------------------
# Oromion Execute (binary).
#          Description
# ------------------------------------------------------------------
cd programas
cmake .
make

a=30
b=20
c=40
d=56
e=84
pizza=2

(printf '%s\n' "$a" "$b" "$c" "$d" "$e" | ./4) > salida4
# (./4 <<<"$a"$'\n'"$b"$'\n'"$c"$'\n'"$d"$'\n'"$e" ) > salida4
(printf '%s\n' "$a" "$b" "$c" "$d" "$e" | ./5) > salida5
(printf '%s\n' "$pizza" | ./Prueba1cin) > salidaPrueba1cin