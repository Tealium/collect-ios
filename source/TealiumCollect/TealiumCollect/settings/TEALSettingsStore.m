//
//  TEALSettingsStore.m
//  Tealium Collect Library
//
//  Created by George Webster on 12/29/14.
//  Copyright (c) 2015 Tealium. All rights reserved.
//

#import "TEALSettingsStore.h"
#import "TEALSettings.h"
#import "TEALNetworkHelpers.h"
#import "TEALOperationManager.h"
#import "TEALURLSessionManager.h"
#import "TEALCollectConfiguration.h"
#import "TEALAudienceStreamDatasources.h"
#import "TEALError.h"
#import "TEALLogger.h"


static NSString * const kTEALAudienceStreamSettingsStorageOldKey = @"com.tealium.audiencestream.settings";
static NSString * const kTEALAudienceStreamSettingsStorageKey = @"com.tealium.audiencestream.settings.1";

@interface TEALSettingsStore()

@property (strong, nonatomic) TEALSettings *currentSettings;

@end

@implementation TEALSettingsStore

- (instancetype) initWithConfiguration:(id<TEALSettingsStoreConfiguration>)configuration {

    self = [self init];
    
    if (self) {
        _configuration = configuration;
    }
    
    return self;
}

#pragma mark - Settings Creation / Persistance

- (TEALSettings *) settingsFromConfiguration:(TEALCollectConfiguration *)configuration visitorID:(NSString *)visitorID {

    if (!configuration.accountName) {
        return nil;
    }

    TEALSettings *settings = [TEALSettings settingWithConfiguration:configuration
                                                          visitorID:visitorID];

    if (self.currentSettings) {
        self.currentSettings.account            = settings.account;
        self.currentSettings.tiqProfile         = settings.tiqProfile;
        self.currentSettings.asProfile          = settings.asProfile;
        self.currentSettings.environment        = settings.environment;
        self.currentSettings.visitorID          = settings.visitorID;
        self.currentSettings.useHTTP            = settings.useHTTP;
        self.currentSettings.pollingFrequency   = settings.pollingFrequency;
        self.currentSettings.logLevel           = settings.logLevel;
    } else {
        self.currentSettings = settings;
    }
    
    return self.currentSettings;
}

- (void) unarchiveCurrentSettings {

    __weak TEALSettingsStore *weakSelf = self;
    
    [[self.configuration operationManager] addIOOperationWithBlock:^{

        NSData *settingsData = [[NSUserDefaults standardUserDefaults] objectForKey:kTEALAudienceStreamSettingsStorageKey];
        
        TEALSettings *settings = [NSKeyedUnarchiver unarchiveObjectWithData:settingsData];

        [weakSelf.configuration.operationManager addOperationWithBlock:^{

            if (settings) {
                weakSelf.currentSettings = settings;
            }

        }];
        
        // legacy archived TEALSettings contains classes that no longer exist.  unarchiving will crash, safest to remvoe them
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTEALAudienceStreamSettingsStorageOldKey];
    }];
}

- (void) archiveCurrentSettings {
    
    NSData *settingsData = [NSKeyedArchiver archivedDataWithRootObject:self.currentSettings];
    
    [[self.configuration operationManager] addIOOperationWithBlock:^{
        
        [[NSUserDefaults standardUserDefaults] setObject:settingsData
                                                  forKey:kTEALAudienceStreamSettingsStorageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

#pragma mark - Requests

- (void) fetchRemoteSettingsWithSetting:(TEALSettings *)settings
                             completion:(TEALSettingsCompletionBlock)completion {

    if (self.currentSettings.status == TEALSettingsStatusLoadedRemote) {
        completion( self.currentSettings, nil );
        
        return;
    }

    NSString *baseURL = [self.configuration mobilePublishSettingsURLStringForSettings:self.currentSettings];
    NSDictionary *params = [self.configuration mobilePublishSettingsURLParams];

    NSString *queryString = [TEALNetworkHelpers urlParamStringFromDictionary:params];
    
    NSString *settingsURLString = [baseURL stringByAppendingString:queryString];
    
    NSURLRequest *request = [TEALNetworkHelpers requestWithURLString:settingsURLString];

    if (!request) {
        
        NSError *error = [TEALError errorWithCode:TEALErrorCodeMalformed
                                      description:@"Settings request unsuccessful"
                                           reason:[NSString stringWithFormat:@"Failed to generate valid request from URL string: %@", settingsURLString]
                                       suggestion:@"Check the Account/Profile/Enviroment values in your configuration"];

        settings.status = TEALSettingsStatusInvalid;
        
        completion( settings, error );
        return;
    }
    
    TEALHTTPResponseBlock requestCompletion = ^(NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {

        if (connectionError) {
            
            completion( self.currentSettings, connectionError);
            
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *parsedData = [self mobilePublishSettingsFromHTMLData:data
                                                                     error:&parseError];
        
        if (parsedData) {
            [settings storeMobilePublishSettings:parsedData];
            settings.status = TEALSettingsStatusLoadedRemote;
        } else {
            settings.status = TEALSettingsStatusInvalid;
        }

        self.currentSettings = settings;
        
        completion( self.currentSettings, parseError );
    };
    
    [[self.configuration urlSessionManager] performRequest:request
                                            withCompletion:requestCompletion];
}

#pragma mark - Data Helpers

- (NSDictionary *) mobilePublishSettingsFromHTMLData:(NSData *)data error:(NSError **)error {
    
    NSDictionary *resultDictionary = nil;
    
    NSString *dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];

    NSError *regexError = nil;
    
    NSString *scriptContentsPattern = @"<script.+>.+</script>";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:scriptContentsPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexError];
    if (!regex) {
        *error = regexError;
        return nil;
    }
    
    __block NSString *scriptContents = nil;
    
    [regex enumerateMatchesInString:dataString
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, dataString.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             if (result) {
                                 TEAL_LogExtreamVerbosity(@"text checking result: %@", result);
                             }
                             
                             if (result.range.location != NSNotFound) {
                                 scriptContents = [dataString substringWithRange:result.range];
                                 
                                 if (scriptContents) {
                                     TEAL_LogExtreamVerbosity(@"scriptContents: %@", scriptContents);
                                 }
                                 
                                 *stop = YES;
                             }
                         }];
    
    if (!scriptContents) {
        
        return nil;
    }

    NSRange mpsRangeStart = [scriptContents rangeOfString:@"var mps = "
                                             options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, scriptContents.length)];
    
    if (mpsRangeStart.location == NSNotFound) {
        
        TEAL_LogVerbose(@"mobile publish settings not found! old mobile library extension is not supported.  ");
        
        *error = [TEALError errorWithCode:TEALErrorCodeNotAcceptable
                              description:@"Mobile publish settings not found."
                                   reason:@"Mobile publish settings not found. While parsing mobile.html"
                               suggestion:@"Please enable mobile publish settings in Tealium iQ."];
        
        return nil;
    }
    
    NSUInteger startIndex = NSMaxRange( mpsRangeStart );
    NSUInteger endLength = scriptContents.length - startIndex;
    NSRange mpsRangeEnd = [scriptContents rangeOfString:@"</script>"
                                                options:NSCaseInsensitiveSearch
                                                  range:NSMakeRange(startIndex, endLength)];
    
    if (mpsRangeEnd.location == NSNotFound) {
        return nil;
    }
    
    NSRange mpsRange = NSMakeRange(startIndex, ( mpsRangeEnd.location - startIndex ) );
    
    NSString *mpsDataString = [scriptContents substringWithRange:mpsRange];
    
    TEAL_LogExtreamVerbosity(@"mpsDataString: %@", mpsDataString);
    
    NSData *mpsJSONData = [mpsDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError = nil;
    
    resultDictionary = [NSJSONSerialization JSONObjectWithData:mpsJSONData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&jsonError];
    
    if (!resultDictionary) {
        *error = jsonError;
        return nil;
    }
    
    return resultDictionary;
}

@end
