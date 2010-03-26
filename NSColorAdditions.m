#import "NSColorAdditions.h"

// TODO: Do we need to use device or calibrated, or even make it a pref?
@implementation NSColor (Additions)
-(NSString *)toRGBString
{
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"#%02x%02x%02x",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  return result;
}

-(NSString *)toRGBAString
{
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"rgb(%d,%d,%d,%g)",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent]),
                       (float)[color alphaComponent]];
  
  return result;
}
@end
