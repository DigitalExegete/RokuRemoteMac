//
//  RokuDeviceModel.h
//  RokuRemote
//
//  Created by William Jones on 5/13/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RokuRemoteNetworkInterface.h"

@class RokuChannelModel;

/**
 @header RokuDeviceModel
 @brief This class represents a physical Roku device.  All Requests should be sent through this device, rather than trying to roll your own connections and communicate in some kludgy fashion. Oh wait, that's what I was doing until I made this class. <g>
 */
@interface RokuDeviceModel : NSObject<RokuRemoteNetworkInterfaceDelegate>

@property (strong) NSMutableArray<RokuChannelModel *> *deviceChannels;
@property (assign) RokuChannelModel *currentChannel;
@property (assign) NSUInteger channelCount;
@property (readonly, copy) NSString *ipAddress;
@property (readonly, copy) NSString *deviceName;
@property (readonly, copy) NSString *modelNumber;

- (instancetype)initWithIPAddress:(NSString *)ipaddress;
- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action;
- (void)sendRokuKeypressCommand:(RokuRemoteControlActions)action;
- (void)sendRokuRequest:(RokuRemoteRequest)request channelID:(NSInteger)channelID;
- (void)configureDevice;

@end
