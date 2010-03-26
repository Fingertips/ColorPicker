require File.expand_path('../spec_helper', __FILE__)

describe "NSColor additions, to string" do
  it "returns a hex6 representation, or hex3 when possible" do
    color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)
    color.toHexString.should == "#cbb298"
    
    NSColor.blackColor.toHexString.should == "#000"
    NSColor.redColor.toHexString.should   == "#f00"
    NSColor.whiteColor.toHexString.should == "#fff"
  end
  
  it "returns a RGB representation, which ignores the alpha component" do
    NSColor.blackColor.toRGBString.should == "rgb(0,0,0)"
    NSColor.redColor.toRGBString.should   == "rgb(255,0,0)"
    NSColor.whiteColor.toRGBString.should == "rgb(255,255,255)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBString.should == "rgb(255,0,0)"
  end
  
  it "returns a RGBA representation, which does not ignore the alpha component" do
    NSColor.blackColor.toRGBAString.should == "rgba(0,0,0,1)"
    NSColor.redColor.toRGBAString.should   == "rgba(255,0,0,1)"
    NSColor.whiteColor.toRGBAString.should == "rgba(255,255,255,1)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBAString.should == "rgba(255,0,0,0.5)"
  end
  
  # it "returns a CSS representation, automagically converted to the appropriate format" do
  #   color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)
  #   color.toCSSString.should == "#cbb298"
  #   
  #   # is this correct??
  #   # my calculations say: 204,178,153,0.8
  #   color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 0.8)
  #   color.toCSSString.should == "rgb(203,178,152,0.8)"
  #   
  #   color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 1)
  #   color.toCSSString.should == "#f00"
  #   
  #   color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
  #   color.toCSSString.should == "rgb(255,0,0,0.5)"
  # end
end