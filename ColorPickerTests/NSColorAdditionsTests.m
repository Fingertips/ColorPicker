#import <XCTest/XCTest.h>
#import "NSColorAdditions.h"

@interface NSColorAdditionsTests : XCTestCase

@end

@implementation NSColorAdditionsTests

- (void)testReturnsAHSLRepresentation {
    NSDictionary *expectations = @{
        [NSColor colorFromString:@"000000"]: @"hsl(0, 0%, 0%)",
        [NSColor colorFromString:@"808080"]: @"hsl(0, 0%, 50%)",
        [NSColor colorFromString:@"bf4040"]: @"hsl(0, 50%, 50%)",
        [NSColor colorFromString:@"df9f9f"]: @"hsl(0, 50%, 75%)",
        [NSColor colorFromString:@"ff8000"]: @"hsl(30, 100%, 50%)",
        [NSColor colorFromString:@"00ff00"]: @"hsl(120, 100%, 50%)",
        [NSColor colorFromString:@"0000ff"]: @"hsl(240, 100%, 50%)",

        [NSColor colorFromString:@"#c0ffee"]: @"hsl(164, 100%, 88%)",
        [NSColor colorFromString:@"#0ff1ce"]: @"hsl(171, 89%, 50%)",
        [NSColor colorFromString:@"#d00dad"]: @"hsl(311, 88%, 43%)",
        [NSColor colorFromString:@"#fab1ed"]: @"hsl(311, 88%, 84%)",
        [NSColor colorFromString:@"#c0bb1e"]: @"hsl(58, 73%, 44%)"
    };

    for(NSColor *color in expectations) {
        NSString *expectation = [expectations objectForKey:color];

        XCTAssertEqualObjects(expectation, [color toHSLString:NO]);
    }
}

@end