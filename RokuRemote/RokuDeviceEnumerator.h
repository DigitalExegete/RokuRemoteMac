//
//  RokuDeviceEnumerator.h
//  RokuRemote
//
//  Created by William Jones on 5/13/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>

@class RokuDeviceModel;

@interface RokuDeviceEnumerator : NSObject<GCDAsyncUdpSocketDelegate>

+ (RokuDeviceEnumerator *)sharedEnumerator;

/**
 @brief devices that have been found by this application.  Use KVO, and don't poll. Access from main thread since mutable arrays are not thread-safe.
 */
@property (strong) NSMutableArray<RokuDeviceModel *> *rokuDevices;

- (void)enumerateRokuDevices;



@end
