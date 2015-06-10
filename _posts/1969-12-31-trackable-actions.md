---
layout: post
title: Trackable Actions
subtitle: figure out what to track
---

* [Views](trackable-actions.html#views)
* [Links](trackable-actions.html#links)

<hr/>

<!--more--> 

### <span id="views"/> Views

Screen Views are some of the simplest and useful data to collect, track these with the following: 

##### Objective-C

```objective-c
- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    NSDictionary *data = @{@"screen_title" : @"main",
                           @"view_action"  : @"appeared" };

    [TEALAudienceStream sendEvent:TEALEventTypeView
    					 withData:data];
}

- (void) viewDidDisappear:(BOOL)animated {
	
    [super viewDidDisappear:animated];

    NSDictionary *data = @{@"screen_title" : @"main",
                           @"view_action"  : @"disappeared" };

    [TEALAudienceStream sendEvent:TEALEventTypeView
    					 withData:data];
}
```
##### Swift

```swift
override func viewDidAppear(animated: Bool) {

    super.viewDidAppear(animated)

    let data: [String: String] = ["screen_title" : "main",
                                  "view_action"  : "appeared"]

    TEALAudienceStream.sendEvent(TEALEventType.View, withData: data)
}

override func viewDidDisappear(animated: Bool) {

    super.viewDidDisappear(animated)

    let data: [String: String] = ["screen_title" : "main",
                                  "view_action"  : "disappeared"]

    
    TEALAudienceStream.sendEvent(TEALEventType.View, withData: data)
}
```

Not only will this setup allow for view counts, but it also provides AudienceStream enough infomration to determine how much time is spent on every view. 

### <span id="links"/> Links

Button taps, other UI interactions and milestones passed are simple data points that can be collected with the same ```sendEvent:withData:``` call:  

##### Objective-C

```objective-c
- (IBAction) buttonTapped:(id)sender {

    NSDictionary *data = @{@"event_type" : @"button_tapped",
                           @"event_name" : @"buy_button",
                           @"assoc_view" : @"store"
                           @"cart_value: : @"10.00"};

    [TEALAudienceStream sendEvent:TEALEventTypeLink
    					 withData:data];
}
```

##### Swift

```swift
@IBAction func buttonTapped(sender: AnyObject) {

    let data: [String: String] = ["event_type" : "button_tapped",
                                  "event_name: : "buy_button",
                                  "assoc_view" : "store",
                                  "cart_value" : "10.00"]

    TEALAudienceStream.sendEvent(TEALEventType.Link, withData: data)
}
```


### Don&apos;t forget some other user behaviors: 

* Geofencing
* Beacons
* Scores
* Spending 

Every application offers something to its users, so don&apos;t forget events unique to your app!