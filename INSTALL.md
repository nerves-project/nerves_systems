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
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.0
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
