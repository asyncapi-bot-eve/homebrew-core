class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-18.0.1.tgz"
  sha256 "c16cb4869bc85036e7ac382d3c88e44e599a4152030c5d694465b5b6345a604a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "239d8644d6cd89c4958124fed4a516366e5ac7b8d27b1b586cfc811ad260e698"
    sha256 cellar: :any, arm64_tahoe:       "65a606b0f6039c5629971a1e906b427f48b5b8a1c534edf6501632d27e71bafe"
    sha256 cellar: :any, arm64_sequoia:     "5b06566e3578be00d64b833d6870f178068b638f799329948b3b23b6cd15e026"
    sha256 cellar: :any, arm64_linux:       "ca33a2500bd07e0011a9960fbf01c4c8e14d7d58a33c663dea8db0c54b1121ac"
    sha256 cellar: :any, x86_64_linux:      "aefb0868feea7a276479d20977697950b1f0a12d0e9b3bacda85b52517c49603"
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
