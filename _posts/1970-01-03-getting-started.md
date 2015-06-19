---
layout: post
title: Getting Started
subtitle: A quick start guide covering all of the basics, including cloning a library, adding code to a project, linking frameworks, adding linker flags, and importing headers.
---
<!--more--> 

<div class="sidebar">
    <div class="context_container pageNavigation_wrapper">
        <span class="context_title">{{ page.title }}</span>
        <ul class="pageNavigation">
            <li><a href="getting-started.html#requirements">Requirements</a></li>
            <li><a href="getting-started.html#setup">Setup</a>
                <ol>
                    <li><a href="getting-started.html#clone-library">Clone Library</a></li>
                    <li><a href="getting-started.html#add-to-project">Add to Project</a></li>
                    <li><a href="getting-started.html#link-frameworks">Link Frameworks</a></li>
                    <li><a href="getting-started.html#add-linker-flags">Add Linker Flags</a></li>
                    <li><a href="getting-started.html#import-headers">Import Headers</a></li>
                </ol>
            </li>
            <li><a href="getting-started.html#enable">Enable</a></li>
            <li><a href="getting-started.html#send-action-data">Send Action Data</a></li>
            <li><a href="getting-started.html#fetch-visitor-profile">Fetch Visitor Profile</a></li>
        </ul>
    </div>
    {% include post-sidebar.html %}
</div>

 
## <span id="requirements"/> Requirements

- [XCode (6.0+ recommended)](https://developer.apple.com/xcode/downloads/)
- Minimum target iOS Version 7.0+


## <span id="setup"/>Setup
This is a walk through of setting up a simple project to use the AudienceStream(http://tealium.com/products/audiencestream/) iOS library.

### <span id="clone-library"/> 1. Clone Library

Clone or download the library repo onto your dev machine by clicking on the *Clone to Desktop* or *Download ZIP* buttons on the main repo page.

### <span id="add-to-project"/> 2. Add to Project

From the *collect-ios/Release* folder, drag & drop the *TealiumUtilities* and *TealiumCollect* frameworks into your XCode project's Navigation window.

### <span id="link-frameworks"/> 3. Link Frameworks

[Link the following Apple framework](https://developer.apple.com/library/ios/recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html) to your project:

- SystemConfiguration

### <span id="add-linker-flags"/> 4. Add Linker Flags

Add the "-ObjC" linker flag to your project's Target-Build Settings.

### <span id="import-headers"/> 5. Import Headers

#### Objective-C
For Objective-C import the library at the top of any file you wish to access the library in:

```objective-c
#import <TealiumCollect/TealiumCollect.h>
```
#### Swift

In swift you'll need to Update your project's Objective-C bridging header or create one with the following entries:

```objective-c
#import <TealiumCollect/TealiumCollect.h>
#import <TealiumCollect/TEALCollectConfiguration.h>
#import <TealiumCollect/TEALVisitorProfile.h>
#import <TealiumCollect/TEALEvent.h>
```

## <span id="enable"/> Enable

Enable the library with a configuration [TEALCollectConfiguration](documentation/html/Classes/TEALCollectConfiguration.html) instance in your appDelegate class:

#### Objective-C

```objective-c
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TEALCollectConfiguration *config = [TEALCollectConfiguration configurationWithAccount:@"tealiummobile"
                                                                                  profile:@"demo"
                                                                              environment:@"dev"];
    
    config.logLevel = TealiumCollectLogLevelVerbose;
    
    [TealiumCollect enableWithConfiguration:config];
    
    return YES;
}
```

#### Swift

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let configuration = TEALCollectConfiguration(account: "tealiummobile", profile: "demo", environment: "dev")
    
    configuration.logLevel = TealiumCollectLogLevel.Verbose
    
    TealiumCollect.enableWithConfiguration(configuration)
    
    return true
}
```

## <span id="send-action-data"/> Send Action Data

After determining what visitor behaviors should be tracked, utilize the [sendEventWithData:](documentation/html/Classes/TealiumCollect.html#//api/name/sendEventWithData:) method to send link or view events with relevant data to AudienceStream:

#### Objective-C

```objective-c
- (void) sendLifecycleEventWithName:(NSString *)eventName {

    NSDictionary *data = @{@"event_name" : eventName};
    
    [TealiumCollect sendEventWithData:data];
}
```
#### Swift

```swift
func sendLifecycleEventWithName(name: String) {
    
    let data: [String: String] = ["event_name" : name]
    
    TealiumCollect.sendEventWithData(data)
}
```

For more information see [Trackable Actions](trackable-actions.html) and [sendViewWithData:](documentation/html/Classes/TealiumCollect.html#//api/name/sendViewWithData:) 

## <span id="fetch-visitor-profile"/> Fetch Visitor Profile

The ```TealiumCollect``` library offers a variety of means to identifiy visitor behavior and offer a personalized app experience via  Data layer enrichment from AudienceStream.

Access the enriched Visitor Profile ([TEALVisitorProfile](documentation/html/Classes/TEALVisitorProfile.html)) from the Collect ibrary using one of two methods:

First access to the last profile the library received is always available via the [cachedVisitorProfileCopy](documentation/html/Classes/TealiumCollect.html#//api/name/cachedVisitorProfileCopy)  method:

#### Objective-C

```objective-c
- (void) accessLastLoadedAudienceStreamProfile {

    TEALVisitorProfile *profile = [TealiumCollect cachedVisitorProfileCopy];

    if (profile) {
        NSLog(@"last loaded profile: %@", profile);
    } else {
        NSLog(@"a valid profile has not been received yet.");
    }
}
```

#### Swift

```swift
func accessLastLoadedAudienceStreamProfile() {
    
    if let profile:TEALVisitorProfile = TealiumCollect.cachedVisitorProfileCopy() {
        println("last loaded profile: \(profile)")
    } else {
        println("a valid profile has not been received yet.")
    }
}
```

Second to explicitly fetch a new copy of the user's current profile you can use the [fetchVisitorProfileWithCompletion:](documentation/html/Classes/TealiumCollect.html#//api/name/fetchVisitorProfileWithCompletion:) method.  This will query the latest profile and pass the result to the completion block provided:

#### Objective-C

```objective-c
- (void) fetchAudienceStreamProfile {
    
    [TealiumCollect fetchVisitorProfileWithCompletion:^(TEALVisitorProfile *profile, NSError *error) {
       
        if (error) {
            NSLog(@"test app failed to receive profile with error: %@", [error localizedDescription]);
        } else {
            NSLog(@"test app received profile: %@", profile);
        }
        
    }];
}
```

#### Swift

```swift
func fetchAudienceStreamProfile() {
    
    TealiumCollect.fetchVisitorProfileWithCompletion { (profile, error) -> Void in
        
        if (error != nil) {
            println("test app failed to receive profile with error: \(error.localizedDescription)")
        } else {
            println("test app received profile: \(profile)")
        }
    }
}
```

For more information see the [TEALVisitorProfile](documentation/html/Classes/TEALVisitorProfile.html) class API documentatoin. 
