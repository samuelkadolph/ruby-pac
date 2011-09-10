require "pac/test_helper"

describe PAC::Functions do
  describe "isResolvable()" do
    it "should return true for localhost" do
      PAC::Functions.isResolvable("localhost").must_equal true
    end

    it "should return false for awidhaowuhuiuhiuug" do
      PAC::Functions.isResolvable("awidhaowuhuiuhiuug").must_equal false
    end
  end
end
