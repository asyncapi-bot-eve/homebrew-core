class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "c49249b310a66bde62b5e3fe9def8409cf7f2dda28cbf8460cb370372d003e32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2b82a76531fbb97bf3d7d26876eb5b8fe4c12aede3a94a4e7529e18029663a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b06b6b36aec5421a0e686a9aa75750bf3e067fbcc47445b590ce1c817c3d61a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa4609aa51674906cf27f64a4458cbdf531a881a50f0bea640f5c6d8910a2f2c"
    sha256 cellar: :any,                 arm64_linux:       "1c40d822de2227659565f4ef0d47fe6ac0375a31c03df5c99db4512d84cc0693"
    sha256 cellar: :any,                 x86_64_linux:      "9cd3e0732370e708bedff5c40e4ad38f7535601c5b9d9be9c7363ad1ab6849d0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
