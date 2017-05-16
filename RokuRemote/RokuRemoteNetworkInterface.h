//
//  RokuRemoteNetworkInterface.h
//  RokuRemote
//
//  Created by William Jones on 4/24/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RokuRemoteControlActions) {
	
	RokuRemoteLeft=0,
	RokuRemoteRight,
	RokuRemoteUp,
	RokuRemoteDown,
	RokuRemotePlay,
	RokuRemoteAsterisk,
	RokuRemoteBack,
	RokuRemoteHome,
	RokuRemoteQuickback,
	RokuRemoteEnter,
	RokuRemoteOkay,
	RokuRemoteRev,
	RokuRemoteFwd,
	
};

typedef NS_ENUM(NSInteger, RokuRemoteRequest)
{
	RokuRemoteRequestActiveApp,
	RokuRemoteRequestChannelListing,
	RokuRemoteRequestChannelIcon,
	RokuRemoteRequestDeviceInfo,
};

@class RokuRemoteNetworkInterface;

@protocol RokuRemoteNetworkInterfaceDelegate<NSObject>

@optional
- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forRequest:(RokuRemoteRequest)remoteRequest;

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forChannel:(NSUInteger)rokuChannelID;

@end

@interface RokuRemoteNetworkInterface : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, RokuRemoteNetworkInterfaceDelegate>

@property (weak) id<RokuRemoteNetworkInterfaceDelegate> remoteDelegate;
@property (copy, readonly) NSString *ipaddress;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithIPAddress:(NSString *)ipaddr NS_DESIGNATED_INITIALIZER;


- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action;
- (void)sendRokuKeypressCommand:(RokuRemoteControlActions)action;
- (void)sendRokuRequest:(RokuRemoteRequest)request channelID:(NSInteger)channelID;
- (void)configureSession;

@end

