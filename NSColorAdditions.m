#import "NSColorAdditions.h"

// TODO: Do we need to use device or calibrated, or even make it a pref?
@implementation NSColor (Additions)
+(NSColor *)colorFromString:(NSString *)colorRepresentation {
  float red, green, blue, alpha = 1.0;
  
  NSScanner *scanner = [NSScanner scannerWithString: [colorRepresentation lowercaseString]];
  [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
  
  if ([scanner scanString:@"#" intoString:nil]) {
    NSLog(@"HEX!");
    
    unsigned int r, g, b;
    NSString *hex = @"000000";
    NSCharacterSet *hexChars = [NSCharacterSet characterSetWithCharactersInString: @"0123456789abcdef"];
    
    [scanner scanCharactersFromSet:hexChars intoString:&hex];
    switch ([hex length]) {
      case 3:
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(0, 1)]] scanHexInt: &r];
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(1, 1)]] scanHexInt: &g];
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(2, 1)]] scanHexInt: &b];
        r = r + (r * 16);
        g = g + (g * 16);
        b = b + (b * 16);
        break;
      
      case 6:
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(0, 2)]] scanHexInt: &r];
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(2, 2)]] scanHexInt: &g];
        [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(4, 2)]] scanHexInt: &b];
        break;
      
      default:
        return nil;
    }
    
    red   = r / 255.0;
    green = g / 255.0;
    blue  = b / 255.0;
    
  } else if ([scanner scanString:@"rgb(" intoString:nil]) {
    NSLog(@"RGB!");
    
    NSMutableCharacterSet *skip = [NSMutableCharacterSet characterSetWithCharactersInString: @",)"];
    [skip formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [scanner setCharactersToBeSkipped: skip];
    
    unsigned int r, g, b;
    [scanner scanInt: &r];
    [scanner scanInt: &g];
    [scanner scanInt: &b];
    
    // NSLog(@"Parsed: %d, %d, %d", r, g, b);
    
    red   = r / 255.0;
    green = g / 255.0;
    blue  = b / 255.0;
    
  } else if ([scanner scanString:@"rgba(" intoString:nil]) {
    NSLog(@"RGBA!");
    
    NSMutableCharacterSet *skip = [NSMutableCharacterSet characterSetWithCharactersInString: @",)"];
    [skip formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [scanner setCharactersToBeSkipped: skip];
    
    unsigned int r, g, b;
    [scanner scanInt: &r];
    [scanner scanInt: &g];
    [scanner scanInt: &b];
    [scanner scanFloat: &alpha];
    
    // NSLog(@"Parsed: %d, %d, %d, %f", r, g, b, alpha);
    
    red   = r / 255.0;
    green = g / 255.0;
    blue  = b / 255.0;
    
  } else if ([scanner scanString:@"hsl(" intoString:nil]) {
    NSLog(@"HSL!");
    
    NSMutableCharacterSet *skip = [NSMutableCharacterSet characterSetWithCharactersInString: @"%,)"];
    [skip formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [scanner setCharactersToBeSkipped: skip];
    
    unsigned int hue, saturation, brightness;
    [scanner scanInt: &hue];
    [scanner scanInt: &saturation];
    [scanner scanInt: &brightness];
    
    // NSLog(@"Parsed: %d, %d, %d", hue, saturation, brightness);
    
    return [NSColor colorWithCalibratedHue:(hue / 360.0) saturation:(saturation / 100.0) brightness:(brightness / 100.0) alpha:alpha];
  }
  
  return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

-(NSString *)toHexString {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"#%02x%02x%02x",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  if (([result characterAtIndex: 1] == [result characterAtIndex: 2]) &&
      ([result characterAtIndex: 3] == [result characterAtIndex: 4]) &&
        ([result characterAtIndex: 5] == [result characterAtIndex: 6])) {
    return [NSString stringWithFormat: @"#%C%C%C",
             [result characterAtIndex: 1],
             [result characterAtIndex: 3],
             [result characterAtIndex: 5]];
  } else {
    return result;
  }
}

-(NSString *)toRGBString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d, %d" : @"rgb(%d, %d, %d)"),
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  return result;
}

-(NSString *)toRGBAString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d, %d, %g" : @"rgba(%d, %d, %d, %g)"),
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent]),
                       (float)[color alphaComponent]];
  
  return result;
}

-(NSString *)toHSLString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d%%, %d%%" : @"hsl(%d, %d%%, %d%%)"),
                       (unsigned int)(360 * [color hueComponent]),
                       (unsigned int)(100 * [color saturationComponent]),
                       (unsigned int)(100 * [color brightnessComponent])];
  
  return result;
}

-(NSString *)toHSLAString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d%%, %d%%, %g" : @"hsla(%d, %d%%, %d%%, %g)"),
                       (unsigned int)(360 * [color hueComponent]),
                       (unsigned int)(100 * [color saturationComponent]),
                       (unsigned int)(100 * [color brightnessComponent]),
                       (float)[color alphaComponent]];
  
  return result;
}

-(NSString *)toObjcNSColor:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%g %g %g %g" : @"[NSColor colorWithCalibratedRed:%f green:%f blue:%f alpha:%f]"),
                       [color redComponent],
                       [color greenComponent],
                       [color blueComponent],
                       [color alphaComponent]];
  
  return result;
}

-(NSString *)toMacRubyNSColor:(BOOL)shortVersion {
  if (shortVersion)
    return [self toObjcNSColor: YES];
  
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"NSColor.colorWithCalibratedRed(%g, green: %g, blue: %g, alpha: %g)",
                       [color redComponent],
                       [color greenComponent],
                       [color blueComponent],
                       [color alphaComponent]];
  
  return result;
}

@end
