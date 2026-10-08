class Curlyfries < Formula
  desc "Filesystem-driven CLI API client: requests as JSON files, environments as JSON, captures persisted in a session file"
  homepage "https://github.com/jtleniger/curlyfries"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jtleniger/curlyfries/releases/download/v0.1.0/curlyfries-aarch64-apple-darwin.tar.xz"
      sha256 "db91d6797f88020c0e2f2f26d7865d5e1075e629dde123943929d810f9c96930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jtleniger/curlyfries/releases/download/v0.1.0/curlyfries-x86_64-apple-darwin.tar.xz"
      sha256 "e359abbed4f66479c0dc21d1614f59a075f8a448155115c5518afe6b23896702"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jtleniger/curlyfries/releases/download/v0.1.0/curlyfries-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9c6ddc66c7376d85abd55e7459fad9321c99f5f4b82b3a4e7a03310b424ac163"
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "curlyfries"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "curlyfries"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "curlyfries"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
