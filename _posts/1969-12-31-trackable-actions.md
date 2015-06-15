---
layout: post
title: Trackable Actions
subtitle: figure out what to track
---

* [Views](trackable-actions.html#views)
* [Events](trackable-actions.html#events)

<hr/>

<!--more--> 

### <span id="views"/> Views

Screen Views are some of the simplest and useful data to collect, track these using the [sendViewWithData:](documentation/html/Classes/TealiumCollect.html#//api/name/sendViewWithData:) method: 

##### Objective-C

```objective-c
- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    NSDictionary *data = @{@"screen_title" : @"main",
                           @"view_action"  : @"appeared" };

    [TealiumCollect sendViewWithData:data];
}

- (void) viewDidDisappear:(BOOL)animated {
	
    [super viewDidDisappear:animated];

    NSDictionary *data = @{@"screen_title" : @"main",
                           @"view_action"  : @"disappeared" };

    [TealiumCollect sendViewWithData:data];
}
```
##### Swift

```swift
override func viewDidAppear(animated: Bool) {

    super.viewDidAppear(animated)

    let data: [String: String] = ["screen_title" : "main",
                                  "view_action"  : "appeared"]

    TealiumCollect.sendViewWithData(data)
}

override func viewDidDisappear(animated: Bool) {

    super.viewDidDisappear(animated)

    let data: [String: String] = ["screen_title" : "main",
                                  "view_action"  : "disappeared"]

    
    TealiumCollect.sendViewWithData(data)
}
```

Not only will this setup allow for view counts, but it also provides AudienceStream enough infomration to determine how much time is spent on every view. 

### <span id="events"/> Events

Button taps, other UI interactions and milestones passed are simple data points that can be collected with the similar [sendEventWithData:](documentation/html/Classes/TealiumCollect.html#//api/name/sendEventWithData:) method:  

##### Objective-C

```objective-c
- (IBAction) buttonTapped:(id)sender {

    NSDictionary *data = @{@"event_type"  : @"button_tapped",
                           @"event_name"  : @"buy_button",
                           @"assoc_view"  : @"store",
                           @"cart_value": : @"10.00"};

    [TealiumCollect sendEventWithData:data];
}
```

##### Swift

```swift
@IBAction func buttonTapped(sender: AnyObject) {

    let data: [String: String] = ["event_type" : "button_tapped",
                                  "event_name: : "buy_button",
                                  "assoc_view" : "store",
                                  "cart_value" : "10.00"]

    TealiumCollect.sendEventWithData(data)
}
```


### Don&apos;t forget some other user behaviors: 

* Geofencing
* Beacons
* Scores
* Spending 

Every application offers something to its users, so don&apos;t forget events unique to your app!