#import "NSColorAdditions.h"

@implementation NSColor (Additions)
+(NSColor *)colorFromString:(NSString *)colorRepresentation {
  float alpha = 1;
  
  NSScanner *scanner = [NSScanner scannerWithString: [colorRepresentation lowercaseString]];
  NSMutableCharacterSet *skipChars = [NSMutableCharacterSet characterSetWithCharactersInString: @"%,"];
  [skipChars formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [scanner setCharactersToBeSkipped: skipChars];
  
  float red = 0, green = 0, blue = 0;
  NSColorSpace *colorSpace = [NSColorSpace sRGBColorSpace];
  
  if ([scanner scanString:@"hsl(" intoString:nil] || [scanner scanString:@"hsla(" intoString:nil]) {
    int hue = 0, saturation = 0, lightness = 0;
    
    [scanner scanInt: &hue];
    [scanner scanInt: &saturation];
    [scanner scanInt: &lightness];
    [scanner scanFloat: &alpha];

    if(saturation == 0) {
        red = lightness / 100.0; green = lightness / 100.0; blue = lightness / 100.0;
    } else {
      float floatHue = hue / 360.0;
      float floatSaturation = saturation / 100.0;
      float floatLightness = lightness / 100.0;

      float (^hueToRGB)(float, float, float) = ^ (float p, float q, float t) {
        if(t < 0) t += 1;
        if(t > 1) t -= 1;
        if(t < 1/6.0) return p + (q - p) * 6 * t;
        if(t < 1/2.0) return q;
        if(t < 2/3.0) return (float)(p + (q - p) * (2/3.0 - t) * 6);
        return p;
      };

      float q;

      if(floatLightness < 0.5) {
        q = floatLightness * (1 + floatSaturation);
      } else {
        q = floatLightness + floatSaturation - floatLightness * floatSaturation;
      }

      float p = 2 * floatLightness - q;

      red = hueToRGB(p, q,	 floatHue + 1/3.0);
      green = hueToRGB(p, q, floatHue);
      blue = hueToRGB(p, q, floatHue - 1/3.0);
    }
  } else if ([scanner scanString:@"rgb(" intoString:nil] || [scanner scanString:@"rgba(" intoString:nil]) {
    signed int r = 0, g = 0, b = 0;
    
    [scanner scanInt: &r];
    [scanner scanInt: &g];
    [scanner scanInt: &b];
    [scanner scanFloat: &alpha];
    
    red = ((unsigned int)r / 255.0); green = ((unsigned int)g / 255.0); blue = ((unsigned int)b / 255.0);
    
  } else if ([scanner scanString:@"[NSColor" intoString:nil] || [scanner scanString:@"NSColor." intoString:nil]) {
    // Objective-C or RubyMotion NSColor
    [scanner scanString:@"colorWithCalibratedRed:" intoString:nil] || [scanner scanString:@"colorWithCalibratedRed(" intoString:nil];
    [scanner scanFloat: &red];
    [scanner scanString:@"green:" intoString:nil];
    [scanner scanFloat: &green];
    [scanner scanString:@"blue:" intoString:nil];
    [scanner scanFloat: &blue];
    [scanner scanString:@"alpha:" intoString:nil];
    [scanner scanFloat: &alpha];
    colorSpace = [NSColorSpace genericRGBColorSpace];

  } else if ([scanner scanString:@"[UIColor" intoString:nil] || [scanner scanString:@"UIColor." intoString:nil]) {
    [scanner scanString:@"colorWithRed:" intoString:nil] || [scanner scanString:@"colorWithRed(" intoString:nil];
    [scanner scanFloat: &red];
    [scanner scanString:@"green:" intoString:nil];
    [scanner scanFloat: &green];
    [scanner scanString:@"blue:" intoString:nil];
    [scanner scanFloat: &blue];
    [scanner scanString:@"alpha:" intoString:nil];
    [scanner scanFloat: &alpha];

  } else {
    [scanner scanString:@"#" intoString:nil];

    unsigned int r = 0, g = 0, b = 0;
    NSString *hex = @"000000";

    NSCharacterSet *hexChars = [NSCharacterSet characterSetWithCharactersInString: @"0123456789abcdef"];

    if([scanner scanCharactersFromSet:hexChars intoString:&hex]){

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

    } else {
      return nil;
    }
  }

  CGFloat components[] = {red, green, blue, alpha};
  return [NSColor colorWithColorSpace:colorSpace components:components count:4];
}

-(NSString *)toHexString {
    return [NSString stringWithFormat:@"#%@", [self toHexStringWithoutHash]];
}

-(NSString *)toHexStringWithoutHash {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
    
    NSString *result = [NSString stringWithFormat: @"%02x%02x%02x",
                        (unsigned int)round(255 * [color redComponent]),
                        (unsigned int)round(255 * [color greenComponent]),
                        (unsigned int)round(255 * [color blueComponent])];
    
    if (([result characterAtIndex: 0] == [result characterAtIndex: 1]) &&
        ([result characterAtIndex: 2] == [result characterAtIndex: 3]) &&
        ([result characterAtIndex: 4] == [result characterAtIndex: 5])) {
        return [NSString stringWithFormat: @"%C%C%C",
                [result characterAtIndex: 0],
                [result characterAtIndex: 2],
                [result characterAtIndex: 4]];
    } else {
        return result;
    }  
}

-(NSString *)toRGBString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d, %d" : @"rgb(%d, %d, %d)"),
                       (unsigned int)round(255 * [color redComponent]),
                       (unsigned int)round(255 * [color greenComponent]),
                       (unsigned int)round(255 * [color blueComponent])];
  
  return result;
}

-(NSString *)toRGBAString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d, %d, %@" : @"rgba(%d, %d, %d, %@)"),
                       (unsigned int)round(255 * [color redComponent]),
                       (unsigned int)round(255 * [color greenComponent]),
                       (unsigned int)round(255 * [color blueComponent]),
                       [self _componentToString:[color alphaComponent] withValueForOne:@"1" withValueForZero:@"0" withFormat:@"%.2f"]];
  
  return result;
}

-(NSString *)toHSLString:(BOOL)shortVersion {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];

     NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d%%, %d%%" : @"hsl(%d, %d%%, %d%%)"),
                         (unsigned int)round([color hueComponentForHSL]) % 360,
                         (unsigned int)round([color saturationComponentForHSL] * 100),
                         (unsigned int)round([color lightnessComponentForHSL] * 100)
                         ];
    return result;
}

-(NSString *)toHSLAString:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
  
  NSString *result = [NSString stringWithFormat: (shortVersion ? @"%d, %d%%, %d%%, %@" : @"hsla(%d, %d%%, %d%%, %@)"),
                      (unsigned int)round([color hueComponentForHSL]) % 360,
                      (unsigned int)round([color saturationComponentForHSL] * 100),
                      (unsigned int)round([color lightnessComponentForHSL] * 100),
                       [self _componentToString:[color alphaComponent] withValueForOne:@"1" withValueForZero:@"0" withFormat:@"%.2f"]];
  
  return result;
}

-(NSString *)_componentToString:(CGFloat)component {
  return [self _componentToString:component withFormat:@"%g"];
}

-(NSString *)_componentToString:(CGFloat)component withFormat:(NSString*)format {
  return [self _componentToString:component withValueForOne:@"1.0" withValueForZero:@"0.0" withFormat:format];
}

-(NSString *)_componentToString:(CGFloat)component withValueForOne:(NSString*)valueForOne withValueForZero:(NSString*)valueForZero withFormat:(NSString*)format {
    if (component == 0.0) {
        return valueForZero;
    } else if (component == 1.0) {
        return valueForOne;
    } else {
        return [NSString stringWithFormat: format, component];
    }
}

-(NSString *)toObjcNSColor:(BOOL)shortVersion {
  NSColor *color = [self colorUsingColorSpace: [NSColorSpace genericRGBColorSpace]];
  
  if (shortVersion) {
    return [NSString stringWithFormat: @"%g %g %g %@",
                                       [color redComponent],
                                       [color greenComponent],
                                       [color blueComponent],
                                       [self _componentToString: [color alphaComponent] withFormat:@"%.2f"]];
  } else {
    NSString *red   = [self _componentToString: [color redComponent]];
    NSString *green = [self _componentToString: [color greenComponent]];
    NSString *blue  = [self _componentToString: [color blueComponent]];
    NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];
    return [NSString stringWithFormat: @"[NSColor colorWithCalibratedRed:%@ green:%@ blue:%@ alpha:%@]", red, green, blue, alpha];
  }
}

-(NSString *)toSwiftNSColor:(BOOL)shortVersion {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace genericRGBColorSpace]];

    if (shortVersion) {
        return [self toObjcNSColor: YES];
    } else {
        NSString *red   = [self _componentToString: [color redComponent]];
        NSString *green = [self _componentToString: [color greenComponent]];
        NSString *blue  = [self _componentToString: [color blueComponent]];
        NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];
        return [NSString stringWithFormat: @"NSColor(calibratedRed: %@ green:%@ blue%@ alpha:%@)", red, green, blue, alpha];
    }
}

-(NSString *)toMotionNSColor:(BOOL)shortVersion {
  if (shortVersion) {
    return [self toObjcNSColor: YES];
  }

  NSColor *color = [self colorUsingColorSpace: [NSColorSpace genericRGBColorSpace]];
  NSString *red   = [self _componentToString: [color redComponent]];
  NSString *green = [self _componentToString: [color greenComponent]];
  NSString *blue  = [self _componentToString: [color blueComponent]];
  NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];

  return [NSString stringWithFormat: @"NSColor(calibratedRed: %@ green:%@ blue%@ alpha:%@)", red, green, blue, alpha];
}

-(NSString *)toObjcUIColor:(BOOL)shortVersion {

  if (shortVersion) {
    return [self toObjcNSColor: YES];
  } else {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];

    NSString *red   = [self _componentToString: [color redComponent]];
    NSString *green = [self _componentToString: [color greenComponent]];
    NSString *blue  = [self _componentToString: [color blueComponent]];
    NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];
    return [NSString stringWithFormat: @"[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@]", red, green, blue, alpha];
  }
}

-(NSString *)toSwiftUIColor:(BOOL)shortVersion {
    if (shortVersion) {
        return [self toObjcNSColor: YES];
    } else {
        NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];

        NSString *red   = [self _componentToString: [color redComponent]];
        NSString *green = [self _componentToString: [color greenComponent]];
        NSString *blue  = [self _componentToString: [color blueComponent]];
        NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];
        return [NSString stringWithFormat: @"UIColor(red:%@, green:%@, blue:%@, alpha:%@)", red, green, blue, alpha];
    }
}

-(NSString *)toMotionUIColor:(BOOL)shortVersion {
  if (shortVersion) {
    return [self toObjcNSColor: YES];
  } else {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
    NSString *red   = [self _componentToString: [color redComponent]];
    NSString *green = [self _componentToString: [color greenComponent]];
    NSString *blue  = [self _componentToString: [color blueComponent]];
    NSString *alpha = [self _componentToString: [color alphaComponent] withFormat:@"%.2f"];

    return [NSString stringWithFormat: @"UIColor.colorWithRed(%@ green:%@ blue:%@ alpha:%@)", red, green, blue, alpha];
  }
}

-(float) hueComponentForHSL{
    float red = [self redComponent];
    float green = [self greenComponent];
    float blue = [self blueComponent];

    float max = [[[self RGBColorComponents] valueForKeyPath:@"@max.self"] floatValue];
    float min = [[[self RGBColorComponents] valueForKeyPath:@"@min.self"] floatValue];

    if(max != min){
        float difference = max - min;

        if(max == red){
            return ((60 * (green - blue) / difference) + 360);
        } else if(max == green){
            return (60 * (blue - red) / difference) + 120;
        } else if(max == blue){
            return (60 * (red - green) / difference) + 240;
        }
    }

    return 0;
}

-(float) saturationComponentForHSL{
    float max = [[[self RGBColorComponents] valueForKeyPath:@"@max.self"] floatValue];
    float min = [[[self RGBColorComponents] valueForKeyPath:@"@min.self"] floatValue];

    float difference = max - min;

    if([self lightnessComponentForHSL] > 0.5) {
        return difference / (2 - max - min);
    } else {
        return difference / (max + min);
    }
}

-(float) lightnessComponentForHSL{
    float max = [[[self RGBColorComponents] valueForKeyPath:@"@max.self"] floatValue];
    float min = [[[self RGBColorComponents] valueForKeyPath:@"@min.self"] floatValue];

    return (max + min) / 2;
}

-(NSArray *) RGBColorComponents {
    NSColor *color = [self colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];

    float red = [color redComponent];
    float green = [color greenComponent];
    float blue = [color blueComponent];

    return @[[NSNumber numberWithFloat:red], [NSNumber numberWithFloat:green], [NSNumber numberWithFloat:blue]];
}

@end
