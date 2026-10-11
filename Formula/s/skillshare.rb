class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "262b9e0033c5da79106dd39858a32611f9d6bbf2aa57d6846514502c3b40ad26"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56d4c4e1647d7c2df2a32aa0736729504f2da72ecb5497f3a7e9546fd714e933"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56d4c4e1647d7c2df2a32aa0736729504f2da72ecb5497f3a7e9546fd714e933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56d4c4e1647d7c2df2a32aa0736729504f2da72ecb5497f3a7e9546fd714e933"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b847e26f68b58ebf38f036ed9c4493455ccb20d76fc134b64b07798a8fc2c1b"
    sha256 cellar: :any,                 x86_64_linux:      "b47421ae9fd53342adf1a70aec6ce95dc3f9a2191a974f2ef5b9bf43e2b890f7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
