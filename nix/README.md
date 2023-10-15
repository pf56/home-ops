
# Notes
## Building the initial image for ESXi
`$ nix build .#virtualbox`
`$ cot edit-hardware nixos-XXX-x86_64-linux.ova -o nixos.ova -v vmx-17`
`$ tar xfv nixos.ova -C tmp`
`$ vim tmp/nixos.ovf` and remove the sound card
`$ tar cvf nixos.ova nixos.mf nixos.ovf nixos-XXX-x86_64-linux-disk001.vmdk`

## Building the initial image for TrueNAS
`$ nix build .#rawefi`
copy to TrueNAS host
create Zvol
`dd if=/mnt/<path to image>/nixos.img of=/dev/zvol/<path to zvol> bs=1M status=progress`
create and boot VM
`sudo bootctl install --graceful`
deploy NixOS

## Deploying
`$ nix run '.' -- -p hostname01 hostname02`