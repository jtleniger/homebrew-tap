class Curlyfries < Formula
  desc "Filesystem-driven CLI API client: requests as JSON files, environments as JSON, captures persisted in a session file"
  homepage "https://github.com/jtleniger/curlyfries"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jtleniger/curlyfries/releases/download/v0.2.0/curlyfries-aarch64-apple-darwin.tar.xz"
      sha256 "40b33d9402c03e8a23f7792a3e58df555ebbb97b68744ce47ce7ed5ee5559e8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jtleniger/curlyfries/releases/download/v0.2.0/curlyfries-x86_64-apple-darwin.tar.xz"
      sha256 "53df2da098da79ac92d6942ef7dd118311f5d4254b7c02ff4bd52d2d163ab44b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jtleniger/curlyfries/releases/download/v0.2.0/curlyfries-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9a25cd73047d7039acab8846bf6359ee2d0fb86d5b2b600b1bc8512fdf5c08dc"
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
