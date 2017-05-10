//
//  RokuRemoteNetworkInterface.h
//  RokuRemote
//
//  Created by William Jones on 4/24/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RokuRemoteControlActions) {
	
	Left,
	Right,
	Up,
	Down,
	Play,
	Asterisk,
	Back,
	Home,
	Quickback,
	Enter
	
};

//enum RemoteControlActions {
//case Left
//case Right
//case Up
//case Down
//case Play
//case Asterisk
//case Back
//case Home
//case QuickBack
//}


@interface RokuRemoteNetworkInterface : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action;
- (void)configureSession;


@end
