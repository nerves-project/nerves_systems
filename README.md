# Nerves System Builder

This project contains scripts for building and maintaining Nerves systems. It's
not the only way to build Nerves systems. The recommended way is to build them
using `mix` similar to how you'd build other Elixir projects. If you are
working with Buildroot a lot or maintain several Nerves systems, the
recommended way is slow. This way can be faster.

IMPORTANT: We had a lot of ad hoc shell scripts to do this that were hardcoded
to paths on the Nerves Core team's development computers. The idea with this
project is to do the same thing in a way that we have a chance of supporting.
Not everything is here yet.

## Initial setup

This only works on Linux on `x86_64` and `aarch64`. This works on M1 Macs with
a Linux VM.

Make sure that you're system has >128GB of free disk space. Depending on what's in the Nerves system, the amount of disk space to build it could be very large.

Assuming that you're running Debian, install the following:

```sh
sudo apt update
sudo apt install git build-essential bc cmake cvs wget curl mercurial python3 python3-aiohttp python3-flake8 python3-ijson python3-nose2 python3-pexpect python3-pip python3-requests rsync subversion unzip gawk jq squashfs-tools libssl-dev automake autoconf libncurses5-dev
```

Next, install Erlang and Elixir.

Finally, install the Elixir and Nerves archives:

```sh
mix archive.install hex nerves_bootstrap
mix local.rebar
```

## Configuration

The configuration is kept in `config.exs`. To get started, copy the `starter-config.exs` to `config.exs`:

```sh
cp starter-config.exs config.exs
```

Take a look at the `config.exs` and delete or add systems as needed. If you're
just starting, delete all but one or two so that building doesn't take forever.

Now that you have a configuration, call the `./clone-all.exs` script to
download the systems to the `src` directory. 

```sh
./clone-all.exs
```

There's nothing magical about the `./clone-all.exs` script, you could run `git
clone` manually if you want. The directory structure should look like this:

```text
src/
    nerves_system_br
    nerves_system_rpi0
    nerves_system_bbb
    ...
```

If you want to start over, it's fine to run `rm -fr src`.

## Building

Building is a two step process:

1. Turn the `nerves_defconfig` into a `.config` file in the output directory
   (`o/<system short name>`)
2. Run `make` is `o/<system short name>`

If you're used to Buildroot, you may have a feel for when you can do
incremental builds and when you can't. When in doubt, start over by deleting
the output directory.

The `build-all.exs` script will run both steps.

```sh
./build-all.exs
```

### Hints

1. If `build-all.exs` fails, go to the failing output directory and run `make`.
2. Run `make source` to download everything. Then run `make` and come back
   later.
3. Downloads are stored in `~/.nerves/dl`
4. After running `make menuconfig`, run `make savedefconfig`. The updates will
   be in `src/nerves_system_xyz` and you can commit them.
5. If you're running on `aarch64`, the `build-all.exs` script will modify the
   toolchain in the `.config` so that it will work. Don't update the
   `nerves_defconfig` with the `aarch64` toolchain. The Nerves convention is to
   have the `x86_64` toolchains committed.

## Using the system

After the system builds successfully, open up another terminal window. Build your Nerves project in this one. There are special environment variables that will tell the Nerves build system to use your custom-built system rather than the one referenced in the `mix.exs`. To load these variables in your environment, run:


```sh
. ~/path/to/nerves_systems/o/rpi0/nerves-env.sh
```

Modify the path accordingly.

Don't forget to set the `MIX_TARGET` like normal:

```sh
export MIX_TARGET=rpi0
```

## License

Copyright (C) 2021 The Nerves Project Authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

