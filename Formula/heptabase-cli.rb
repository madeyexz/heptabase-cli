class HeptabaseCli < Formula
  desc "CLI for your personal Heptabase knowledge base"
  homepage "https://github.com/madeyexz/heptabase-cli"
  url "https://github.com/madeyexz/heptabase-cli/releases/download/v0.1.0/heptabase"
  sha256 "c3d275bd3cdb32719bf62dcef7f12afe255c1ebaf444197278cd5dea4a4ee895"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "heptabase"
  end

  def caveats
    <<~EOS
      This formula currently ships a prebuilt macOS arm64 binary.
      If your environment is unsupported, use:
        bunx heptabase-cli --help
    EOS
  end

  test do
    output = shell_output("#{bin}/heptabase --help")
    assert_match "Heptabase knowledge base CLI", output
  end
end
