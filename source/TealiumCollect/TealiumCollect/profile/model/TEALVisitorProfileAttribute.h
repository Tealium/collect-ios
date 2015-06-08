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

@interface TEALVisitorProfileAttribute : NSObject <NSCoding>

@property (copy, nonatomic) NSString *attributeID;

@property (readonly) TEALVisitorProfileAttributeType type;

+ (instancetype) profileAttributeWithType:(TEALVisitorProfileAttributeType)type;

- (instancetype) initWithType:(TEALVisitorProfileAttributeType)type;

- (BOOL) isEqualAttribute:(id)object;

@end


@interface TEALVisitorProfileAudienceAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *name;

@end

@interface TEALVisitorProfileBadgeAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *name;

@end

@interface TEALVisitorProfileDateAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) NSTimeInterval timestamp;

@end

@interface TEALVisitorProfileFlagAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) BOOL value;

@end

@interface TEALVisitorProfileMetricAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) float value;

@end

/**
 Personal information about the user.
 
 also know as a "Trait" via the AS Web App.
 */
@interface TEALVisitorProfilePropertyAttribute : TEALVisitorProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *value;

@end

