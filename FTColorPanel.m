#import "FTColorPanel.h"

#define CONTENT_BOX_INDEX 4
#define CONTENT_BOX_OFFSET 31
#define SPACING 7

@implementation FTColorPanel
-(FTColorPanel *)init {
  if ([super init]) {
    _colorMode = HEX_COLOR_MODE;
    
    [self setStyleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask];
    [self setHidesOnDeactivate: NO];
    [self setFloatingPanel: NO];
    [self setShowsAlpha: YES];

    // Add a constraint to the 'content box', which holds the selected mode's
    // content view, to make place for the new divider and text field.
      
    id contentBox = [[[self contentView] subviews] objectAtIndex: CONTENT_BOX_INDEX];
      
    NSLayoutConstraint *contentBoxConstraint = [NSLayoutConstraint constraintWithItem:[[[self contentView] subviews] firstObject]
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:contentBox
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1
                                                                             constant:(CONTENT_BOX_OFFSET + SPACING + 3)];
      
    [[self contentView] addConstraint:contentBoxConstraint];

    //  Add a new divider under the opacity slider
    float totalWidth = [[self contentView] frame].size.width;
    NSRect newDividerFrame = NSMakeRect(0, 0, totalWidth, 1);
    NSBox *newDivider      = [[NSBox alloc] initWithFrame: newDividerFrame];
    [newDivider setBoxType: NSBoxSeparator];
    [newDivider setAutoresizingMask: NSViewWidthSizable];
    [contentBox addSubview: newDivider];
    
    // Add the new text field underneath the new divider and the existing divider above
    float fontSize = [NSFont smallSystemFontSize];
    colorCodeField = [[NSTextField alloc] init];
    // set the text properties
    [[colorCodeField cell] setFont: [NSFont systemFontOfSize: fontSize]];
    // make it look like a label as in IB
    [colorCodeField setBezeled: NO];
    [colorCodeField setDrawsBackground: NO];
    [colorCodeField setEditable: NO];
    [colorCodeField setSelectable: YES];
    colorCodeField.translatesAutoresizingMaskIntoConstraints = NO;

    colorSpaceButton = [[NSButton alloc] init];
    [colorSpaceButton setFont:[NSFont systemFontOfSize: fontSize]];
    [colorSpaceButton setEnabled:YES];
    [colorSpaceButton setBezelStyle:NSRoundRectBezelStyle];
    colorSpaceButton.translatesAutoresizingMaskIntoConstraints = NO;

    [colorSpaceButton setAction:@selector(colorSpaceButtonPressed)];

    NSView *colorCodeView = [[NSView alloc] init];
    colorCodeView.translatesAutoresizingMaskIntoConstraints = NO;

    [colorCodeView addSubview: colorCodeField];
    [colorCodeView addSubview: colorSpaceButton];
    [[self contentView] addSubview: colorCodeView];
    
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[field]->=padding-[button]-padding-|"
                                                                              options:NSLayoutFormatAlignAllBaseline
                                                                              metrics:@{@"padding": @10}
                                                                                views:@{
                                                                                        @"field": colorCodeField,
                                                                                        @"button": colorSpaceButton
                                                                                      }
                                       ]
     ];

    [self.contentView addConstraints: @[
      [NSLayoutConstraint constraintWithItem:colorCodeView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                    constant:0],
      [NSLayoutConstraint constraintWithItem:colorCodeView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:fontSize + 8],
      [NSLayoutConstraint constraintWithItem:colorCodeView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:contentBox
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                    constant:SPACING - 2]
    ]];

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

-(NSString *)representationStringOfCurrentColorMode:(BOOL)shortVersion {
  return [self representationStringOfColorInMode:_colorMode shortVersion:shortVersion];
}

-(NSString *)representationStringOfColorInMode:(int)colorMode shortVersion:(BOOL)shortVersion {
  NSColor *color = [self color];
  
  switch (colorMode) {
    case HEX_COLOR_MODE:              return [color toHexString];
    case HEX_WITHOUT_HASH_COLOR_MODE: return [color toHexStringWithoutHash];
    case RGB_COLOR_MODE:              return [color toRGBString:      shortVersion];
    case RGBA_COLOR_MODE:             return [color toRGBAString:     shortVersion];
    case HSL_COLOR_MODE:              return [color toHSLString:      shortVersion];
    case HSLA_COLOR_MODE:             return [color toHSLAString:     shortVersion];
    case OBJC_NSCOLOR_COLOR_MODE:     return [color toObjcNSColor:    shortVersion];
    case SWIFT_NSCOLOR_COLOR_MODE:    return [color toSwiftNSColor:   shortVersion];
    case MOTION_NSCOLOR_COLOR_MODE:   return [color toMotionNSColor:  shortVersion];
    case OBJC_UICOLOR_COLOR_MODE:     return [color toObjcUIColor:    shortVersion];
    case SWIFT_UICOLOR_COLOR_MODE:    return [color toSwiftUIColor:   shortVersion];
    case MOTION_UICOLOR_COLOR_MODE:   return [color toMotionUIColor:  shortVersion];
  }
  
  return nil;
}

-(BOOL) hasCorrectColorSpace {
  return [[[self color] colorSpace] isEqualTo: [self desiredColorSpace]];
}

-(NSString *) titleForColorSpace:(NSColorSpace *)colorSpace {
  if([colorSpace isEqual:[NSColorSpace sRGBColorSpace]]){
    return @"sRGB";
  } else {
    return @"Gen.";
  }
}

-(NSString *)toolTipForColorSpace:(NSColorSpace *)colorSpace {
    return [NSString stringWithFormat:@"Convert to %@", [colorSpace localizedName]];
}

-(NSColorSpace *) desiredColorSpace {
  switch (_colorMode) {
    case HEX_COLOR_MODE:
    case HEX_WITHOUT_HASH_COLOR_MODE:
    case RGB_COLOR_MODE:
    case RGBA_COLOR_MODE:
    case HSL_COLOR_MODE:
    case HSLA_COLOR_MODE:
    case OBJC_UICOLOR_COLOR_MODE:
    case SWIFT_UICOLOR_COLOR_MODE:
    case MOTION_UICOLOR_COLOR_MODE:
      return [NSColorSpace sRGBColorSpace];
    case OBJC_NSCOLOR_COLOR_MODE:
    case SWIFT_NSCOLOR_COLOR_MODE:
    case MOTION_NSCOLOR_COLOR_MODE:
      return [NSColorSpace genericRGBColorSpace];
  }
  return nil;
}

-(void)updateStringRepresentationOfColor {
  [colorSpaceButton setTitle: [self titleForColorSpace:[self desiredColorSpace]]];
  [colorSpaceButton setToolTip:[self toolTipForColorSpace:[self desiredColorSpace]]];
  
  if([self hasCorrectColorSpace]) {
    [colorSpaceButton setEnabled:NO];
  } else {
    [colorSpaceButton setEnabled:YES];
  }

  [colorCodeField setStringValue: [self representationStringOfCurrentColorMode: YES]];
}

-(void)colorSpaceButtonPressed {
  [self setColor: [[self color] colorUsingColorSpace:[self desiredColorSpace]]];
}

@end
