#import "FTColorPanel.h"

@implementation FTColorPanel
-(FTColorPanel *)init {
  if ([super init]) {
    [self setStyleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask];
    [self setFloatingPanel: YES];
    [self setShowsAlpha: YES];
    
    // Make the 'content box', which holds the selected mode's content view,
    // a bit smaller to make place for the new divider and text field
    id *contentBox = [[[self contentView] subviews] objectAtIndex: CONTENT_BOX_INDEX];
    NSRect contentBoxFrame = [contentBox frame];
    [contentBox setFrame: NSInsetRect(contentBoxFrame, 0, 41)];
    
    // Add a new divider under the opacity slider
    NSBox *divider = [[[self contentView] subviews] objectAtIndex: DIVIDER_INDEX];
    NSBox *newDivider = [[NSBox alloc] initWithFrame: NSOffsetRect([divider frame], 0, 37)];
    [newDivider setBoxType: NSBoxSeparator];
    [newDivider setAutoresizingMask: NSViewWidthSizable];
    [[self contentView] addSubview: newDivider];
    
    // Add the new text field underneath the new divider and the existing divider above
    float width = contentBoxFrame.size.width - 16;
    colorCodeField = [[NSTextField alloc] initWithFrame: NSMakeRect(8, contentBoxFrame.origin.y + 6, width, 20)];
    [colorCodeField setAutoresizingMask: NSViewWidthSizable|NSViewMaxYMargin];
    [colorCodeField setAlignment: NSCenterTextAlignment];
    [[self contentView] addSubview: colorCodeField];
    
    [self updateStringRepresentationOfColor];
    
    return self;
  }
  return nil;
}

-(void)setColor:(NSColor *)color {
  [super setColor: color];
  [self updateStringRepresentationOfColor];
}

-(void)updateStringRepresentationOfColor {
  [colorCodeField setStringValue: [[self color] toHexString]];
}
@end
