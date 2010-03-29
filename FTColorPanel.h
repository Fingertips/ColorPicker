#import <Cocoa/Cocoa.h>
#import "NSColorAdditions.h"

#define CONTENT_BOX_INDEX 3
#define DIVIDER_INDEX 5

#define HEX_COLOR_MODE 0
#define RGB_COLOR_MODE 1
#define RGBA_COLOR_MODE 2
#define HSL_COLOR_MODE 3
#define HSLA_COLOR_MODE 4
#define OBJC_NSCOLOR_COLOR_MODE 5
#define MACRUBY_NSCOLOR_COLOR_MODE 6

@interface FTColorPanel : NSColorPanel {
  NSTextField *colorCodeField;
  int _colorMode;
}

-(int)colorMode;
-(void)setColorMode:(int)colorMode;

-(NSString *)representationStringOfColor:(BOOL)shortVersion;
-(void)updateStringRepresentationOfColor;
@end
