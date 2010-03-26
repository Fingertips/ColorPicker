#import "NSColorAdditions.h"

// TODO: Do we need to use device or calibrated, or even make it a pref?
@implementation NSColor (Additions)
-(NSString *)toRGBString {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"#%02x%02x%02x",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  return result;
}

// Compacts a regular RGB string where possible.
//
// I.e. this can be compacted:
//   "#ff0000" => "#f00"
//
// This, however, can not be compacted:
//   "#cbb298" => "#cbb298"
-(NSString *)toCSSRGBString {
  NSString *original = [self toRGBString];
  
  if (([original characterAtIndex: 1] == [original characterAtIndex: 2]) &&
      ([original characterAtIndex: 3] == [original characterAtIndex: 4]) &&
        ([original characterAtIndex: 5] == [original characterAtIndex: 6])) {
    return [NSString stringWithFormat: @"#%C%C%C",
             [original characterAtIndex: 1],
             [original characterAtIndex: 3],
             [original characterAtIndex: 5]];
  } else {
    return original;
  }
}

-(NSString *)toCSSRGBAString {
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"rgb(%d,%d,%d,%g)",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent]),
                       (float)[color alphaComponent]];
  
  return result;
}

@end
