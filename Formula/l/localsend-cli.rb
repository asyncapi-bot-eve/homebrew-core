class LocalsendCli < Formula
  desc "Terminal client for sending files between nearby devices"
  homepage "https://localsend.org"
  url "https://github.com/localsend/localsend/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "4425dfcf2e016d6540ea44941deb4ba6568201cc47d7f08753606e6e4b2769cd"
  license "Apache-2.0"

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "localsend-cli #{version}", shell_output("#{bin}/localsend-cli --version")
    assert_match "Not a file: missing.txt", shell_output("#{bin}/localsend-cli --file missing.txt 2>&1", 1)

    require "pty"
    require "socket"

    port = free_port
    config_home = testpath/"config"
    PTY.spawn({ "XDG_CONFIG_HOME" => config_home.to_s },
              bin/"localsend-cli", "--alias", "Homebrew Test", "--port", port.to_s) do |reader, writer, pid|
      deadline = Time.now + 30
      loop do
        break if begin
          Socket.tcp("127.0.0.1", port, connect_timeout: 1).close
          true
        rescue Errno::ECONNREFUSED
          false
        end

        raise "LocalSend CLI did not start its server" if Time.now > deadline

        sleep 0.2
      end

      identity = config_home/"localsend-cli/identity.pem"
      response = shell_output("curl --fail --silent --show-error --insecure --noproxy 127.0.0.1 --max-time 5 " \
                              "--cert #{identity} --key #{identity} " \
                              "https://127.0.0.1:#{port}/api/localsend/v2/info")
      assert_equal "Homebrew Test", JSON.parse(response).fetch("alias")
      assert_path_exists config_home/"localsend-cli/config.toml"
    ensure
      Process.kill("TERM", pid)
      reader.close
      writer.close
      Process.wait(pid)
    end
  end
end
