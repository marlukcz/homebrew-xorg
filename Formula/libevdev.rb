class Libevdev < Formula
  desc "Wrapper library for evdev devices"
  homepage "https://www.freedesktop.org/wiki/Software/libevdev/"
  url "https://www.freedesktop.org/software/libevdev/libevdev-1.5.2.tar.xz"
  sha256 "5ee2163656a61f5703cb5c08a05c9471ffb7b640bfbe2c55194ea50d908f629b"
  revision 2
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "8038685697da557b2190dd043035c21149c813e6c56582971db9eba81ebd07c3" => :x86_64_linux
  end

  option "with-static", "Build static libraries (not recommended)"
  option "without-test", "Skip compile-time tests"

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "check" => :build if build.with?("test")

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    # Be explicit about the configure flags
    args << "--enable-static=#{build.with?("static") ? "yes" : "no"}"

    system "./configure", *args
    system "make"
    system "make", "test" if build.with?("test")
    system "make", "install"
  end

  test do
    files = ["touchpad-edge-detector", "mouse-dpi-tool", "libevdev-tweak-device"]
    files.each do |f|
      output = shell_output("ldd #{bin}/#{f}").chomp
      assert_match "lib/libevdev.so.2", output
    end
  end
end
