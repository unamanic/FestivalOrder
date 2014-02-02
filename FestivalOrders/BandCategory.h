//
//  BandCategory.h
//  FestivalOrders
//
//  Created by William Witt on 1/27/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band;

@interface BandCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bands;
@end

@interface BandCategory (CoreDataGeneratedAccessors)

- (void)addBandsObject:(Band *)value;
- (void)removeBandsObject:(Band *)value;
- (void)addBands:(NSSet *)values;
- (void)removeBands:(NSSet *)values;

@end
