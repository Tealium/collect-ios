//
//  TEALAudienceStreamDatasources.m
//  ASTester
//
//  Created by George Webster on 4/17/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALAudienceStreamDatasources.h"

#pragma mark - UDO / Datasource Keys

NSString const * TEALDatasourceKey_EventName        = @"event_name";
NSString const * TEALDatasourceKey_Pagetype         = @"page_type";
NSString const * TEALDatasourceKey_Platform         = @"platform";
NSString const * TEALDatasourceKey_SystemVersion    = @"os_version";
NSString const * TEALDatasourceKey_LibraryVersion   = @"library_version";
NSString const * TEALDatasourceKey_UUID             = @"uuid";
NSString const * TEALDatasourceKey_ApplicationName  = @"app_name";
NSString const * TEALDatasourceKey_Timestamp        = @"timestamp";
NSString const * TEALDatasourceKey_CallType         = @"callType";

#pragma mark - AudienceStream API Keys

NSString const * TEALAudienceStreamKey_Account      = @"tealium_account";
NSString const * TEALAudienceStreamKey_Profile      = @"tealium_profile";
NSString const * TEALAudienceStreamKey_Environment  = @"tealium_environment";
NSString const * TEALAudienceStreamKey_VisitorID    = @"tealium_vid";
NSString const * TEALAudienceStreamKey_TraceID      = @"tealium_trace_id";

@implementation TEALAudienceStreamDatasources

@end
