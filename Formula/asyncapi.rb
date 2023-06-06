require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.5.tgz"
  sha256 "b47ce9e98fe9362b188f0531dbaa78905fc12e49b3ea81684fcb984b704123a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee66374b02096285f51f15e054932289a3217c1eb08c6d813dfe5fa514d59bca"
    sha256 cellar: :any,                 arm64_monterey: "ee66374b02096285f51f15e054932289a3217c1eb08c6d813dfe5fa514d59bca"
    sha256 cellar: :any,                 arm64_big_sur:  "ee66374b02096285f51f15e054932289a3217c1eb08c6d813dfe5fa514d59bca"
    sha256 cellar: :any,                 ventura:        "6668fb61d01c6d2e675a95c0c39f14d059375d4c249f047ad693dc4e0ab6f231"
    sha256 cellar: :any,                 monterey:       "6668fb61d01c6d2e675a95c0c39f14d059375d4c249f047ad693dc4e0ab6f231"
    sha256 cellar: :any,                 big_sur:        "6668fb61d01c6d2e675a95c0c39f14d059375d4c249f047ad693dc4e0ab6f231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c3c4b7bad799aed742f7404857fbeb21236069cbef1ffe92dbf4ee68b273b8"
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
