#import "ApplicationController.h"

@implementation ApplicationController
-(void)awakeFromNib {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSDisabledDictationMenuItem"];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSDisabledCharacterPaletteMenuItem"];

  panel = [[FTColorPanel alloc] init];
  [panel setDelegate: self];
  [panel makeKeyAndOrderFront: self];
}

-(BOOL)validateMenuItem:(NSMenuItem *)item {
  if ([[[item menu] title] isEqualToString: COPY_AS_MENU]) {
    [item setTitle: [panel representationStringOfColorInMode:[item tag] shortVersion:NO]];
  }
  return YES;
}

-(IBAction)copy:(id)sender {
  NSArray *contents = [NSArray arrayWithObject: [panel representationStringOfCurrentColorMode: NO]];
  
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
    NSColor *color = [NSColor colorFromString: [copiedStrings objectAtIndex: 0]];
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
