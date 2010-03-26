#import "ApplicationController.h"


@implementation ApplicationController
- (void)awakeFromNib
{
  NSColorPanel *panel = [NSColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel setStyleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask];
  [panel setFloatingPanel:YES];
  [panel makeKeyAndOrderFront:self];
}

- (void)windowWillClose:(NSNotification *)aNotification
{
  [NSApp terminate: self];
}
@end
