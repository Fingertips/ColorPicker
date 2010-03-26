require File.expand_path('../spec_helper', __FILE__)

describe "NSColor additions, to string" do
  it "returns an RGB representation" do
    NSColor.blackColor.toHexString.should == "#000000"
    NSColor.whiteColor.toHexString.should == "#ffffff"
  end
end