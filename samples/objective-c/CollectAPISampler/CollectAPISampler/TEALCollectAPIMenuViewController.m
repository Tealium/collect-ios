//
//  TEALCollectAPIMenuViewController.m
//  Tealium Collect Library
//
//  Created by George Webster on 3/9/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

#import "TEALCollectAPIMenuViewController.h"

#import <TealiumCollect/TealiumCollect.h>

typedef NS_ENUM(NSUInteger, CollectAPIMenuItem) {
    CollectAPIMenuItemSendEvent = 0,
    CollectAPIMenuItemSendView,
    CollectAPIMenuItemFetchProfle,
    CollectAPIMenuItemLogLastProfile,
    CollectAPIMenuItemNumberOfItems
};

@interface TEALCollectAPIMenuViewController ()

@end

@implementation TEALCollectAPIMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"API Sampler";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CollectAPIMenuItemNumberOfItems;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APIMenuCellIdentifier"];
    
    if (cell) {
        switch (indexPath.row) {
            case CollectAPIMenuItemSendEvent:
                cell.textLabel.text = @"Send Event";
                break;
            case CollectAPIMenuItemSendView:
                cell.textLabel.text = @"Send View";
                break;
            case CollectAPIMenuItemFetchProfle:
                cell.textLabel.text = @"Fetch Current Profile";
                break;
            case CollectAPIMenuItemLogLastProfile:
                cell.textLabel.text = @"Log Last Loaded Profile";
                break;
                
            default:
                break;
        }

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case CollectAPIMenuItemSendEvent:
            [self sendCollectEvent];
            break;
        case CollectAPIMenuItemSendView:
            [self sendCollectView];
            break;
        case CollectAPIMenuItemFetchProfle:
            [self fetchVisitorProfile];
            break;
        case CollectAPIMenuItemLogLastProfile:
            [self accessLastLoadedVisitorProfile];
            break;
        default:
            break;
    }
}


- (void) sendCollectView {
    
    NSDictionary *data = @{ @"custom_key" : @"custom_value"};
    
    [TealiumCollect sendViewWithData:data];
}

- (void) sendCollectEvent {
    
    NSDictionary *data = @{ @"custom_key" : @"custom_value"};
    
    [TealiumCollect sendEventWithData:data];
}

- (void) fetchVisitorProfile {
    
    [TealiumCollect fetchVisitorProfileWithCompletion:^(TEALVisitorProfile *profile, NSError *error) {
       
        if (error) {
            NSLog(@"test app failed to receive profile with error: %@", [error localizedDescription]);
        } else {
            NSLog(@"test app received profile: %@", profile);
        }
        
    }];
}

- (void) accessLastLoadedVisitorProfile {

    TEALVisitorProfile *profile = [TealiumCollect cachedVisitorProfileCopy];

    if (profile) {
        NSLog(@"last loaded profile: %@", profile);
    } else {
        NSLog(@"a valid profile has not been received yet.");
    }
}

- (void) presentTraceInputView {
    
}

- (void) joinTraceWithToken:(NSString *)token {
    
    [TealiumCollect joinTraceWithToken:token];
}

- (void) leaveTrace {
    [TealiumCollect leaveTrace];
}


@end
