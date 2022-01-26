#!/bin/sh
#
# Compila e instala LuaRocks para OpenResty.
#

program=luarocks
version=3.8.0
tarname=${program}-${version}.tar.gz
path=/opt/openresty/luajit

curl -fLO https://luarocks.org/releases/"$tarname"

tar xvf "$tarname"

cd "$program"-"$version" || exit

make clean

./configure \
  --prefix="$path" \
  --sysconfdir=/etc \
  --with-lua="$path"

make -j"$(nproc)"

while :; do
  su -c 'make install' && break
done
