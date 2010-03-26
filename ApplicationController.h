#import <Cocoa/Cocoa.h>
#import "FTColorPanel.h"

@interface ApplicationController : NSObject {
  FTColorPanel *panel;
}

-(IBAction)copy:(id)sender;
-(IBAction)paste:(id)sender;

-(void)awakeFromNib;
-(void)windowWillClose:(NSNotification *)aNotification;
@end
