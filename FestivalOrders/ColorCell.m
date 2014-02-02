//
//  ColorCell.m
//  FestivalOrders
//
//  Created by William Witt on 1/28/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "ColorCell.h"

@implementation ColorCell

- (void) drawWithFrame: (NSRect) cellFrame inView: (NSView*)
controlView {
    NSRect sqare = NSInsetRect (cellFrame, 0.5, 0.5);
    
    // use the smallest size to sqare off the box & center the box
    if (sqare.size.height < sqare.size.width) {
        sqare.size.width = sqare.size.height;
        sqare.origin.x = sqare.origin.x + (cellFrame.size.width -
                                           sqare.size.width) / 2.0;
    } else {
        sqare.size.height = sqare.size.width;
        sqare.origin.y = sqare.origin.y + (cellFrame.size.height -
                                           sqare.size.height) / 2.0;
    }
    
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect: sqare];
    
    [(NSColor*) [self objectValue] set];
    [NSBezierPath fillRect: NSInsetRect (sqare, 2.0, 2.0)];
}

@end

