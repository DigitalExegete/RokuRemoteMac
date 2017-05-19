//
//  RokuDeviceModel.m
//  RokuRemote
//
//  Created by William Jones on 5/13/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuDeviceModel.h"
#import "RokuRemoteNetworkInterface.h"
#import "RokuChannelModel.h"

@interface RokuDeviceModel()

@property (strong) RokuRemoteNetworkInterface *deviceNetworkInterface;
@property (readwrite, copy) NSString *ipAddress;
@property (readwrite, copy) NSString *deviceName;
@property (readwrite, copy) NSString *modelNumber;
@property (readwrite, strong) NSImage *deviceImage;

@end

@implementation RokuDeviceModel

- (instancetype)initWithIPAddress:(NSString *)ipaddress
{
	
	self = [super init];
	if (self)
	{
		_ipAddress = ipaddress;
		_deviceNetworkInterface = [[RokuRemoteNetworkInterface alloc] initWithIPAddress:ipaddress];
		_deviceChannels = [@[] mutableCopy];
		
	}
	return self;
	
}



- (void)configureDevice
{
	
	[self.deviceNetworkInterface configureSession];
	[[self deviceNetworkInterface] setRemoteDelegate:self];
	[[self deviceNetworkInterface] sendRokuRequest:RokuRemoteRequestChannelListing channelID:-1];
	[[self deviceNetworkInterface] sendRokuRequest:RokuRemoteRequestDeviceInfo channelID:-1];
	
}

- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action
{
	return 0;
}

- (void)sendRokuKeypressCommand:(RokuRemoteControlActions)action
{
	[[self deviceNetworkInterface] sendRokuKeypressCommand:action];
}

- (void)sendRokuRequest:(RokuRemoteRequest)request channelID:(NSInteger)channelID
{
	[[self deviceNetworkInterface] sendRokuRequest:request channelID:channelID];
}

//MARK: - RokuRemoteNetworkInterfaceDelegate Methods -

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forChannel:(NSUInteger)rokuChannelID
{
	
	NSUInteger rokuChannelIndex = [[self deviceChannels] indexOfObjectPassingTest:^BOOL(RokuChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if (obj.channelID == rokuChannelID)
		{
			*stop = YES;
			return YES;
		}
		
		return NO;
	}];
	
	RokuChannelModel *model = [[self deviceChannels] objectAtIndex:rokuChannelIndex];
	
	NSImage *channelIcon = [[NSImage alloc] initWithData:data];
	
	model.channelImage = channelIcon;
	
}




- (void)processRokuChannels:(NSXMLElement *)channelsElement
{
	[[self deviceChannels] removeAllObjects];
	
	[[channelsElement children] enumerateObjectsUsingBlock:^(NSXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSXMLElement *element = (NSXMLElement *)obj;
		
		if ([[element attributeForName:@"type"].stringValue isEqualToString:@"appl"])
		{
			RokuChannelModel *channelModel = [[RokuChannelModel alloc] initWithChannelName:element.stringValue channelID:[[element attributeForName:@"id"].stringValue integerValue]];
			
			[[self deviceChannels] addObject:channelModel];
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				
				[self.deviceNetworkInterface sendRokuRequest:RokuRemoteRequestChannelIcon channelID:channelModel.channelID];
				[[self deviceNetworkInterface] sendRokuRequest:RokuRemoteRequestActiveApp channelID:-1];
				
			}];
		}
		
	}];
	
	self.channelCount = self.deviceChannels.count;
	
}

- (NSImage *)deviceImageForRokuModel:(NSString *)model
{
	
	NSImage *retImage = nil;
	
	if ([model isEqualToString:@"4210X"])
	{
		retImage = [NSImage imageNamed:@"player_mustang_1"];
	}
	
	return retImage;
	
}


- (void)processRokuDeviceInfo:(NSXMLDocument *)deviceInfo
{
	
	NSXMLElement *rootElement = deviceInfo.rootElement;
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.modelNumber = [[[rootElement elementsForName:@"model-number"] firstObject] stringValue];
		self.deviceName = [[[rootElement elementsForName:@"model-name"] firstObject] stringValue];
		self.deviceImage = [self deviceImageForRokuModel:self.modelNumber];
	}];
	
}

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forRequest:(RokuRemoteRequest)remoteRequest
{
	
	if (!data)
	{
		return;
	}
	
	switch (remoteRequest)
	{
		case RokuRemoteRequestChannelListing:
		{
			if (data)
			{
				NSXMLDocument *channelListingDocument = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
				[self processRokuChannels:channelListingDocument.rootElement];
			}
		}
			break;
		case RokuRemoteRequestActiveApp:
		{
			
			NSXMLDocument *channelListingDocument = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
			NSString *channelName = [[channelListingDocument.rootElement elementsForName:@"app"] firstObject].stringValue;
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				
				NSUInteger channelIndex = [self.deviceChannels indexOfObjectWithOptions:NSEnumerationConcurrent passingTest:^BOOL(RokuChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					
					if ([obj.channelName isEqualToString:channelName])
					{
						*stop = YES;
						return YES;
					}
					
					return NO;
					
				}];
				
				if (channelIndex != NSNotFound)
				{
					RokuChannelModel *currentChannelModel = [self.deviceChannels objectAtIndex:channelIndex];
					
					self.currentChannel = currentChannelModel;
					
					[[self deviceNetworkInterface] sendRokuRequest:RokuRemoteRequestChannelIcon channelID:currentChannelModel.channelID];
				}
				
			}];
			
		}
			break;
		case RokuRemoteRequestDeviceInfo:
		{
			NSXMLDocument *deviceInfo = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
			[self processRokuDeviceInfo:deviceInfo];
		}
			break;
		default:
			break;
			
	}
	
}


@end
