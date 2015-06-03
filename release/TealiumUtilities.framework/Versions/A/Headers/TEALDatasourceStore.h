//
//  TEALDatasourceStore.h
//  TealiumUtilities
//
//  Created by George Webster on 4/8/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEALDatasourceStore : NSObject

+ (instancetype) sharedStore;

- (id) objectForKey:(id<NSCopying, NSSecureCoding>)key;

- (void) setObject:(id<NSCopying, NSSecureCoding>)object
            forKey:(id<NSCopying, NSSecureCoding>)aKey;

- (id) objectForKeyedSubscript:(id <NSCopying, NSSecureCoding>)key;

- (void) setObject:(id)obj forKeyedSubscript:(id <NSCopying, NSSecureCoding>)key;

- (BOOL) unarchiveWithStorageKey:(NSString *)key;
- (void) archiveWithStorageKey:(NSString *)key;

@end
