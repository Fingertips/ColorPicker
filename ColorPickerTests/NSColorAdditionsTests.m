#import <XCTest/XCTest.h>
#import "NSColorAdditions.h"

@interface NSColorAdditionsTests : XCTestCase

@end

@implementation NSColorAdditionsTests
- (void)testParsesHexadecimalRepresentations {

    NSDictionary *expectations = @{
        [NSColor colorFromString:@"000000"]: @[@0,            @0,            @0,            @1],
        [NSColor colorFromString:@"808080"]: @[@0.5019607843, @0.5019607843, @0.5019607843, @1],
        [NSColor colorFromString:@"bf4040"]: @[@0.7490196078, @0.2509803922, @0.2509803922, @1],
        [NSColor colorFromString:@"df9f9f"]: @[@0.8745098039, @0.6235294118, @0.6235294118, @1],
        [NSColor colorFromString:@"ff8000"]: @[@1,            @0.5019607843, @0,            @1],
        [NSColor colorFromString:@"00ff00"]: @[@0,            @1,            @0,            @1],
        [NSColor colorFromString:@"0000ff"]: @[@0,            @0,            @1,            @1],

        [NSColor colorFromString:@"c0ffee"]: @[@0.7529411765, @1,            @0.9333333333, @1],
        [NSColor colorFromString:@"0ff1ce"]: @[@0.0588235294, @0.9450980392, @0.8078431373, @1],
        [NSColor colorFromString:@"d00dad"]: @[@0.8156862745, @0.0509803921, @0.6784313725, @1],
        [NSColor colorFromString:@"fab1ed"]: @[@0.9803921569, @0.6941176471, @0.9294117647, @1],
        [NSColor colorFromString:@"c0bb1e"]: @[@0.7529411765, @0.7333333333, @0.1176470588, @1]
    };

    for(NSColor *color in expectations) {
        NSArray *expectation = [expectations objectForKey:color];
        CGFloat components[4] = {};

        for (int i=0; i<[expectation count]; i++) {
            components[i] = [[expectation objectAtIndex:i] floatValue];
        }

        XCTAssertEqualObjects([NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4], color);
    }
}

- (void)testParsesHSLRepresentations {

  NSDictionary *expectations = @{
    [NSColor colorFromString:@"hsl(0, 0%, 0)"]:       @"000",
    [NSColor colorFromString:@"hsl(0, 0%, 50%)"]:     @"808080",
    [NSColor colorFromString:@"hsl(0, 50%, 50%)"]:    @"bf4040",
    [NSColor colorFromString:@"hsl(0, 50%, 75%)"]:    @"df9f9f",
    [NSColor colorFromString:@"hsl(30, 100%, 50%)"]:  @"ff8000",
    [NSColor colorFromString:@"hsl(120, 100%, 50%)"]: @"0f0",
    [NSColor colorFromString:@"hsl(240, 100%, 50%)"]: @"00f",

    [NSColor colorFromString:@"hsl(164, 100%, 88%)"]: @"c2ffef",
    [NSColor colorFromString:@"hsl(171, 89%, 50%)"]:  @"0ef1cf",
    [NSColor colorFromString:@"hsl(311, 88%, 43%)"]:  @"ce0dab",
    [NSColor colorFromString:@"hsl(311, 88%, 84%)"]:  @"fab2ed",
    [NSColor colorFromString:@"hsl(58, 73%, 44%)"]:   @"c2bd1e",
  };

  NSLog(@"expectations: %@", expectations);

  for(NSColor *color in expectations) {
    NSArray *expectation = [expectations objectForKey:color];

    XCTAssertEqualObjects(expectation, [color toHexStringWithoutHash]);
  }
}

- (void)testParsesHSLARepresentations {
  NSDictionary *expectations = @{
    @0: @"hsla(164, 100%, 88%, 0)",
    @0.5: @"hsla(164, 100%, 88%, 0.50)",
    @1: @"hsla(164, 100%, 88%, 1)"
  };

  for(NSNumber *alpha in expectations) {
    NSString *expectation = [expectations objectForKey:alpha];
    NSColor *color = [NSColor colorFromString: @"c2ffef"];
    XCTAssertEqualObjects(expectation, [[color colorWithAlphaComponent:[alpha floatValue]] toHSLAString:NO]);
  }
}

- (void)testReturnsHSLRepresentation {
    NSDictionary *expectations = @{
        [NSColor colorFromString:@"000000"]: @"hsl(0, 0%, 0%)",
        [NSColor colorFromString:@"808080"]: @"hsl(0, 0%, 50%)",
        [NSColor colorFromString:@"bf4040"]: @"hsl(0, 50%, 50%)",
        [NSColor colorFromString:@"df9f9f"]: @"hsl(0, 50%, 75%)",
        [NSColor colorFromString:@"ff8000"]: @"hsl(30, 100%, 50%)",
        [NSColor colorFromString:@"00ff00"]: @"hsl(120, 100%, 50%)",
        [NSColor colorFromString:@"0000ff"]: @"hsl(240, 100%, 50%)",

        [NSColor colorFromString:@"c0ffee"]: @"hsl(164, 100%, 88%)",
        [NSColor colorFromString:@"0ff1ce"]: @"hsl(171, 89%, 50%)",
        [NSColor colorFromString:@"d00dad"]: @"hsl(311, 88%, 43%)",
        [NSColor colorFromString:@"fab1ed"]: @"hsl(311, 88%, 84%)",
        [NSColor colorFromString:@"c0bb1e"]: @"hsl(58, 73%, 44%)"
    };

    for(NSColor *color in expectations) {
        NSString *expectation = [expectations objectForKey:color];

        XCTAssertEqualObjects(expectation, [color toHSLString:NO]);
    }
}

- (void)testReturnsShortHSLRepresentation {
    XCTAssertEqualObjects(@"164, 100%, 88%", [[NSColor colorFromString:@"#c0ffee"] toHSLString:YES]);
}

- (void)testReturnsHSLARepresentation {
    NSDictionary *expectations = @{
        @0: @"hsla(164, 100%, 88%, 0)",
        @0.5: @"hsla(164, 100%, 88%, 0.50)",
        @1: @"hsla(164, 100%, 88%, 1)"
    };

    for(NSNumber *alpha in expectations) {
        NSColor *color = [NSColor colorFromString:@"c0ffee"];
        NSString *expectation = [expectations objectForKey:alpha];

        XCTAssertEqualObjects(expectation, [[color colorWithAlphaComponent:[alpha floatValue]] toHSLAString:NO]);
    }
}

- (void)testReturnsShortHSLARepresentation {
    XCTAssertEqualObjects(@"164, 100%, 88%, 1", [[NSColor colorFromString:@"#c0ffee"] toHSLAString:YES]);
}

- (void)testReturnsObjectiveCNSColorRepresentation {
    NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
    XCTAssertEqualObjects(@"[NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75]", [color toObjcNSColor:NO]);
}

- (void)testReturnsShortObjectiveCNSColorRepresentation {
    NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
    XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toObjcNSColor:YES]);
}

- (void)testReturnsObjectiveCUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"[UIColor colorWithRed:0.752941 green:1.0 blue:0.933333 alpha:0.75]", [color toObjcUIColor:NO]);
}

- (void)testReturnsShortObjectiveCUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toObjcUIColor:YES]);
}

- (void)testReturnsSwiftNSColorRepresentation {
  NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
  XCTAssertEqualObjects(@"NSColor(calibratedRed:0.752941, green:1.0, blue:0.933333, alpha:0.75)", [color toSwiftNSColor:NO]);
}

- (void)testReturnsShortSwiftCNSColorRepresentation {
  NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
  XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toSwiftNSColor:YES]);
}

- (void)testReturnsSwiftUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"UIColor(red:0.752941, green:1.0, blue:0.933333, alpha:0.75)", [color toSwiftUIColor:NO]);
}

- (void)testReturnsShortSwiftUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toSwiftUIColor:YES]);
}


- (void)testReturnsMotionNSColorRepresentation {
  NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
  XCTAssertEqualObjects(@"NSColor.colorWithCalibratedRed(0.752941, green:1.0, blue:0.933333, alpha:0.75)", [color toMotionNSColor:NO]);
}

- (void)testReturnsShortMotionCNSColorRepresentation {
  NSColor *color = [NSColor colorWithCalibratedRed:0.752941 green:1.0 blue:0.933333 alpha:0.75];
  XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toMotionNSColor:YES]);
}

- (void)testReturnsMotionUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"UIColor.colorWithRed(0.752941, green:1.0, blue:0.933333, alpha:0.75)", [color toMotionUIColor:NO]);
}

- (void)testReturnsShortMotionUIColorRepresentation {
  CGFloat components[4] = {0.752941, 1.0, 0.933333, 0.75};
  NSColor *color = [NSColor colorWithColorSpace:[NSColorSpace sRGBColorSpace] components:components count:4];
  XCTAssertEqualObjects(@"0.752941 1 0.933333 0.75", [color toMotionUIColor:YES]);
}

@end
