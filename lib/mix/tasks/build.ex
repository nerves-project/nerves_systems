defmodule Mix.Tasks.Ns.Build do
  @moduledoc "Build all Nerves systems"
  @shortdoc "Build all Nerves systems"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    config = load_config()
    # Configure everything first
    config.systems
    |> Enum.map(&config_buildroot/1)

    # Build everything
    config.systems
    |> Enum.map(&build/1)
    |> Enum.reject(fn result -> result == :ok end)
    |> IO.inspect()
  end

  defp load_config() do
    {config, _} = Code.eval_file("config.exs")
    put_in(config.systems, Enum.map(config.systems, &normalize_system/1))
  end

  defp normalize_system({_, _, _} = system), do: system
  defp normalize_system({short_name, url}), do: {short_name, url, []}

  defp config_buildroot({short_name, url, _opts}) do
    dir = Path.join("src", Path.basename(url, ".git"))
    out = Path.join("o", short_name)
    Mix.Shell.IO.info("Configuring #{dir} to build in #{out}...")

    {_, 0} =
      System.cmd(
        "bash",
        [
          "-c",
          "./src/nerves_system_br/create-build.sh #{Path.join(dir, "nerves_defconfig")} #{out}"
        ],
        into: IO.stream()
      )
  end

  defp build({short_name, _url, _opts}) do
    out = Path.join("o", short_name)
    Mix.Shell.IO.info("Building #{short_name}...")

    # Unset the Erlang environment variables. These conflict with some package's Makefiles.
    clean_env = %{"ROOTDIR" => nil, "BINDIR" => nil, "EMU" => nil, "PROGNAME" => nil}

    case System.cmd("make", [], cd: out, into: IO.stream(), env: clean_env) do
      {_, 0} -> :ok
      _ -> {:error, "Build for #{out} failed."}
    end
  end
end
