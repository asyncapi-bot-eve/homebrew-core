class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-18.0.1.tgz"
  sha256 "c16cb4869bc85036e7ac382d3c88e44e599a4152030c5d694465b5b6345a604a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "959b57dff1f28ee5fb970c1bba96ae336005ef31b0efff43f5fcb48ad57d3036"
    sha256 cellar: :any, arm64_tahoe:       "30792be82945b97cd585ef3623aa168b65fa5805bbd7840ea0344fcc33682525"
    sha256 cellar: :any, arm64_sequoia:     "4f24cc33619d8df233cd5ac73033fb25f3d0bf3802a3e824d0ac6f2e7d1088d5"
    sha256 cellar: :any, arm64_linux:       "d8914ef45225cd2caadf8c9a881157ccf484196a2b4bc725593db866d5168824"
    sha256 cellar: :any, x86_64_linux:      "12158d62a3f38e1700e4e4fd5e0141b3a1932ae98bd9c2b555d4c558749da6fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
