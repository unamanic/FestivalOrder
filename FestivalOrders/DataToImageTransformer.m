//
//  DataToImageTransformer.m
//  FestivalOrders
//
//  Created by William Witt on 2/2/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "DataToImageTransformer.h"

@implementation DataToImageTransformer


+ (Class)transformedValueClass {
    return [NSImage class];
} // the class of the return value from transformedValue:

+ (BOOL)allowsReverseTransformation {
    return YES;
} // if YES then must also have reverseTransformedValue:

- (id)transformedValue:(id)value {
    if (value == nil || [value length] < 1) return nil;
    NSImage* i = nil;
    if ([value isKindOfClass:[NSData class]]) {
        i = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    }
    return i;
}

- (id)reverseTransformedValue:(id)value {
    if (value == nil) return nil;
    NSData* d = nil;
    if ([value isKindOfClass:[NSImage class]]) {
        d = [NSKeyedArchiver archivedDataWithRootObject:value];
    }
    return d;
}

@end
