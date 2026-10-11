class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.16.17.tar.gz"
  sha256 "5b19cddc57d3f5c5e1ef2d9a94503574b90702479b06663e2f25fb07d690f535"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6a539e16e7353ab34ea319f7fb8c4c9cb55ce0b5d6c93a67a715d743d18c3af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55c19a029571e056f18d2c39458b86309aedede8b87a68eab279d56e530de4ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f7ceeeb88b5ea71f856f2606025e608a4937541d50fd515ee78011f763e3851"
    sha256 cellar: :any,                 arm64_linux:       "b924b91a91f6cc0214cf989505fbc9e27603839aa5cec028c3663d125b6cbde0"
    sha256 cellar: :any,                 x86_64_linux:      "da20538abf561ce0f41ca9c325b1a8972a7adbb0c5cb81623ce8829b9932d63d"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end
