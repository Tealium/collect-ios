//
//  TEALProfileAttribute.h
//  TEALAudienceStream
//
//  Created by George Webster on 2/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TEALProfileAttributeType) {
    TEALProfileAttributeTypeAudience,
    TEALProfileAttributeTypeBadge,
    TEALProfileAttributeTypeDate,
    TEALProfileAttributeTypeFlag,
    TEALProfileAttributeTypeMetric,
    TEALProfileAttributeTypeProperty
};

@interface TEALProfileAttribute : NSObject <NSCoding>

@property (copy, nonatomic) NSString *attributeID;

@property (readonly) TEALProfileAttributeType type;

+ (instancetype) profileAttributeWithType:(TEALProfileAttributeType)type;

- (instancetype) initWithType:(TEALProfileAttributeType)type;

- (BOOL) isEqualAttribute:(id)object;

@end


@interface TEALProfileAudienceAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *name;

@end

@interface TEALProfileBadgeAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *name;

@end

@interface TEALProfileDateAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) NSTimeInterval timestamp;

@end

@interface TEALProfileFlagAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) BOOL value;

@end

@interface TEALProfileMetricAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (nonatomic) float value;

@end

/**
 Personal information about the user.
 
 also know as a "Trait" via the AS Web App.
 */
@interface TEALProfilePropertyAttribute : TEALProfileAttribute <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *value;

@end

