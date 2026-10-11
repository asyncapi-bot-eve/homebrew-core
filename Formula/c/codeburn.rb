class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.26.tgz"
  sha256 "917a12366dfa1feb116d3397ba8f8b592a7722006cc55b0468cf615560782fa5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11caec25b237ca2e7160f7b8ade5d72dd42d395c8e14a5e55464ca28c22e6c94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11caec25b237ca2e7160f7b8ade5d72dd42d395c8e14a5e55464ca28c22e6c94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11caec25b237ca2e7160f7b8ade5d72dd42d395c8e14a5e55464ca28c22e6c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba9c511ba870fe8408087b6ec22d4de0d48d67f86dc17fd0ebaaa73a0dc1f2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba9c511ba870fe8408087b6ec22d4de0d48d67f86dc17fd0ebaaa73a0dc1f2e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
