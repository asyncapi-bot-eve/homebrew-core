class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.4.tgz"
  sha256 "cff039ab9c930441f5f4ae0e1b6bdaebd4097264acba0a66d407e232fbfe6985"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e90dcaec51f4cb88f5c75df73f3ae608d9590525af1279df153e2d2e783234b7"
    sha256 cellar: :any,                 arm64_tahoe:       "e90dcaec51f4cb88f5c75df73f3ae608d9590525af1279df153e2d2e783234b7"
    sha256 cellar: :any,                 arm64_sequoia:     "e90dcaec51f4cb88f5c75df73f3ae608d9590525af1279df153e2d2e783234b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffcf1acebaec0536989e19a40d6ca96d3ad8280c7b2a9c4f3c4ae2f12f058d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76191a12e18dbb37699a6213365ebb1dcb99c32503ca71435bcfd78dd8f55d91"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
