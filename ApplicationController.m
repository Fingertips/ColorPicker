#import "ApplicationController.h"


@implementation ApplicationController
-(void)awakeFromNib {
  [NSColorPanel setPickerMask: NSColorPanelAllModesMask];
  NSColorPanel *panel = [NSColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel setStyleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask];
  [panel setFloatingPanel: YES];
  [panel setShowsAlpha: YES];
  
  // Using the colorChange: delegate method does not seem to work...
  [panel addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:NULL];
  
  // Make the 'content box', which holds the selected mode's content view,
  // a bit smaller to make place for the new divider and text field
  id *contentBox = [[[panel contentView] subviews] objectAtIndex: 3];
  NSRect current = [contentBox frame];
  [contentBox setFrame: NSInsetRect(current, 0, 41)];
  
  // Add a new divider under the opacity slider
  NSBox *divider = [[[panel contentView] subviews] objectAtIndex: 5];
  NSBox *newDivider = [[NSBox alloc] initWithFrame: NSOffsetRect([divider frame], 0, 37)];
  [newDivider setBoxType: NSBoxSeparator];
  [newDivider setAutoresizingMask: NSViewWidthSizable];
  [[panel contentView] addSubview: newDivider];
  
  // Add the new text field underneath the new divider and the existing divider above
  colorCodeField = [[NSTextField alloc] initWithFrame: NSMakeRect(8, current.origin.y + 6, [[panel contentView] frame].size.width - 16, 20)];
  [colorCodeField setAutoresizingMask: NSViewWidthSizable|NSViewMaxYMargin];
  [colorCodeField setAlignment: NSCenterTextAlignment];
  [[panel contentView] addSubview: colorCodeField];
  
  [panel makeKeyAndOrderFront: self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSColor *color = [change valueForKey:@"new"];
  [colorCodeField setStringValue: [color toHexString]];
}

-(void)windowWillClose:(NSNotification *)aNotification {
  [NSApp terminate: self];
}
@end
