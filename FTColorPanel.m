#import "FTColorPanel.h"

@implementation FTColorPanel
-(FTColorPanel *)init {
  if ([super init]) {
    _colorMode = HEX_COLOR_MODE;
    
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
    // make it look like a label as in IB
    [colorCodeField setBezeled: NO];
    [colorCodeField setDrawsBackground: NO];
    [colorCodeField setEditable: NO];
    [colorCodeField setSelectable: NO];
    [[self contentView] addSubview: colorCodeField];
    
    [self updateStringRepresentationOfColor];
    
    return self;
  }
  return nil;
}

-(int)colorMode {
  return _colorMode;
}

-(void)setColorMode:(int)colorMode {
  _colorMode = colorMode;
  [self updateStringRepresentationOfColor];
}

-(void)setColor:(NSColor *)color {
  [super setColor: color];
  [self updateStringRepresentationOfColor];
}

-(NSString *)representationStringOfColor:(BOOL)shortVersion {
  NSColor *color = [self color];
  
  switch (_colorMode) {
    case HEX_COLOR_MODE:             return [color toHexString];
    case RGB_COLOR_MODE:             return [color toRGBString: shortVersion];
    case RGBA_COLOR_MODE:            return [color toRGBAString: shortVersion];
    case HSL_COLOR_MODE:             return [color toHSLString: shortVersion];
    case HSLA_COLOR_MODE:            return [color toHSLAString: shortVersion];
    case OBJC_NSCOLOR_COLOR_MODE:    return [color toObjcNSColor: shortVersion];
    case MACRUBY_NSCOLOR_COLOR_MODE: return [color toMacRubyNSColor: shortVersion];
  }
}

-(void)updateStringRepresentationOfColor {
  [colorCodeField setStringValue: [self representationStringOfColor: YES]];
}
@end
