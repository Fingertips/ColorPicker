#import "ApplicationController.h"


@implementation ApplicationController
- (void)awakeFromNib
{
	[NSApp setDelegate:self];
	
	NSColorPanel *panel = [NSColorPanel sharedColorPanel];
	[panel setStyleMask:NSTitledWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask];
	[panel setFloatingPanel:YES];
	[panel makeKeyAndOrderFront:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
	[[NSColorPanel sharedColorPanel] makeKeyAndOrderFront:self];
}
@end
