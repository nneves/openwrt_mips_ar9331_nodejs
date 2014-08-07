### OpenWrt MIPS AR9331 Node.js ###
-----------------------------------

Automated script to cross compile Node.js v0.10.5 form OpenWrt MIPS Atheros AR9331 SoC platform.

The initial goal was to run on cheap OpenWrt routers such as TP-Link Wr703N but since there are other hardware using the same SoC with OpenWrt this solution may work on boards like Carambola2, Arduino YÃYun, etc.

Initial tests of this script were made on a X86 machine/vm runing Linux Debian 7 (wheezy) and sets the OpenWrt SDK, checks out custom patched version of Node.js v0.10.5 for MIPS, cross-compiles V8 engine as a dynamic library and compiles Node.js.

For more information please check out this initial discussion: [https://github.com/paul99/v8m-rb/pull/19#issuecomment-23875964](https://github.com/paul99/v8m-rb/pull/19#issuecomment-23875964)

You can find other similar work here:

[http://fibasile.github.io/compiling-nodejs-for-arduino-yun.html](http://fibasile.github.io/compiling-nodejs-for-arduino-yun.html)

[http://giorgiocefaro.com/blog/installing-node-js-on-arduino-yun](ttp://giorgiocefaro.com/blog/installing-node-js-on-arduino-yun)

[https://github.com/brimstone/nodejs-openwrt](https://github.com/brimstone/nodejs-openwrt)
