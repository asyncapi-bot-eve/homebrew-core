require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.31.0.tgz"
  sha256 "c245048de88e09b6445fad0d2d82b7a06f50cbfa5e764f924ab6f9caab7d29fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8ed0b5adf433de36aaac8b8010ba38ae643170787154286715ad0e335e3313a"
    sha256 cellar: :any,                 arm64_monterey: "a8ed0b5adf433de36aaac8b8010ba38ae643170787154286715ad0e335e3313a"
    sha256 cellar: :any,                 arm64_big_sur:  "a8ed0b5adf433de36aaac8b8010ba38ae643170787154286715ad0e335e3313a"
    sha256 cellar: :any,                 ventura:        "3c93c3c7aaaa02a5e72e673fcd824cf8c22a4cea649b67b63b8e535495045700"
    sha256 cellar: :any,                 monterey:       "3c93c3c7aaaa02a5e72e673fcd824cf8c22a4cea649b67b63b8e535495045700"
    sha256 cellar: :any,                 big_sur:        "3c93c3c7aaaa02a5e72e673fcd824cf8c22a4cea649b67b63b8e535495045700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb209e10b22c01d6a68e2d64c2b02473bcf223061f8abb8e4d129761dfedff5"
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
