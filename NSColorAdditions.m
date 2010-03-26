#import "NSColorAdditions.h"

@implementation NSColor (Additions)
// TODO: Do we need to use device or calibrated, or even make it a pref?
-(NSString *)toHexString
{
  NSColor *color = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  
  NSString *result = [NSString stringWithFormat: @"#%02x%02x%02x",
                       (unsigned int)(255 * [color redComponent]),
                       (unsigned int)(255 * [color greenComponent]),
                       (unsigned int)(255 * [color blueComponent])];
  
  return result;
}
@end
