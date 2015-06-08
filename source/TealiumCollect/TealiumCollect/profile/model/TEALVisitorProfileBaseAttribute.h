//
//  TEALVisitorProfileAttribute.h
//  Tealium Collect Library
//
//  Created by George Webster on 2/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TEALVisitorProfileAttributeType) {
    TEALVisitorProfileAttributeTypeAudience,
    TEALVisitorProfileAttributeTypeBadge,
    TEALVisitorProfileAttributeTypeDate,
    TEALVisitorProfileAttributeTypeFlag,
    TEALVisitorProfileAttributeTypeMetric,
    TEALVisitorProfileAttributeTypeProperty
};

@interface TEALVisitorProfileBaseAttribute : NSObject <NSCoding>

@property (copy, nonatomic) NSString *attributeID;

@property (readonly) TEALVisitorProfileAttributeType type;

+ (instancetype) profileAttributeWithType:(TEALVisitorProfileAttributeType)type;

- (instancetype) initWithType:(TEALVisitorProfileAttributeType)type;

- (BOOL) isEqualAttribute:(id)object;

@end



