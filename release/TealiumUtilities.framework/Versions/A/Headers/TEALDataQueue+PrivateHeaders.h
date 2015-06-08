//
//  TEALDataQueue+PrivateHeaders.h
//  TealiumUtilities
//
//  Created by George Webster on 2/17/15.
//
//

//  Interface for Testing and possibly subclasssing only!

@interface TEALDataQueue (PrivateHeaders)

@property (strong, nonatomic) NSMutableArray *dataQueue;

@property (nonatomic) NSUInteger capacity;

@end