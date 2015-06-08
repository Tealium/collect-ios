//
//  TEALVisitorProfileDelegate.h
//  Tealium Collect Library
//
//  Created by George Webster on 5/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TEALVisitorProfileAttribute.h"

@protocol TEALVisitorProfileDelegate <NSObject>

- (void) didUpdateProfile:(TEALVisitorProfile *)oldProfile newProfile:(TEALVisitorProfile *)newProfile;

@end
