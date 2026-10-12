class Curlyfries < Formula
  desc "Filesystem-driven CLI API client: requests as JSON files, environments as JSON, captures persisted in a session file"
  homepage "https://github.com/jtleniger/curlyfries"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jtleniger/curlyfries/releases/download/v1.0.0/curlyfries-aarch64-apple-darwin.tar.xz"
      sha256 "a7caa3bd43ce9cc0688a683e0b9cdeb23e7212414a1951d5739343dbd4c5628a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jtleniger/curlyfries/releases/download/v1.0.0/curlyfries-x86_64-apple-darwin.tar.xz"
      sha256 "68b64a1b14eff8dcf133ceebef121b95136cc4bb36a419886b554b6b3facf552"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jtleniger/curlyfries/releases/download/v1.0.0/curlyfries-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c10127aaa789522453db2fb3a8c2bad4e216024e4cc7de8a438346f42236aed8"
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
