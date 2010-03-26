#import "ApplicationController.h"
#import "FTColorPanel.h"

@implementation ApplicationController
-(void)awakeFromNib {
  FTColorPanel *panel = [FTColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel makeKeyAndOrderFront: self];
}

-(void)windowWillClose:(NSNotification *)aNotification {
  [NSApp terminate: self];
}
@end
