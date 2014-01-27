//
//  BOReportViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/27/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface BOReportViewController : NSViewController <NSWindowDelegate>

@property (weak) IBOutlet WebView *web;
@end
