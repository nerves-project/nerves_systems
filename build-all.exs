#!/usr/bin/env elixir

defmodule ArchFixer do
  def read_lines(input, output) do
    case IO.read(input, :line) do
      :eof ->
        :ok

      "BR2_TOOLCHAIN_EXTERNAL_URL=" <> _ = line ->
        {arch, 0} = System.cmd("uname", ["-m"])
        os_arch = "linux_" <> String.trim(arch)

        line
        |> String.replace("linux_x86_64", os_arch)
        |> tap(&IO.write(output, &1))

        read_lines(input, output)

      line ->
        IO.write(output, line)
        read_lines(input, output)
    end
  end

  def fix_toolchain_arch(dot_config_path) do
    tmp = dot_config_path <> ".new"
    {:ok, output} = File.open(tmp, [:write])

    File.open(dot_config_path, [:read], fn input ->
      ArchFixer.read_lines(input, output)
    end)

    File.close(output)
    File.cp!(tmp, dot_config_path)
  end
end

defmodule Main do
  def load_config() do
    {config, _} = Code.eval_file("config.exs")
    put_in(config.systems, Enum.map(config.systems, &normalize_system/1))
  end

  defp normalize_system({_, _, _} = system), do: system
  defp normalize_system({short_name, url}), do: {short_name, url, []}

  def config_buildroot({short_name, url, _opts}) do
    dir = Path.join("src", Path.basename(url, ".git"))
    out = Path.join("o", short_name)
    IO.puts("Configuring #{dir} to build in #{out}...")

    {_, 0} =
      System.cmd(
        "bash",
        [
          "-c",
          "./src/nerves_system_br/create-build.sh #{Path.join(dir, "nerves_defconfig")} #{out}"
        ],
        into: IO.stream()
      )

    ArchFixer.fix_toolchain_arch(Path.join(out, ".config"))
  end

  def build({short_name, _url, _opts}) do
    out = Path.join("o", short_name)
    IO.puts("Building #{out}...")

    # Unset the Erlang environment variables. These conflict with some package's Makefiles.
    clean_env = %{"ROOTDIR" => nil, "BINDIR" => nil, "EMU" => nil, "PROGNAME" => nil}

    case System.cmd("make", [], cd: out, into: IO.stream(), env: clean_env) do
      {_, 0} -> :ok
      _ -> {:error, "Build for #{out} failed."}
    end
  end

  def main() do
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
end

Main.main()
