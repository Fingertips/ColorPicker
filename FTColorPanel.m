#import "FTColorPanel.h"

#define CONTENT_BOX_INDEX 3
#define DIVIDER_INDEX 5

#define CONTENT_BOX_OFFSET 30
#define SPACING 8

@implementation FTColorPanel
-(FTColorPanel *)init {
  if ([super init]) {
    _colorMode = HEX_COLOR_MODE;
    
    [self setStyleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask];
    [self setHidesOnDeactivate: NO];
    [self setFloatingPanel: NO];
    [self setShowsAlpha: YES];
    
    float totalWidth = [[self contentView] frame].size.width;
    
    // Make the 'content box', which holds the selected mode's content view,
    // a bit smaller to make place for the new divider and text field and move
    // it up by the same offset to locate it in the original position.
    id contentBox = [[[self contentView] subviews] objectAtIndex: CONTENT_BOX_INDEX];
    NSRect contentBoxFrame       = [contentBox frame];
    contentBoxFrame.origin.y    += CONTENT_BOX_OFFSET;
    contentBoxFrame.size.height -= CONTENT_BOX_OFFSET;
    [contentBox setFrame: contentBoxFrame];
    
    // Add a new divider under the opacity slider
    NSRect newDividerFrame = NSMakeRect(0, contentBoxFrame.origin.y - (SPACING - 1), totalWidth, 1);
    NSBox *newDivider      = [[NSBox alloc] initWithFrame: newDividerFrame];
    [newDivider setBoxType: NSBoxSeparator];
    [newDivider setAutoresizingMask: NSViewWidthSizable];
    [[self contentView] addSubview: newDivider];
    
    // Add the new text field underneath the new divider and the existing divider above
    float fontSize             = [NSFont smallSystemFontSize];
    float colorCodeFieldY      = newDividerFrame.origin.y - (fontSize + SPACING);
    NSRect colorCodeFieldFrame = NSMakeRect(SPACING, colorCodeFieldY, totalWidth - (2 * SPACING), fontSize + 2);
    colorCodeField = [[NSTextField alloc] initWithFrame: colorCodeFieldFrame];
    // set the text properties
    [[colorCodeField cell] setFont: [NSFont systemFontOfSize: fontSize]];
    [colorCodeField setAlignment: NSCenterTextAlignment];
    // make it look like a label as in IB
    [colorCodeField setBezeled: NO];
    [colorCodeField setDrawsBackground: NO];
    [colorCodeField setEditable: NO];
    [colorCodeField setSelectable: NO];
    [colorCodeField setAutoresizingMask: NSViewWidthSizable | NSViewMaxYMargin];
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
    case RGB_COLOR_MODE:             return [color toRGBString:      shortVersion];
    case RGBA_COLOR_MODE:            return [color toRGBAString:     shortVersion];
    case HSL_COLOR_MODE:             return [color toHSLString:      shortVersion];
    case HSLA_COLOR_MODE:            return [color toHSLAString:     shortVersion];
    case OBJC_NSCOLOR_COLOR_MODE:    return [color toObjcNSColor:    shortVersion];
    case MACRUBY_NSCOLOR_COLOR_MODE: return [color toMacRubyNSColor: shortVersion];
  }
  
  return nil;
}

-(void)updateStringRepresentationOfColor {
  [colorCodeField setStringValue: [self representationStringOfColor: YES]];
}
@end
