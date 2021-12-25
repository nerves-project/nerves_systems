#
# Nerves systems configuration
#
# The scripts aren't smart, so if you change this and don't want to
# think, run `rm -fr src o` to start fresh.
#
# Run `./clone-systems.exs` to download all of the systems to the
# `src` directory.

%{
  # Git repository for nerves_system_br or the fork to use
  nerves_system_br: "git@github.com:nerves-project/nerves_system_br",
  #
  # Systems options
  # 
  # Default branch to use when checking out systems
  default_system_branch: "main",
  #
  # System specs
  #
  # {short_name, git_repository, options}
  #
  # * `short_name` - the name of the build directory
  # * `git_repository` - where the source is
  # * `options` - a keyword list
  #   * `:branch` - which branch to checkout
  systems: [
    {"rpi4", "git@github.com:nerves-project/nerves_system_rpi4", branch: "main"},
    {"rpi0", "git@github.com:nerves-project/nerves_system_rpi0"},
    {"bbb", "git@github.com:nerves-project/nerves_system_bbb"},
    {"rpi3", "git@github.com:nerves-project/nerves_system_rpi3"},
    {"rpi3a", "git@github.com:nerves-project/nerves_system_rpi3a"},
    {"rpi", "git@github.com:nerves-project/nerves_system_rpi"},
    {"rpi2", "git@github.com:nerves-project/nerves_system_rpi2"},
    {"osd32mp1", "git@github.com:nerves-project/nerves_system_osd32mp1"},
    {"x86_64", "git@github.com:nerves-project/nerves_system_x86_64"},
    {"vultr", "git@github.com:nerves-project/nerves_system_vultr"},
    {"npi_imx6ull", "git@github.com:fhunleth/nerves_system_npi_imx6ull"}
  ]
}
