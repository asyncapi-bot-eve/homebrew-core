require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.33.1.tgz"
  sha256 "69a99830a0553bbea387f375ecfe79a4e4121e5b965fd9644bf94ea9247e401d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78630d0c8ddc26df012318dc6746ae0421aba21c100aaaa36fff31f68b5ec60d"
    sha256 cellar: :any,                 arm64_monterey: "78630d0c8ddc26df012318dc6746ae0421aba21c100aaaa36fff31f68b5ec60d"
    sha256 cellar: :any,                 arm64_big_sur:  "78630d0c8ddc26df012318dc6746ae0421aba21c100aaaa36fff31f68b5ec60d"
    sha256 cellar: :any,                 ventura:        "bac7813d8ba1a368a2cc8a95da8e40c099667e6ce097b791ba2fc0872f96867e"
    sha256 cellar: :any,                 monterey:       "bac7813d8ba1a368a2cc8a95da8e40c099667e6ce097b791ba2fc0872f96867e"
    sha256 cellar: :any,                 big_sur:        "bac7813d8ba1a368a2cc8a95da8e40c099667e6ce097b791ba2fc0872f96867e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612d115787f74085362d8c03f2eb5f4c5580d3fe1b1eeb61f4e101aa1e120338"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
