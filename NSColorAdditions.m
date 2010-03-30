#import "NSColorAdditions.h"

@implementation NSColor (Additions)
+(NSColor *)colorFromString:(NSString *)colorRepresentation {
  float alpha = 1;
  
  NSScanner *scanner = [NSScanner scannerWithString: [colorRepresentation lowercaseString]];
  NSMutableCharacterSet *skipChars = [NSMutableCharacterSet characterSetWithCharactersInString: @"%,"];
  [skipChars formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [scanner setCharactersToBeSkipped: skipChars];
  
  if ([scanner scanString:@"hsl(" intoString:nil] || [scanner scanString:@"hsla(" intoString:nil]) {
    int hue = 0, saturation = 0, brightness = 0;
    
    [scanner scanInt: &hue];
    [scanner scanInt: &saturation];
    [scanner scanInt: &brightness];
    [scanner scanFloat: &alpha];
    
    return [NSColor colorWithCalibratedHue: (hue / 360.0)
                                saturation: (saturation / 100.0)
                                brightness: (brightness / 100.0)
                                     alpha: alpha];
  }
  
  float red = 0, green = 0, blue = 0;
  
  if ([scanner scanString:@"#" intoString:nil]) {
    unsigned int r = 0, g = 0, b = 0;
    NSString *hex = @"000000";
    
    NSCharacterSet *hexChars = [NSCharacterSet characterSetWithCharactersInString: @"0123456789abcdef"];
    [scanner scanCharactersFromSet:hexChars intoString:&hex];
    
    if ([hex length] == 3) {
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(0, 1)]] scanHexInt: &r];
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(1, 1)]] scanHexInt: &g];
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(2, 1)]] scanHexInt: &b];
      r += r * 16; g += g * 16; b += b * 16;
    } else if ([hex length] == 6) {
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(0, 2)]] scanHexInt: &r];
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(2, 2)]] scanHexInt: &g];
      [[NSScanner scannerWithString: [hex substringWithRange: NSMakeRange(4, 2)]] scanHexInt: &b];
    } else {
      return nil;
    }
    red = (r / 255.0); green = (g / 255.0); blue = (b / 255.0);
    
  } else if ([scanner scanString:@"rgb(" intoString:nil] || [scanner scanString:@"rgba(" intoString:nil]) {
    int r = 0, g = 0, b = 0;
    
    [scanner scanInt: &r];
    [scanner scanInt: &g];
    [scanner scanInt: &b];
    [scanner scanFloat: &alpha];
    
    red = ((unsigned int)r / 255.0); green = ((unsigned int)g / 255.0); blue = ((unsigned int)b / 255.0);
    
  } else if ([scanner scanString:@"[NSColor" intoString:nil]) {
    NSLog(@"OBJC!");
    [scanner scanString:@"colorWithCalibratedRed:" intoString:nil];
    [scanner scanFloat: &red];
    [scanner scanString:@"green:" intoString:nil];
    [scanner scanFloat: &green];
    [scanner scanString:@"blue:" intoString:nil];
    [scanner scanFloat: &blue];
    [scanner scanString:@"alpha:" intoString:nil];
    [scanner scanFloat: &alpha];
    
  } else {
    return nil;
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
