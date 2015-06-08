//
//  TEALSimpleNetworkManager.m.h
//  TealiumUtilities
//
//  Created by George Webster on 2/26/15.
//
//
// Simple network manager to do dumb network requests which don't require granualar control.


#import <Foundation/Foundation.h>
#import "TEALBlocks.h"

@interface TEALSimpleNetworkManager : NSObject

@property (strong, nonatomic) NSOperationQueue *responseQueue;

- (void) sendAsynchronousRequest:(NSURLRequest *)request
               completionHandler:(TEALURLResponseBlock)completionHandler;

@end
