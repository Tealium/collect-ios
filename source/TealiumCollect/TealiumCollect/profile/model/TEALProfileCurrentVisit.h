//
//  TEALProfileCurrentVisit.h
//  AS_Tests_UICatalog
//
//  Created by George Webster on 3/9/15.
//  Copyright (c) 2015 f. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEALProfileCurrentVisit : NSObject <NSCoding, NSCopying>

@property (readonly) NSTimeInterval creationTimestamp;

@property (readonly, nonatomic) NSArray *dates;
@property (readonly, nonatomic) NSArray *flags;
@property (readonly, nonatomic) NSArray *metrics;
@property (readonly, nonatomic) NSArray *properties;

@property (readonly) NSInteger totalEventCount;

@end
