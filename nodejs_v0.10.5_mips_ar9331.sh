#!/bin/bash

trap "exit" SIGHUP  SIGINT SIGTERM

#-------------------------------------------------------------------------
# Install dependencies
#-------------------------------------------------------------------------
sudo apt-get install -y build-essential
sudo apt-get install -y subversion
sudo apt-get install -y git-core
sudo apt-get install -y patch
sudo apt-get install -y bzip2
sudo apt-get install -y flex
sudo apt-get install -y bison
sudo apt-get install -y autoconf
sudo apt-get install -y gettext
sudo apt-get install -y unzip
sudo apt-get install -y libncurses5-dev
sudo apt-get install -y ncurses-term
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y gawk
sudo apt-get install -y libz-dev
sudo apt-get install -y libssl-dev

#-------------------------------------------------------------------------
# Prepare OpenWrt SDK
#-------------------------------------------------------------------------
# OpenWrt Attitude Adjustment : 12.09
# https://dev.openwrt.org/log/branches/attitude_adjustment?mode=follow_copy

svn checkout -r 41803 svn://svn.openwrt.org/openwrt/branches/attitude_adjustment openwrtsource

cd openwrtsource
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make prereq
#make menuconfig
cp ../.config ./
time make V=99
cd ..

#echo "Please enter some input: "
#read input_variable

#-------------------------------------------------------------------------
# Cross-compile V8 and Node.js
#-------------------------------------------------------------------------
# Get custom version of v8m-rb with patch to MIPS platfform
git clone https://github.com/paul99/v8m-rb.git -b dm-dev-mipsbe
# Get node.js version 0.10.5
git clone https://github.com/joyent/node.git -b v0.10.5-release node-v0.10-5-mips

# Save current path
export NODEJS_MIPS_AR9331=${PWD}

# Sets up aliases for gcc & binutils, to support cross-compilation of v8 with gyp.
export V8SOURCE=${PWD}/v8m-rb
export NODEJSSOURCE=${PWD}/node-v0.10-5-mips

export BASEDIR=${PWD}/openwrtsource
export STAGING_DIR=${BASEDIR}/staging_dir

# Code Sourcery 2012.03-63 release
PREFIX=${STAGING_DIR}/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-

export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export AR=${PREFIX}ar
export RANLIB=${PREFIX}ranlib
export LINK=$CXX

# set toolchain library path
LIBPATH=${STAGING_DIR}/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33.2/lib/

#export LDFLAGS=-L${LIBPATH}
export LDFLAGS='-Wl,-rpath-link '${LIBPATH}

export GYPFLAGS="-Dv8_use_mips_abi_hardfloat=false -Dv8_can_use_fpu_instructions=false"

#echo ${V8SOURCE}
#echo ${NODEJSSOURCE}
#echo ${BASEDIR}
#echo ${STAGING_DIR}
#echo ${LIBPATH}

# build patched version of v8 as a shared library
cd ${V8SOURCE}
make clean
make dependencies
time make mips.release library=shared snapshot=off -j1
# lib will be compiled here => v8m-rb/out/mips.release/lib.target/libv8.so

#echo "Please enter some input: "
#read input_variable

# build node.js with support to v8 mips shared library
cd ${NODEJSSOURCE}
./configure --without-snapshot --shared-v8 --shared-v8-includes=${V8SOURCE}/include/ --shared-v8-libpath=${V8SOURCE}/out/mips.release/lib.target --dest-cpu=mips
time make snapshot=off -j1

# copy node.js and libv8.so MIPS and deploy
# ${NODEJSSOURCE}/out/Release/node
# /home/seven/work/openwrt/node-v0.10-5-mips/out
# ${V8SOURCE}/out/mips.release/lib.target/libv8.so

#-------------------------------------------------------------------------
# Deploy cross-compiled V8 and Node.js
#-------------------------------------------------------------------------
cd ${NODEJS_MIPS_AR9331}
mkdir nodejs_deploy
cp node-v0.10-5-mips/out/Release/node nodejs_deploy/
cp v8m-rb/out/mips.release/lib.target/libv8.so nodejs_deploy/
file nodejs_deploy/node
file nodejs_deploy/libv8.so
