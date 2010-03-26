#import <Cocoa/Cocoa.h>


@interface ApplicationController : NSObject {
  NSTextField *colorCodeField;
}
-(void)awakeFromNib;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)windowWillClose:(NSNotification *)aNotification;
@end
