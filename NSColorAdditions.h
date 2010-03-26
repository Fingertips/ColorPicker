#import <Cocoa/Cocoa.h>

@interface NSColor (Additions)
// Compacts a regular hex6 string where possible.
//
// I.e. this can be compacted:
//   "#ff0000" => "#f00"
//
// This, however, can not be compacted:
//   "#cbb298" => "#cbb298"
-(NSString *)toHexString;

-(NSString *)toRGBString;
-(NSString *)toRGBAString;
@end
