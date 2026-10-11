class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/db/63/6ddfc78e231d2c11538a08debdf96cbe0f372013a849fe391521a4db975e/yq-4.4.2.tar.gz"
  sha256 "d9e2d2cc643f5035dddfdf3d1b1efd58edc19f1d4f3c3ad0bb20645d1900e1f8"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b6b17ee84bbdea4e3c5e8ee377043b7870c7be0a445d9b7f76504c892313fcb8"
    sha256 cellar: :any, arm64_tahoe:       "c99414b2f6ce820096c8f0193e149cec7b88a3a96603e2a8c42c9bdbdcd925f5"
    sha256 cellar: :any, arm64_sequoia:     "dc9305728d08cae5eb46823deadf3e64113458419e42425bd9dc3eac55c6fe10"
    sha256 cellar: :any, arm64_linux:       "6aba8d9f2166783ac4c7bc48af43d40c98851bdf1f9ffd8e45520aef9e2bafb1"
    sha256 cellar: :any, x86_64_linux:      "0015193f7fe789a5b6f0b287408de25607fd0d5c6abc6cf59394ed973cb0b21c"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           base_name: script, shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~YAML
      foo:
       bar: 1
       baz: {bat: 3}
    YAML
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
