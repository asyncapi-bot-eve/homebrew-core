require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.3.tgz"
  sha256 "f6b6eb612389b4eaaf69bb8998b0b9169cab639e3cde1ffd7f520ed59f6f4633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9217721dc0f6b62b78c8d3054fceec1a52e6240f639e68ee3a52bd12d025772"
    sha256 cellar: :any,                 arm64_monterey: "c9217721dc0f6b62b78c8d3054fceec1a52e6240f639e68ee3a52bd12d025772"
    sha256 cellar: :any,                 arm64_big_sur:  "c9217721dc0f6b62b78c8d3054fceec1a52e6240f639e68ee3a52bd12d025772"
    sha256 cellar: :any,                 ventura:        "f385d04023c283945c62ca1aab1a7bf545b4603ac37d057c6646a9049080be82"
    sha256 cellar: :any,                 monterey:       "f385d04023c283945c62ca1aab1a7bf545b4603ac37d057c6646a9049080be82"
    sha256 cellar: :any,                 big_sur:        "f385d04023c283945c62ca1aab1a7bf545b4603ac37d057c6646a9049080be82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb7a5b9c6ae42f7ea4a0f541d21ca2caf1efc18d3641e86d5917417cb6eb7db"
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
