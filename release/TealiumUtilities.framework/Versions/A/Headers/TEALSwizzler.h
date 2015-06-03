//
//  TEALSwizzler.h
//  TealiumUtilities
//
//  Created by George Webster on 2/27/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TEALSwizzler : NSObject

+ (void) swizzleClass:(Class)class
             selector:(SEL)originalSelector
          newSelector:(SEL)newSelector;

@end
