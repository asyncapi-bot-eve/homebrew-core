class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2159f8ee0b1bdd8bfa6010b2044a0f38caca340789bb7713494e6cbb619831e9"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e1e42809feedc9d79dc06afb023c63629659000b27952d335bfba4c0e9326e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e1e42809feedc9d79dc06afb023c63629659000b27952d335bfba4c0e9326e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e1e42809feedc9d79dc06afb023c63629659000b27952d335bfba4c0e9326e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7edcf40d158cefb28c6a207e1fd3b3c5134eae1a4a57c376bcde799ab855c24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "339532ba15a4ed1b53f69328b122d513c6f4c93266aaa0e8e1369eb2907336e7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/marmotdata/marmot/internal/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
