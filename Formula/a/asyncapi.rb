require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.15.3.tgz"
  sha256 "0bd175e05f400fa1f17df8d5f960178214ed53327566b07b470a4d244599ef35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f7141f26e235050b9f8a801605dbefb2029a4f87b164c95e48f8a9e1b61ec08"
    sha256 cellar: :any,                 arm64_ventura:  "50974606f1caf8227aff231c7d35d5c7ac34080cef75d26a7f428075fa327304"
    sha256 cellar: :any,                 arm64_monterey: "50bda20b0b9436c89890dc135163993bdc65e6a38d7f3df179617b588f083597"
    sha256 cellar: :any,                 sonoma:         "99d8fc6d257e9907d189e9f651cc2d60abb7ceeb51fdbbf1b0e2313fef7f1885"
    sha256 cellar: :any,                 ventura:        "b9bf0e35445c714047ca6f52583f48452b62e0c704a2bbc8b56e8f93ab4eebe2"
    sha256 cellar: :any,                 monterey:       "a932ba9d5376397334ffe67d32482157e09750c52ed16a7d7687792ac783ae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b21817dda8e9df1cff86800bd004fee5dcef848787e9d84b0886d3408fe5abb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
