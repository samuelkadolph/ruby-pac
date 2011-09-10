require "pac/test_helper"

describe PAC do
  describe "read" do
    before do
      @path = File.expand_path("../files/sample.pac", __FILE__)
    end

    it "should load a file from a path" do
      pac = PAC.read(@path)
      pac.wont_be_nil
    end

    it "should return DIRECT for a url" do
      pac = PAC.read(@path)
      pac.find("http://localhost").must_equal "DIRECT"
    end
  end

  describe "source" do
    before do
      @source = <<-JS
        function FindProxyForURL(url, host) {
          return "DIRECT";
        }
      JS
    end

    it "should load source" do
      pac = PAC.source(@source)
      pac.wont_be_nil
    end

    it "should return DIRECT for a url" do
      pac = PAC.source(@source)
      pac.find("http://localhost").must_equal "DIRECT"
    end
  end
end
