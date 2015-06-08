//
//  TEALDispatch.h
//  TealiumUtilities
//
//  Created by George Webster on 2/13/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEALDispatch : NSObject <NSCoding>

@property (strong, nonatomic) NSObject<NSCoding> *payload;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) BOOL queued;

@end
