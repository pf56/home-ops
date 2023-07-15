
# Notes
## Building the initial image for ESXi
`$ nix build .#virtualbox`
`$ cot edit-hardware nixos-XXX-x86_64-linux.ova -o nixos.ova -v vmx-17`
`$ tar xfv nixos.ova -C tmp`
`$ vim tmp/nixos.ovf` and remove the sound card
`$ tar cvf nixos.ova nixos.mf nixos.ovf nixos-XXX-x86_64-linux-disk001.vmdk`


## Deploying
`$ nix run '.' -- -p hostname01 hostname02`