# Installation

This only works on Linux. If you're creating a VM, make sure that the
disk is at least 128 GB.

Install packages for Buildroot and the Nerves build scripts:

```sh
sudo apt update
sudo apt install git build-essential bc cmake cvs wget curl mercurial python3 python3-aiohttp python3-flake8 python3-ijson python3-nose2 python3-pexpect python3-pip python3-requests rsync subversion unzip gawk jq squashfs-tools libssl-dev automake autoconf libncurses5-dev
```

Install `asdf` and use it to install Erlang and Elixir:

```sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
. $HOME/.asdf/asdf.sh
vi ~/.bashrc
# Add the  line to source asdf.sh to the end of your .bashrc

asdf plugin add erlang
asdf plugin add elixir
asdf install erlang 24.2
asdf global erlang 24.2
asdf install elixir 1.13.1-otp-24
asdf global elixir 1.13.1-otp-24
```

Install Elixir archives:

```sh
mix archive.install nerves_bootstrap
mix archive.install hex nerves_bootstrap
mix local.rebar
```


    5  mkdir .ssh
    6  cd .ssh
    7  sftp 100meter
    8  chmod 700 .
    9  chmod 600 *
   11  cd ~
   12  mkdir -p git/nerves-project
   13  cd git/nerves-project/
   14  git clone git@github.com:nerves-project/nerves_system_br
   15  git clone git@github.com:nerves-project/nerves_system_rpi0
   16  mkdir nerves_systems
   17  cd nerves_systems/
