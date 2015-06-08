//
//  TEALDatasourceStore+TEALAudienceStreamAdditions.h
//  ASTester
//
//  Created by George Webster on 4/15/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <TealiumUtilities/TEALDatasourceStore.h>
#import "TEALAudienceStreamDatasources.h"
#import "TEALEvent.h"

@interface TEALDatasourceStore (TEALAudienceStreamAdditions)

- (void) loadWithUUIDKey:(NSString *)key;

- (NSDictionary *) systemInfoDatasources;

- (NSDictionary *) datasourcesForEventType:(TEALEventType)eventType;

@end
