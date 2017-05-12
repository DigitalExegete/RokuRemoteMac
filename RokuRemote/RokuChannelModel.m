//
//  RokuChannelModel.m
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuChannelModel.h"
#import "RokuRemoteNetworkInterface.h"

@implementation RokuChannelModel

- (instancetype)initWithChannelName:(NSString *)channelName channelID:(NSInteger)channelID
{
	
	self = [super init];
	if (self)
	{
		_channelName = channelName;
		_channelID = channelID;
	}
	return self;
	
}

@end
