#import "NSColorAdditions.h"

// TODO: Do we need to use device or calibrated, or even make it a pref?
@implementation NSColor (Additions)
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

-(NSString *)toRGBString {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"rgb(%d,%d,%d)",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  return result;
}

-(NSString *)toRGBAString {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"rgba(%d,%d,%d,%g)",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent]),
                       (float)[color alphaComponent]];
  
  return result;
}

// -(NSString *)toCSSString {
//   NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
//   return ([color alphaComponent] == 1.0) ? [self toCSSRGBString] : [self toCSSRGBAString];
// }

@end
