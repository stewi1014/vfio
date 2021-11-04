# Windoiws 10 VFIO configuration

# This Repo

#### Scripts
 - [win10.sh](./win10.sh) is the entry point. It starts the display client and possibly runs `start.sh`/`stop.sh` depending on VM state and other running instances of the script.
 - [start.sh](./start.sh) runs **once** before the VM starts
 - [stop.sh](./stop.sh) runs **once** after the VM stops
 - [display.sh](./display.sh) runs **every** time `win10.sh` is executed, waiting for `start.sh` and VM startup to complete if relavent.

#### Other
 - [win10.desktop/win10.svg](./win10.desktop)
 - [win10.xml](./win10.xml) libvirt configuration

# Kernel flags
 - vfio-pci.ids=10de:2208,10de:1aef
 - signore_msrs=N report_ignored_msrs=Y

# Passthrough
 - IOMMU Group 26
	- 0b:00.0 Nvidia VGA [10de:2208] (nvidia, vfio-pci)
	- 0b:00.1 Nvidia HDA [10de:1aef] (snd_hda_intel, vfio-pci)

# Notes

## Guest display output
Windows isn't the kind of OS that would let you [create](https://unix.stackexchange.com/questions/378373/add-virtual-output-to-xorg) [a](https://askubuntu.com/questions/453109/add-fake-display-when-no-monitor-is-plugged-in) [virtual](https://github.com/dianariyanto/virtual-display-linux) [display](https://bbs.archlinux.org/viewtopic.php?id=180904). As such, the guest is plugged into an unused HDMI 2.0 port on the monitor that does not support the monitor's own refresh rate, and [CRU](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) is used to spoof the monitor's EDID, generating a framebuffer of the desired resolution and refresh rate. [Looking Glass](https://looking-glass.io/) does the rest.
