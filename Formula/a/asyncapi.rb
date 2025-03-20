class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.17.0.tgz"
  sha256 "96d16885b2199d7490abc74f39cc9204326cf3574cc5959d8014282237b80653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 arm64_sonoma:  "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 arm64_ventura: "4ed888e890f7e2cb82279254c9cf0934f662bec710c6849c69a3718ce982995f"
    sha256 cellar: :any,                 sonoma:        "4ab37acc8899e2db93499a869fbe65f5e8ce42df2e8b43b69658f2145927d7a8"
    sha256 cellar: :any,                 ventura:       "4ab37acc8899e2db93499a869fbe65f5e8ce42df2e8b43b69658f2145927d7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4538fcc264ff83e2108f43da4aba110e3550ec17949d85ac90d0ace252456d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de50f2d70368730b9289fb364bda5c6fa2b47f0963d001180b1a48eb49dc75d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
