class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  # TODO: Check if possible to migrate to `virtualenv_install_with_resources`
  # https://github.com/PyAr/fades/issues/425
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b4037f8531acb84d8f51f7abff752cb70dd8664784de560474bb99e85940017"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3618b1ea45886be2e09faa71f9753837fde758195462b94d4626684db4f8d95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3618b1ea45886be2e09faa71f9753837fde758195462b94d4626684db4f8d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c3618b1ea45886be2e09faa71f9753837fde758195462b94d4626684db4f8d95"
    sha256 cellar: :any_skip_relocation, sonoma:            "6f9767b1596c8a0a2fe8601caad7ff860a0b2e81ea3a509592c9cfdb5abbd25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a3cc7a74768b843fcf23ad64ce59ab1bea584e2525b571fc1a8954c0705c735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0a3cc7a74768b843fcf23ad64ce59ab1bea584e2525b571fc1a8954c0705c735"
  end

  depends_on "python@3.15"

  pypi_packages extra_packages: %w[packaging]

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  # Backport switch from removed `pkg_resources` to `packaging`
  patch do
    file "Patches/fades/drop-pkg_resources.patch"
    type :backport
    resolves "https://github.com/PyAr/fades/pull/432"
  end

  def install
    ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec, build_isolation: true), "."
      end
    end
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    (bin/"fades").write_env_script(libexec/"bin/fades", PYTHONPATH: ENV["PYTHONPATH"])

    man1.install buildpath/"man/fades.1"
    rm(libexec/"bin/fades.cmd") # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
