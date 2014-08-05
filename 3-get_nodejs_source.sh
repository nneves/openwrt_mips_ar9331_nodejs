# Get custom version of v8m-rb with patch to MIPS platfform
git clone https://github.com/paul99/v8m-rb.git -b dm-dev-mipsbe
# Get node.js version 0.10.5
git clone https://github.com/joyent/node.git -b v0.10.5-release node-v0.10-5-mips

# Sets up aliases for gcc & binutils, to support cross-compilation of v8 with gyp.
export V8SOURCE=/home/${USER}/work/openwrt/v8m-rb
export NODEJSSOURCE=/home/${USER}/work/openwrt/node-v0.10-5-mips

export BASEDIR=/home/${USER}/work/openwrt/openwrtsource
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

# build patched version of v8 as a shared library
cd ${V8SOURCE}
make clean
make dependencies
make mips.release library=shared snapshot=off -j1
# lib will be compiled here => v8m-rb/out/mips.release/lib.target/libv8.so


# build node.js with support to v8 mips shared library
cd ${NODEJSSOURCE}
./configure --without-snapshot --shared-v8 --shared-v8-includes=${V8SOURCE}/include/ --shared-v8-libpath=${V8SOURCE}/out/mips.release/lib.target --dest-cpu=mips
make snapshot=off -j1

# copy node.js and libv8.so MIPS and deploy
# ${NODEJSSOURCE}/out/Release/node
# ${V8SOURCE}/out/mips.release/lib.target/libv8.so
