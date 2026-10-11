class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.30.tar.gz"
  sha256 "113d8abb4c24a4984d823e86c71834be8a4c1adbe643af3cf0721a65298a78c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0744a080c5dd9f7f5574d0e419bbe40e759a3a971b812aaf35a83a2d2610ec7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15e153b930a21722547ac6c9ed6fc1a9b09e97fc009cfd9fb5079bbe77199ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd75e083e0969a5318dc4aa49e95c367acf7efdfffd5e6df9f689601c371612a"
    sha256 cellar: :any,                 arm64_linux:       "1ea289b86bb2b4096bc69cc1cb2a3e414de403122de85c0adea446ec11237a44"
    sha256 cellar: :any,                 x86_64_linux:      "32191e057942f602e1ed7085545fc8164c809a3ab6c71e24d84722c2f403343f"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/a85db3c68b1c79a317e498dc8faf55e41e4c0c3b/model_prices_and_context_window.json"
    version "a85db3c68b1c79a317e498dc8faf55e41e4c0c3b"
    sha256 "10764517ded77844701b88837070f749d1b26c2573eb0ffd330b189a33d7d138"

    # Fetch the latest available resource
    livecheck do
      url "https://api.github.com/repos/BerriAI/litellm/branches/main"
      strategy :json do |json|
        json.dig("commit", "sha")
      end
    end
  end

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    resource("litellm-pricing-json").stage buildpath
    ENV["CCUSAGE_PRICING_JSON_PATH"] = buildpath/"model_prices_and_context_window.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
