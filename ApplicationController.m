#import "ApplicationController.h"


@implementation ApplicationController
- (void)awakeFromNib
{
  [NSColorPanel setPickerMask: NSColorPanelAllModesMask];
  NSColorPanel *panel = [NSColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel setStyleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask];
  [panel setFloatingPanel: YES];
  [panel setShowsAlpha: YES];
  [panel makeKeyAndOrderFront: self];
  
  // NSLog([[NSColor blackColor] toHexString]);
  // NSLog([[NSColor whiteColor] toHexString]);
  // NSLog([[NSColor redColor] toHexString]);
  NSLog([[NSColor colorWithCalibratedRed:0.8f green:0.7f blue:0.6f alpha:1.0f] toHexString]);
}

- (void)windowWillClose:(NSNotification *)aNotification
{
  [NSApp terminate: self];
}
@end
