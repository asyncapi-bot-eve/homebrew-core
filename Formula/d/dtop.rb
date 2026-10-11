class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "04089af1dfdc3c37b961887caca9108a2ed7c70805121fdebfa6227b0f759ae0"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28218eba18a2964cf49567fb49d22127d8dc9420368472d9a5e039fa6ca0dc36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aaf05c58bf41edcc787bd6ac54d234ad9e6c9f062dae4fcb344963f8f4300c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75d177106840aef89c47f4ca90c2c9cd09d9396503d59a6124086da31b5c684f"
    sha256 cellar: :any,                 arm64_linux:       "13751bceb4f1bf9b9c84acc738fa79d146c6e95d9af270fcb605bbde9591f111"
    sha256 cellar: :any,                 x86_64_linux:      "5adaea50066f19dbf4745f34266693e5b7e0b851e75b1f9fada28aa70566dd3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
