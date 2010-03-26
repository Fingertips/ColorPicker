require File.expand_path('../spec_helper', __FILE__)

describe "NSColor additions, to string" do
  it "returns an RGB representation, ignoring the alpha component" do
    NSColor.blackColor.toRGBString.should == "#000000"
    NSColor.redColor.toRGBString.should   == "#ff0000"
    NSColor.whiteColor.toRGBString.should == "#ffffff"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBString.should == "#ff0000"
  end
  
  it "returns a CSS RGB representation, which compacts the string when possible" do
    NSColor.blackColor.toCSSRGBString.should == "#000"
    NSColor.redColor.toCSSRGBString.should   == "#f00"
    NSColor.whiteColor.toCSSRGBString.should == "#fff"
    
    color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)
    color.toCSSRGBString.should == "#cbb298"
  end
  
  it "returns a CSS RGBA representation, which does not ignore the alpha component" do
    NSColor.blackColor.toRGBAString.should == "rgb(0,0,0,1)"
    NSColor.redColor.toRGBAString.should   == "rgb(255,0,0,1)"
    NSColor.whiteColor.toRGBAString.should == "rgb(255,255,255,1)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBAString.should == "rgb(255,0,0,0.5)"
  end
end