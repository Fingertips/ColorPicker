#import <Cocoa/Cocoa.h>

#define CONTENT_BOX_INDEX 3
#define DIVIDER_INDEX 5

@interface FTColorPanel : NSColorPanel {
  NSTextField *colorCodeField;
}
-(void)updateStringRepresentationOfColor;
@end
