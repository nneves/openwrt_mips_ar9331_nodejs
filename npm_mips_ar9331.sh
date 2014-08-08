#!/bin/bash

export BASEDIR=${PWD}/openwrtsource
export STAGING_DIR=${BASEDIR}/staging_dir
export NODEJSSOURCE=${PWD}/node-v0.10-5-mips

# Cross Toolchain
PREFIX=${STAGING_DIR}/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-

export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export AR=${PREFIX}ar
export RANLIB=${PREFIX}ranlib
export LINK=$CXX

export npm_config_arch=mips

#<path to the node source>
export npm_config_nodedir=${NODEJSSOURCE}

echo "Cross-compile NPM package for OpenWrt MIPS AR9331 SoC: "$1

npm install $1
#npm install serialport


