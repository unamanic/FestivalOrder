//
//  Band.h
//  FestivalOrders
//
//  Created by William Witt on 2/2/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BandCategory, Event, Order;

@interface Band : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pointOfContact;
@property (nonatomic, retain) NSDate * readyTime;
@property (nonatomic, retain) NSString * stage;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) BandCategory *category;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *orders;
@end

@interface Band (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
