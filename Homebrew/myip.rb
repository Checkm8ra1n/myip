class Myip < Formula
  desc "Simple CLI tool to print the current IP address and hostname"
  homepage "https://github.com/Checkm8ra1n/myip"
  url "https://github.com/Checkm8ra1n/myip/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ddf41b3ea4732f9b432b9a103335bf01214fdb58656008369dea65259dc35df5"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "myip.py" => "myip"
    chmod 0755, bin/"myip"
  end

  test do
    # The output should contain either an IPv4 or IPv6 address
    output = shell_output("#{bin}/myip")
    assert_match(/\b\d{1,3}(\.\d{1,3}){3}\b|([a-f0-9:]+:+)+[a-f0-9]+/, output)
  end
end
