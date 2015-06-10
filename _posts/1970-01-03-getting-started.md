---
layout: post
title: Getting Started
subtitle: a quick start guide
---

- [Requirements](getting-started.html#requirements)
- [Setup](getting-started.html#setup)
	- [Clone Library](getting-started.html#clone-library)
	- [Add to Project](getting-started.html#add-to-project)
	- [Link Frameworks](getting-started.html#link-frameworks)
	- [Add Linker Flags](getting-started.html#add-linker-flags)
	- [Import Headers](getting-started.html#import-headers)
- [Enable](getting-started.html#enable)
- [Send Action Data](getting-started.html#send-action-data)
- [Fetch Visitor Profile](getting-started.html#fetch-visitor-profile)

<hr/>
 
<!--more-->
 
### <span id="requirements"/> Requirements

- [XCode (6.0+ recommended)](https://developer.apple.com/xcode/downloads/)
- Minimum target iOS Version 7.0+


### <span id="setup"/>Setup
This is a walk through of setting up a simple project to use the AudienceStream(http://tealium.com/products/audiencestream/) iOS library.

#### <span id="clone-library"/> 1. Clone Library

Clone or download the library repo onto your dev machine by clicking on the *Clone to Desktop* or *Download ZIP* buttons on the main repo page.

#### <span id="add-to-project"/> 2. Add to Project

From the *audiencestream-ios/Release* folder, drag & drop the *TealiumUtilities* and *TEALAudienceStream* frameworks into your XCode project's Navigation window.

#### <span id="link-frameworks"/> 3. Link Frameworks

[Link the following Apple framework](https://developer.apple.com/library/ios/recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html) to your project:

- SystemConfiguration

#### <span id="add-linker-flags"/> 4. Add Linker Flags

Add the "-ObjC" linker flag to your project's Target-Build Settings.

#### <span id="import-headers"/> 5. Import Headers

##### Objective-C
For Objective-C import the library at the top of any file you wish to access the library in:

```objective-c
#import <TEALAudienceStream/TEALAudienceStream.h>
```
##### Swift

In swift you'll need to Update your project's Objective-C bridging header or create one with the following entries:

```objective-c
#import <TEALAudienceStream/TEALAudienceStream.h>
#import <TEALAudienceStream/TEALAudienceStreamConfiguration.h>
#import <TEALAudienceStream/TEALProfile.h>
#import <TEALAudienceStream/TEALEvent.h>
```

### <span id="enable"/> Enable

Enable the library with a configuration (```TEALAudienceStreamConfiguration```) instance in your appDelegate class:

##### Objective-C

```objective-c
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TEALAudienceStreamConfiguration *config = [TEALAudienceStreamConfiguration configurationWithAccount:@"tealiummobile"
                                                                                                profile:@"demo"
                                                                                            environment:@"dev"];
    
    config.logLevel = TEALAudienceStreamLogLevelVerbose;
    
    [TEALAudienceStream enableWithConfiguration:config];
    
    return YES;
}
```

##### Swift

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let configuration = TEALAudienceStreamConfiguration(account: "tealiummobile", profile: "demo", environment: "dev")
    
    configuration.logLevel = TEALAudienceStreamLogLevel.Verbose
    
    TEALAudienceStream.enableWithConfiguration(configuration)
    
    return true
}
```

### <span id="send-action-data"/> Send Action Data

After determining what visitor behaviors should be tracked, utilize the ```sendEvent:withData``` method to send link or view events with relevant data to AudienceStream:

##### Objective-C

```objective-c
- (void) sendLifecycleEventWithName:(NSString *)eventName {

    NSDictionary *data = @{@"event_name" : eventName};
    
    [TEALAudienceStream sendEvent:TEALEventTypeLink
                         withData:data];

}
```
##### Swift

```swift
func sendLifecycleEventWithName(name: String) {
    
    let data: [String: String] = ["event_name" : name]
    
    TEALAudienceStream.sendEvent(TEALEventType.Link, withData: data)
}
```

For more information see [Trackable Actions](trackable-actions.html)

### <span id="fetch-visitor-profile"/> Fetch Visitor Profile

The ```AudienceStream``` library offers a variety of means to identifiy visitor behavior and offer a personalized app experience via  Data layer enrichment.

Access the enriched Visitor Profile from AudienceStream using one of two methods:

First access to the last profile the library received is always available via the ```cachedProfileCopy```  method:

##### Objective-C

```objective-c
- (void) accessLastLoadedAudienceStreamProfile {

    TEALProfile *profile = [TEALAudienceStream cachedProfileCopy];

    if (profile) {
        NSLog(@"last loaded profile: %@", profile);
    } else {
        NSLog(@"a valid profile has not been received yet.");
    }
}
```

##### Swift

```swift
func accessLastLoadedAudienceStreamProfile() {
    
    if let profile:TEALProfile = TEALAudienceStream.cachedProfileCopy() {
        println("last loaded profile: \(profile)")
    } else {
        println("a valid profile has not been received yet.")
    }
}
```

Second to explicitly fetch a new copy of the user's current profile you can use the ```fetchProfileWithCompletion:``` method.  This will query the latest profile and pass the result to the completion block provided:

##### Objective-C

```objective-c
- (void) fetchAudienceStreamProfile {
    
    [TEALAudienceStream fetchProfileWithCompletion:^(TEALProfile *profile, NSError *error) {
       
        if (error) {
            NSLog(@"test app failed to receive profile with error: %@", [error localizedDescription]);
        } else {
            NSLog(@"test app received profile: %@", profile);
        }
        
    }];
}
```

##### Swift

```swift
func fetchAudienceStreamProfile() {
    
    TEALAudienceStream.fetchProfileWithCompletion { (profile, error) -> Void in
        
        if (error != nil) {
            println("test app failed to receive profile with error: \(error.localizedDescription)")
        } else {
            println("test app received profile: \(profile)")
        }
    }
}
```