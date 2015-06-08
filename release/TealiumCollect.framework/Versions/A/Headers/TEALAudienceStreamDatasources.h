//
//  TEALAudienceStreamDatasources.h
//  ASTester
//
//  Created by George Webster on 4/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - UDO / Datasource Keys

extern NSString const * TEALDatasourceKey_EventName;
extern NSString const * TEALDatasourceKey_Pagetype;
extern NSString const * TEALDatasourceKey_Platform;
extern NSString const * TEALDatasourceKey_SystemVersion;
extern NSString const * TEALDatasourceKey_LibraryVersion;
extern NSString const * TEALDatasourceKey_UUID;
extern NSString const * TEALDatasourceKey_ApplicationName;
extern NSString const * TEALDatasourceKey_Timestamp;
extern NSString const * TEALDatasourceKey_CallType;

#pragma mark - AudienceStream API Keys

extern NSString const * TEALAudienceStreamKey_Account;
extern NSString const * TEALAudienceStreamKey_Profile;
extern NSString const * TEALAudienceStreamKey_Environment;
extern NSString const * TEALAudienceStreamKey_VisitorID;
extern NSString const * TEALAudienceStreamKey_TraceID;

@interface TEALAudienceStreamDatasources : NSObject

@end
