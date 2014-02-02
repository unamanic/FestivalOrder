//
//  NSColor+BOColor.m
//  FestivalOrders
//
//  Created by William Witt on 2/1/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "NSColor+BOColor.h"

@implementation NSColor (BOColor)

-(NSString *)hexadecimalValueOfAnNSColor
{
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int) (self.redComponent * 0xFF), (int) (self.greenComponent * 0xFF),
            (int) (self.blueComponent * 0xFF)];;
}

@end
