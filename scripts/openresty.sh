#!/bin/sh
#
# Compila e instala OpenResty.
#
# $ pacman -S gd geoip
#

program=openresty
version=1.19.9.1
tarname=${program}-${version}.tar.gz

curl -fLO https://openresty.org/download/"$tarname"

tar xvf "$tarname"

cd "$program"-"$version" || exit

make clean

./configure \
  --prefix=/opt/"$program" \
  --user=http \
  --group=http \
  --with-threads \
  --with-file-aio \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module=dynamic \
  --with-http_geoip_module=dynamic \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module=dynamic \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module=dynamic \
  --with-stream_ssl_preread_module \
  --with-compat \
  --with-pcre-jit \
  --conf-path=/etc/"$program"/"$program".conf
  # --sbin-path=/usr/bin/"$program" \
  # --modules-path=/usr/lib/nginx/modules \
  # --error-log-path=/var/log/"$program"/error.log \
  # --pid-path=/var/run/"$program"/"$program".pid \
  # --lock-path=/var/run/"$program"/"$program".lock \
  # --http-log-path=/var/log/"$program"/access.log \
  # --http-client-body-temp-path=/var/tmp/"$program"/client_body \
  # --http-proxy-temp-path=/var/tmp/"$program"/proxy \
  # --http-fastcgi-temp-path=/var/tmp/"$program"/fastcgi \
  # --http-uwsgi-temp-path=/var/tmp/"$program"/uwsgi \
  # --http-scgi-temp-path=/var/tmp/"$program"/scgi \

make -j"$(nproc)"

while :; do
  su -c 'make install' && break
done

cat << EOF

Please add the following line to ~/.bashrc or ~/.zshrc:

export PATH=/opt/${program}/bin:/opt/${program}/nginx/sbin:/opt/${program}/luajit/bin:\$PATH

EOF
