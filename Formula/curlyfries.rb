class Curlyfries < Formula
  desc "Filesystem-driven CLI API client: requests as JSON files, environments as JSON, captures persisted in a session file"
  homepage "https://github.com/jtleniger/curlyfries"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jtleniger/curlyfries/releases/download/v1.1.0/curlyfries-aarch64-apple-darwin.tar.xz"
      sha256 "d8205d4a72492c1660ab7ac9d4bbffc0a65f3a2c6446cc11f7686cd9490030ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jtleniger/curlyfries/releases/download/v1.1.0/curlyfries-x86_64-apple-darwin.tar.xz"
      sha256 "142e0b89a0ee2a3933ec2debcd93fbba4223870258e7df4250c08d327f929edc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jtleniger/curlyfries/releases/download/v1.1.0/curlyfries-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f4f402c1a146deddcd50633931acc31d014efcf7bc082b96c185a1ff12f6099a"
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
