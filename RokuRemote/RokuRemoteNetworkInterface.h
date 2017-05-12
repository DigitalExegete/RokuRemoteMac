//
//  RokuRemoteNetworkInterface.h
//  RokuRemote
//
//  Created by William Jones on 4/24/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RokuRemoteControlActions) {
	
	RokuRemoteLeft,
	RokuRemoteRight,
	RokuRemoteUp,
	RokuRemoteDown,
	RokuRemotePlay,
	RokuRemoteAsterisk,
	RokuRemoteBack,
	RokuRemoteHome,
	RokuRemoteQuickback,
	RokuRemoteEnter,
	RokuRemoteOkay
	
};

typedef NS_ENUM(NSInteger, RokuRemoteRequest)
{
	RokuRemoteRequestActiveApp,
	RokuRemoteRequestChannelListing,
	RokuRemoteRequestChannelIcon
};

@class RokuRemoteNetworkInterface;

@protocol RokuRemoteNetworkInterfaceDelegate<NSObject>

@optional
- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forRequest:(RokuRemoteRequest)remoteRequest;

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forChannel:(NSUInteger)rokuChannelID;

@end

@interface RokuRemoteNetworkInterface : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, RokuRemoteNetworkInterfaceDelegate>

@property (weak) id<RokuRemoteNetworkInterfaceDelegate> remoteDelegate;

- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action;
- (void)sendRokuKeypressCommand:(RokuRemoteControlActions)action;
- (void)sendRokuRequest:(RokuRemoteRequest)request channelID:(NSInteger)channelID;
- (void)configureSession;

@end

