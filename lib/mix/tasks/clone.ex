defmodule Mix.Tasks.Ns.Clone do
  @moduledoc "Clone all Nerves systems"
  @shortdoc "Clone all Nerves systems"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    config = load_config()

    File.mkdir_p!("src")
    clone_url(config.nerves_system_br)

    for system <- config.systems do
      clone(system)
      set_branch(system, config.default_system_branch)
    end
  end

  defp load_config() do
    {config, _} = Code.eval_file("config.exs")
    put_in(config.systems, Enum.map(config.systems, &normalize_system/1))
  end

  defp normalize_system({_, _, _} = system), do: system
  defp normalize_system({short_name, url}), do: {short_name, url, []}

  defp system_url({_, url, _opts}), do: url
  defp system_option({_, _, opts}, key, default), do: Keyword.get(opts, key, default)

  defp clone(system) do
    clone_url(system_url(system))
  end

  defp clone_url(url) do
    checked_out_name = Path.basename(url, ".git")
    dir = Path.join("src", checked_out_name)

    if File.dir?(dir) do
      Mix.Shell.IO.info("Fetching #{checked_out_name}...")
      {_, 0} = System.cmd("git", ["fetch", "--prune"], cd: dir)
    else
      Mix.Shell.IO.info("Cloning #{checked_out_name}...")
      {_, 0} = System.cmd("git", ["clone", url], cd: "src")
    end
  end

  defp set_branch(system, default_branch) do
    url = system_url(system)
    branch = system_option(system, :branch, default_branch)
    checked_out_name = Path.basename(url, ".git")
    dir = Path.join("src", checked_out_name)
    Mix.Shell.IO.info("Switching to the '#{branch}' branch")
    {_, 0} = System.cmd("git", ["checkout", branch], cd: dir)
    {_, 0} = System.cmd("git", ["merge", "--ff-only"], cd: dir)
  end
end
