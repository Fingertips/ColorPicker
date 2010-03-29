require File.expand_path('../spec_helper', __FILE__)

class NSColor
  def ==(other)
    isEqualTo(other) == 1
  end
  
  def inspect
    "{ #{description} }"
  end
end

describe "NSColor additions, from a string, with mixed upper and lowercase characters and whitespace" do
  def equal_color(other)
    lambda do |color|
      delta = 0.005
      %w{ red green blue alpha }.all? do |type|
        method = "#{type}Component"
        value = color.send(method)
        range = (value - delta)..(value + delta)
        range.include?(other.send(method))
      end
    end
  end
  
  before do
    @opaqueColor = NSColor.colorWithCalibratedRed(0.81, green: 0.72, blue: 0.63, alpha: 1.0)
    @transparentColor = NSColor.colorWithCalibratedRed(0.81, green: 0.72, blue: 0.63, alpha: 0.54)
  end
  
  it "parses a hex3 representation" do
    NSColor.colorFromString("#f0F").should == NSColor.magentaColor
    NSColor.colorFromString("\t#F0f\n").should == NSColor.magentaColor
  end
  
  it "parses a hex6 representation" do
    NSColor.colorFromString("#ceB7a0").should equal_color(@opaqueColor)
    NSColor.colorFromString("\t#ceB7a0\n").should equal_color(@opaqueColor)
  end
  
  it "parses a RGB representation" do
    NSColor.colorFromString("\trgb(206,183,\s160)").should equal_color(@opaqueColor)
    NSColor.colorFromString("RgB(206,\t183,160)\n").should equal_color(@opaqueColor)
  end
end

describe "NSColor additions, to string" do
  it "returns a hex6 representation, or hex3 when possible" do
    color = NSColor.colorWithCalibratedRed(0.81, green: 0.72, blue: 0.63, alpha: 0.54)
    color.toHexString.should == "#ceb7a0"
    
    NSColor.blackColor.toHexString.should == "#000"
    NSColor.redColor.toHexString.should   == "#f00"
    NSColor.whiteColor.toHexString.should == "#fff"
  end
  
  it "returns a RGB representation, which ignores the alpha component" do
    NSColor.blackColor.toRGBString(false).should == "rgb(0, 0, 0)"
    NSColor.redColor.toRGBString(false).should   == "rgb(255, 0, 0)"
    NSColor.whiteColor.toRGBString(false).should == "rgb(255, 255, 255)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBString(false).should == "rgb(255, 0, 0)"
  end
  
  it "returns a RGBA representation, which does not ignore the alpha component" do
    NSColor.blackColor.toRGBAString(false).should == "rgba(0, 0, 0, 1)"
    NSColor.redColor.toRGBAString(false).should   == "rgba(255, 0, 0, 1)"
    NSColor.whiteColor.toRGBAString(false).should == "rgba(255, 255, 255, 1)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toRGBAString(false).should == "rgba(255, 0, 0, 0.5)"
  end
  
  it "returns a HSL representation, which ignores the alpha component" do
    NSColor.blackColor.toHSLString(false).should == "hsl(0, 0%, 0%)"
    NSColor.redColor.toHSLString(false).should   == "hsl(360, 100%, 100%)"
    NSColor.whiteColor.toHSLString(false).should == "hsl(0, 0%, 100%)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.5)
    color.toHSLString(false).should == "hsl(360, 100%, 100%)"
  end
  
  it "returns a HSL representation, which does not ignore the alpha component" do
    NSColor.blackColor.toHSLAString(false).should == "hsla(0, 0%, 0%, 1)"
    NSColor.redColor.toHSLAString(false).should   == "hsla(360, 100%, 100%, 1)"
    NSColor.whiteColor.toHSLAString(false).should == "hsla(0, 0%, 100%, 1)"
    
    color = NSColor.colorWithCalibratedRed(1, green: 0, blue: 0, alpha: 0.52)
    color.toHSLAString(false).should == "hsla(360, 100%, 100%, 0.52)"
  end
  
  it "returns a Objective-C NSColor representation" do
    color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)
    color.toObjcNSColor(false).should == "[NSColor colorWithCalibratedRed:0.800000 green:0.700000 blue:0.600000 alpha:1.000000]"
  end
  
  it "returns a MacRuby NSColor representation" do
    color = NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)
    color.toMacRubyNSColor(false).should == "NSColor.colorWithCalibratedRed(0.8, green: 0.7, blue: 0.6, alpha: 1)"
  end
  
  it "returns a short version of all representations" do
    color = NSColor.colorWithCalibratedRed(0.81, green: 0.72, blue: 0.63, alpha: 0.54)
    
    color.toRGBString(true).should      == "206, 183, 160"
    color.toRGBAString(true).should     == "206, 183, 160, 0.54"
    color.toHSLString(true).should      == "29, 22%, 81%"
    color.toHSLAString(true).should     == "29, 22%, 81%, 0.54"
    color.toObjcNSColor(true).should    == "0.81 0.72 0.63 0.54"
    color.toMacRubyNSColor(true).should == "0.81 0.72 0.63 0.54"
  end
end