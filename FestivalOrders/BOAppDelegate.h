//
//  BOAppDelegate.h
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSArrayController *inventoryArrayContoller;
@property (weak) IBOutlet NSArrayController *eventArrayController;

@property (strong) NSArray *inventorySortDescriptor;
@property (strong) NSArray *orderSortDescriptor;

- (IBAction)saveAction:(id)sender;

- (NSURL *)getLogoURL;
@end
