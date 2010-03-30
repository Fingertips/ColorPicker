#import "ApplicationController.h"

@implementation ApplicationController
-(void)awakeFromNib {
  panel = [FTColorPanel sharedColorPanel];
  [panel setDelegate: self];
  [panel makeKeyAndOrderFront: self];
}

-(IBAction)copy:(id)sender {
  NSArray *contents = [NSArray arrayWithObject: [panel representationStringOfColor: NO]];
  
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  [pasteboard clearContents];
  [pasteboard writeObjects: contents];
}

-(IBAction)copyAs:(id)sender {
  NSMenuItem *current = [[sender menu] itemAtIndex: [panel colorMode]];
  [current setState: NSOffState];
  [sender setState: NSOnState];
  
  [panel setColorMode: (int)[sender tag]];
  [self copy: nil];
}

-(IBAction)paste:(id)sender {
  NSArray *classes = [NSArray arrayWithObject: [NSString class]];
  NSArray *copiedStrings = [[NSPasteboard generalPasteboard] readObjectsForClasses:classes options:nil];
  
  if (copiedStrings && [copiedStrings count] > 0) {
    NSColor *color = [NSColor colorFromString: [copiedStrings firstObject]];
    if (color) {
      [panel setColor: color];
      return;
    }
  }
  
  NSBeep();
}

-(void)windowWillClose:(NSNotification *)aNotification {
  [NSApp terminate: self];
}
@end
