# Get custom version of node.js with patch to MIPS platfform
git clone https://github.com/paul99/v8m-rb.git -b dm-dev-mipsbe
cd v8m-rb
make dependencies

# Source this to your shell...
# Sets up aliases for gcc & binutils, to support cross-compilation of v8 with gyp.
export V8SOURCE=/home/${USER}/work/openwrt/v8m-rb

export BASEDIR=/home/${USER}/work/openwrt/openwrtsource
export STAGING_DIR=${BASEDIR}/staging_dir

# Code Sourcery 2012.03-63 release
# PREFIX=/home/${USER}/builds/AARC1-Toolchain/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-
PREFIX=${STAGING_DIR}/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-

export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export AR=${PREFIX}ar
export RANLIB=${PREFIX}ranlib
export LINK=$CXX

# LIBPATH=/home/${USER}/builds/AARC1-Toolchain/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33.2/lib/
LIBPATH=${STAGING_DIR}/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/

#export LDFLAGS=-L${LIBPATH}
export LDFLAGS='-Wl,-rpath-link '${LIBPATH}

export GYPFLAGS="-Dv8_use_mips_abi_hardfloat=false -Dv8_can_use_fpu_instructions=false"
(cd ${V8SOURCE}; ./configure --without-snapshot --shared-v8 --shared-v8-includes=${V8SOURCE}/include/ --shared-v8-libpath=${V8SOURCE}/out/mips.release/lib.target --dest-cpu=mips)
(cd ${V8SOURCE}; make snapshot=off -j4)
