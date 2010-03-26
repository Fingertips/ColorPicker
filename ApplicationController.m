#import "ApplicationController.h"

@implementation ApplicationController
-(void)awakeFromNib {
  panel = [FTColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel makeKeyAndOrderFront: self];
}

-(IBAction)copy:(id)sender {
  NSArray *contents = [NSArray arrayWithObject: [[panel color] toHexString]];
  
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  [pasteboard clearContents];
  [pasteboard writeObjects: contents];
}

-(IBAction)paste:(id)sender {
  NSLog(@"paste");
}

-(void)windowWillClose:(NSNotification *)aNotification {
  [NSApp terminate: self];
}
@end
