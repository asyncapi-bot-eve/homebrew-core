class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/2b/8e/76ea0baa512cb340a20d84b52bde962a26407a1e8e105d766dbe66f0f8eb/yq-4.4.3.tar.gz"
  sha256 "f238e80014ad51bff59382205aeeaf4de4de1e97003978248584c8b349337cd0"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "52dd23e541de0d1a3faa3ef78a3eeebaf43330499bd8f2647e4c789f9604d3ab"
    sha256 cellar: :any, arm64_tahoe:       "61f494618dea903426a04a9c3ba33ee482e5aa23a6c0f3b0c0cc1df3c5527531"
    sha256 cellar: :any, arm64_sequoia:     "c22c8b8c28ca44237c34abb21b94a81ffc00983be74f76eb289ba29370081aeb"
    sha256 cellar: :any, arm64_linux:       "3f2a4935543d2b579b94456497816d86a27237dca8d94263ce9c491bfa3a1a07"
    sha256 cellar: :any, x86_64_linux:      "3edadd8c0c51fb8c9d2f57ef3548fde79fd57549a03344985c5ea221e3452e59"
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
