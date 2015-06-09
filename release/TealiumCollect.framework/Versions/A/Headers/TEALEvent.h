//
//  TEALEvent.h
//  Tealium Collect Library
//
//  Created by George Webster on 5/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Event Types
//      used in TealiumCollect sendEvent:withData
//
typedef NS_ENUM(NSUInteger, TEALEventType) {
    TEALEventTypeLink,
    TEALEventTypeView
};

extern NSString * const TEALEventTypeLinkStringValue;
extern NSString * const TEALEventTypeViewStringValue;

@interface TEALEvent : NSObject

@end
