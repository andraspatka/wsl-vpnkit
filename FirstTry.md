# First try on 07.09.2021 by APA

- Install Ubuntu 20.04 from the Microsoft Store
- Start the distro
- Set WSL Version for Distro to 1:
  - `wsl --list --verbose #list distros and versions`
  - `wsl --set-version Ubuntu-20.04 1 #set Ubuntu 20.04 version to 1`
- Optional: Add new profile for Ubuntu-20.04 in Windows Terminal

Run:
```bash
sudo apt update
sudo apt install p7zip genisoimage
```

## install vpnkit and vpnkit-tap-vsockd

Get the exes:

```bash
mkdir -p vpnkit-setup-tmp
cd vpnkit-setup-tmp
wget https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe --no-check-certificate # --no-check-certificate because of Zscaler
7zr e Docker\ Desktop\ Installer.exe resources/vpnkit.exe resources/wsl/docker-for-wsl.iso
mkdir -p /mnt/c/vpnkit-bin
mv vpnkit.exe /mnt/c/vpnkit-bin/wsl-vpnkit.exe
isoinfo -i docker-for-wsl.iso -R -x /containers/services/vpnkit-tap-vsockd/lower/sbin/vpnkit-tap-vsockd > ./vpnkit-tap-vsockd
chmod +x vpnkit-tap-vsockd
sudo mv vpnkit-tap-vsockd /sbin/vpnkit-tap-vsockd
sudo chown root:root /sbin/vpnkit-tap-vsockd
rm Docker\ Desktop\ Installer.exe docker-for-wsl.iso
```

## install `npiperelay.exe`


```sh
sudo apt install unzip
```

```sh
wget https://github.com/jstarks/npiperelay/releases/download/v0.1.0/npiperelay_windows_amd64.zip --no-check-certificate # --no-check-certificate because of Zscaler
unzip npiperelay_windows_amd64.zip npiperelay.exe
rm npiperelay_windows_amd64.zip
mkdir -p /mnt/c/vpnkit-bin
mv npiperelay.exe /mnt/c/vpnkit-bin/
```

## install socat

```sh
sudo apt install socat
```

## configure DNS for WSL

```sh
sudo tee /etc/wsl.conf <<EOL
[network]
generateResolvConf = false
EOL
```

Close terminals and shut down the distros (Note: This may mess up docker-desktop if it's currently running, close it manually before running this):

```
# Run in windows
wsl --shutdown
```

Manually set DNS servers to use when not running `wsl-vpnkit`. [`1.1.1.1`](https://1.1.1.1/dns/) is provided here as an example.

```sh
sudo tee /etc/resolv.conf <<EOL
nameserver 1.1.1.1
EOL

# If this command causes some problems (like: tee: /etc/resolv.conf: No such file or directory)
# Then this file might already exist and it's a simlink pointing to a file that doesn't exist:  resolv.conf -> ../run/resolvconf/resolv.conf
# In this case run:
rm /etc/resolv.conf

```

To automatically find the dns server address and put it into /etc/resolv.conf, use the following powershell script:

```
dns.ps1
```

**TODO**: For some reason this doesn't work yet. Cloning the repo gives: `fatal: unable to access 'https://github.com/sakai135/wsl-vpnkit.git/': Could not resolve host: github.com`

### Clone wsl-vpnkit

```sh
cd ~
git clone https://github.com/sakai135/wsl-vpnkit.git
cd wsl-vpnkit/
```