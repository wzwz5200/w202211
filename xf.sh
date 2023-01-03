#!/bin/sh
##

# Set ARG
ARCH="64"
DOWNLOAD_PATH="/tmp/v2ray"

mkdir -p ${DOWNLOAD_PATH}
cd ${DOWNLOAD_PATH} || exit

TAG="v5.1.0"
echo "The v2ray latest version: ${TAG}"

# Download files
V2RAY_FILE="v2ray-linux-${ARCH}.zip"
DGST_FILE="v2ray-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${V2RAY_FILE}"
echo "Downloading binary file: ${DGST_FILE}"

# TAG=$(wget -qO- https://raw.githubusercontent.com/v2fly/docker/master/ReleaseTag | head -n1)
wget -O ${DOWNLOAD_PATH}/xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.0/Xray-linux-64.zip >/dev/null 2>&1


# Check SHA512

# Prepare
echo "Prepare to use"
unzip xray.zip && chmod +x xray.zip
mv xray  /usr/bin/
mv geosite.dat geoip.dat /usr/local/share/xray/
# cp config.json /etc/v2ray/config.json

# Set config file
cat <<EOF >/usr/bin/config.yaml
log:
  loglevel: info
dns:
  servers:
  - https+local://8.8.8.8/dns-query
inbounds:
- port: 8080
  protocol: trojan
  settings:
    clients:
    - password: "123456"
  streamSettings:
    network: ws
    wsSettings:
      path: /ws
  sniffing:
    enabled: true
    destOverride:
    - http
    - tls
outbounds:
- protocol: freedom
  tag: direct
  settings:
    domainStrategy: UseIPv4
EOF

# Clean
cd ~ || return
rm -rf ${DOWNLOAD_PATH:?}/*
echo "Install done"

echo "--------------------------------"
echo "Fly App Name: ${FLY_APP_NAME}"
echo "Fly App Region: ${FLY_REGION}"
echo "V2Ray UUID: ${UUID}"
echo "--------------------------------"

# Run v2ray
/usr/bin/xray -c /usr/bin/config.yaml
