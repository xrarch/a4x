# XR/station Firmware

Abbreviated frequently as a4x.

Boot firmware for the XR/station platform, written in xr17032 assembly and Jackal.

![Running](https://raw.githubusercontent.com/xrarch/a4x/master/screenshot.png)

## Building

Place the [new SDK](https://github.com/xrarch/newsdk) at `../newsdk` relative to this repository and build it. Then the following command, run from within this repository, should produce an a4x ROM at `./build/fre/a4x.rom`:

`../newsdk/bin/xrbt.exe build.xrbt a4x`

The ability to hot-switch to the legacy [a3x](https://github.com/xrarch/a3x) firmware can be added to an a4x ROM. The process for this is to build the old firmware, and look for a file called `firmware.bin` within its `./src/` subdirectory. Directly concatenate this file to the end of an a4x ROM to create a new ROM that can boot legacy operating systems.