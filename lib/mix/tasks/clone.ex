defmodule Mix.Tasks.Ns.Clone do
  @moduledoc "Clone all Nerves systems"
  @shortdoc "Clone all Nerves systems"

  use Mix.Task

  @systems Application.compile_env(:nerves_systems, :systems)
  @nerves_system_br Application.compile_env(:nerves_systems, :nerves_system_br)
  @default_system_branch Application.compile_env(:nerves_systems, :default_system_branch)

  @impl Mix.Task
  def run(_args) do
    File.mkdir_p!("src")
    clone_url(@nerves_system_br)

    for system <- @systems do
      system
      |> normalize_system()
      |> clone()
      |> set_branch(@default_system_branch)
    end
  end

  defp normalize_system({_, _, _} = system), do: system
  defp normalize_system({short_name, url}), do: {short_name, url, []}

  defp system_url({_, url, _opts}), do: url
  defp system_option({_, _, opts}, key, default), do: Keyword.get(opts, key, default)

  defp clone(system) do
    clone_url(system_url(system))
    system
  end

  defp clone_url(url) do
    checked_out_name = Path.basename(url, ".git")
    dir = Path.join("src", checked_out_name)

    if File.dir?(dir) do
      Mix.Shell.IO.info("Fetching #{checked_out_name}...")
      0 = Mix.Shell.IO.cmd("git fetch --prune", cd: dir)
    else
      Mix.Shell.IO.info("Cloning #{checked_out_name}...")
      0 = Mix.Shell.IO.cmd("git clone --recursive #{url}", cd: "src")
    end
  end

  defp set_branch(system, default_branch) do
    url = system_url(system)
    branch = system_option(system, :branch, default_branch)
    checked_out_name = Path.basename(url, ".git")
    dir = Path.join("src", checked_out_name)
    Mix.Shell.IO.info("Switching to the '#{branch}' branch")
    0 = Mix.Shell.IO.cmd("git checkout #{branch}", cd: dir)
    0 = Mix.Shell.IO.cmd("git merge --ff-only", cd: dir)
  end
end
