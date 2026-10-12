class Pyperformance < Formula
  include Language::Python::Virtualenv

  desc "Python benchmark suite"
  homepage "https://github.com/python/pyperformance"
  url "https://files.pythonhosted.org/packages/9e/bc/ebc48f2af24abe0d13681ac7ccb21c3f0ed0128361522f5904d4f21953e9/pyperformance-1.14.0.tar.gz"
  sha256 "91f74393997b604375ad5b79bf569a24076d70181c076a53abad5383a238a8aa"
  license "MIT"
  head "https://github.com/python/pyperformance.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd87960cb67d2ea051a8381a831dd7b2385e9b9c82e45588435f600485e52e42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ad82189e6cddef5507abd1a7fcf54dcf30bc7f873e03a0cccda77b94c9f9e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a358e5472d6fcf63f6a5414582adcfd3b02489eb6692f654294e4a519aa4e90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b814f1d5695be71165ba3cb1090d1ed902c9df0656c0ed6d363ee58e014f43ce"
    sha256 cellar: :any_skip_relocation, sonoma:            "ffbd555113d102bd3e47e27440e75759d59588f40ae078b87e8ba22e3532fba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b9bfa4a2f083266f4198491a952642e70355801ece53642c95e451a61d85ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "23e4b75b6ffa1eed4e4710db8b3101f970f027fd1fdeeb3a5905b35bdf627d29"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyperf" do
    url "https://files.pythonhosted.org/packages/16/91/39ca77aa58f13e8c65d747ac7e06584b55acabfa98987fb8d546bc24860d/pyperf-2.10.0.tar.gz"
    sha256 "dd93ccfda79214725293e95f1fa6e00cb4a64adcf1326039486d4e1f91caaa62"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    list_output = shell_output("#{bin}/pyperformance list --benchmarks nbody")
    assert_match "'nbody' benchmarks:", list_output
    assert_match "- nbody", list_output

    groups_output = shell_output("#{bin}/pyperformance list_groups")
    assert_match "tags:", groups_output
  end
end
