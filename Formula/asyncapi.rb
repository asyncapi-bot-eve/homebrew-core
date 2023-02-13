require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.31.1.tgz"
  sha256 "bc6dd71e35246dfae85a2a9def7346ef1cfb1f4da3ffa0abff7f62727fa39bc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3395545df1616b868cb690647ca777eabd5f4ce1c733b1872524743bfd209633"
    sha256 cellar: :any,                 arm64_monterey: "dbf30e229201d753b9f894c98ee6bc92a5a2236447ac700a89aa21626046def3"
    sha256 cellar: :any,                 arm64_big_sur:  "f111ba72f5a9c8cddbf7cded184f1252b3f3363022252fd7fe12a6f5ca24a70c"
    sha256 cellar: :any,                 ventura:        "ead1530e549def40dea5c9368aaf76518edb66fce15e4f724d8b772c1e6d7d42"
    sha256 cellar: :any,                 monterey:       "6ea876ce0beea13efa3c506b063e92bba4f28d55c1f0acb86a64e7adac8d34d4"
    sha256 cellar: :any,                 big_sur:        "c9bc7281d71ad494ef543242a7912a74f99eee361289cd011bb2c2816c9669d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed210daeb446de6b56e03acaca3d07efae5472565694b05298fb5708be68bd2f"
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
