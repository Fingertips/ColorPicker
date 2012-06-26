#import <Cocoa/Cocoa.h>

@interface NSColor (Additions)
+(NSColor *)colorFromString:(NSString *)colorRepresentation;

// Compacts a regular hex6 string where possible.
//
// I.e. this can be compacted:
//   "#ff0000" => "#f00"
//
// This, however, can not be compacted:
//   "#cbb298" => "#cbb298"
-(NSString *)toHexString;
-(NSString *)toHexStringWithoutHash;

-(NSString *)toRGBString:(BOOL)shortVersion;
-(NSString *)toRGBAString:(BOOL)shortVersion;

-(NSString *)toHSLString:(BOOL)shortVersion;
-(NSString *)toHSLAString:(BOOL)shortVersion;

-(NSString *)toObjcNSColor:(BOOL)shortVersion;
-(NSString *)toMacRubyNSColor:(BOOL)shortVersion;

-(NSString *)toObjcUIColor:(BOOL)shortVersion;
-(NSString *)toMotionUIColor:(BOOL)shortVersion;
@end
