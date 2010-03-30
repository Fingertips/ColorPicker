#import <Cocoa/Cocoa.h>
#import "FTColorPanel.h"

@interface ApplicationController : NSObject <NSWindowDelegate> {
  FTColorPanel *panel;
}

-(IBAction)copy:(id)sender;
-(IBAction)copyAs:(id)sender;
-(IBAction)paste:(id)sender;

-(void)awakeFromNib;
-(void)windowWillClose:(NSNotification *)aNotification;
@end
