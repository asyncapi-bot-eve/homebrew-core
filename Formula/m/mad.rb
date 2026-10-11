class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://codeberg.org/tenacityteam/libmad"
  url "https://codeberg.org/tenacityteam/libmad/releases/download/0.16.5/libmad-0.16.5.tar.gz"
  sha256 "f401b2ccf49c26ad0c3a6ef0179b1cbbff2406338b0603bb2033e6dcaf706114"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8c5c6d715a2d653fcc2d452f7bb71d668c2caca86cd81ca4d8ade8a0f57b265e"
    sha256 cellar: :any,                 arm64_tahoe:       "c2f1263d0123e856bc3b10b59ec49ce8533a75f8bf46c9829a19a482134a8b33"
    sha256 cellar: :any,                 arm64_sequoia:     "3f9a2384ea3a1c732897a5759b0a4c1dba5f3bc484e89288d7472f55ea1f7152"
    sha256 cellar: :any,                 arm64_sonoma:      "a46ffe14f2184a90ca8e60d0b30978cd673e9f943c55e9554bea0e7646e1f4f3"
    sha256 cellar: :any,                 sonoma:            "4e6025e114bad469457fd64a2710501afcdb3309c1d5c663cfccc90a9f7c37fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f504b4d003538ab8007b64bba565fee86f8610a7107bf682c6e72ebaea4f30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a05120955044b8c9a997b7084b5a08f5d913e5a48f7575ea72d4ff07cd620fab"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DEXAMPLE=OFF",
                    "-DCMAKE_INSTALL_NAME_DIR=#{opt_lib}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/minimad.c"
  end

  test do
    system ENV.cc, pkgshare/"minimad.c", "-o", "minimad", "-I#{include}", "-L#{lib}", "-lmad"
    system "./minimad <#{test_fixtures("test.mp3")} >test.wav"
    assert_equal 4608, (testpath/"test.wav").size?
  end
end
