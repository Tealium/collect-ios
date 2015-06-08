//
//  TEALDatasourceStore+TealiumCollectAdditions.h
//  Tealium Collect Library
//
//  Created by George Webster on 4/15/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <TealiumUtilities/TEALDatasourceStore.h>
#import "TEALCollectDatasources.h"
#import "TEALEvent.h"

@interface TEALDatasourceStore (TealiumCollectAdditions)

- (void) loadWithUUIDKey:(NSString *)key;

- (NSDictionary *) systemInfoDatasources;

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType;

@end
