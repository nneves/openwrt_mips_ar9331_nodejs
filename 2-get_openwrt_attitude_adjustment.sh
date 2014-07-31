#!/bin/bash

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
