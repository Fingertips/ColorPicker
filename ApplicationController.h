#import <Cocoa/Cocoa.h>
#import "FTColorPanel.h"

#define COPY_AS_MENU @"Copy as…"

@interface ApplicationController : NSObject <NSWindowDelegate> {
  FTColorPanel *panel;
}

-(BOOL)validateMenuItem:(NSMenuItem *)item;

-(IBAction)copy:(id)sender;
-(IBAction)copyAs:(id)sender;
-(IBAction)paste:(id)sender;

-(void)awakeFromNib;
-(void)windowWillClose:(NSNotification *)aNotification;
@end
