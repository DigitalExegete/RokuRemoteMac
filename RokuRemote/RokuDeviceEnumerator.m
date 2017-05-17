//
//  RokuDeviceEnumerator.m
//  RokuRemote
//
//  Created by William Jones on 5/13/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuDeviceEnumerator.h"
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>
#import "RokuDeviceModel.h"

NSString * const ssdpDiscoveryPacket = @"M-SEARCH * HTTP/1.1\r\nHost: 239.255.255.250:1900\r\nMan: \"ssdp:discover\"\r\nST: roku:ecp\r\n\r\n";

@interface RokuDeviceEnumerator()



@property (strong) GCDAsyncUdpSocket *enumeratorSocket;
@property (strong) dispatch_queue_t discoveryQueue;

@end

@implementation RokuDeviceEnumerator


- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_rokuDevices = [@[] mutableCopy];
	}
	return self;
	
}

+ (RokuDeviceEnumerator *)sharedEnumerator
{
	static RokuDeviceEnumerator *sharedDeviceEnumerator = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		sharedDeviceEnumerator = [[RokuDeviceEnumerator alloc] init];
		
		if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"detectedRokuDevices"] == nil)
		{
			[[NSUserDefaults standardUserDefaults] setValue:@[] forKey:@"detectedRokuDevices"];
		}
		
		
		
		[[[NSUserDefaults standardUserDefaults] arrayForKey:@"detectedRokuDevices"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			[sharedDeviceEnumerator parseRokuNotificationData:obj];
			
		}];
		
		
		
	});
	
	return sharedDeviceEnumerator;
	
}

- (void)enumerateRokuDevices
{
	NSError *socketError = nil;

	self.discoveryQueue = dispatch_queue_create("Roku Enumeration Queue", DISPATCH_QUEUE_SERIAL);
	self.enumeratorSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:self.discoveryQueue socketQueue:self.discoveryQueue];

	
	if (![ self.enumeratorSocket bindToPort:1900 error:&socketError]) {
		NSLog(@"Failed binding socket: %@", [socketError localizedDescription]);
		return ;
	}

	[self.enumeratorSocket joinMulticastGroup:@"239.255.255.250" error:nil];

	if (![self.enumeratorSocket beginReceiving:&socketError])
	{
		NSLog(@"Failed to start receiving: %@", [socketError localizedDescription]);
	}

	[NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
		
		[self.enumeratorSocket sendData:[ssdpDiscoveryPacket dataUsingEncoding:NSUTF8StringEncoding]
								 toHost: @"239.255.255.250" port: 1900 withTimeout:-1 tag:1];
		
	}];
	

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	
	NSLog(@"Error is: %@", error.localizedDescription);
	
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
}

- (void)parseRokuNotificationData:(NSString *)rokuResponse
{
	
	NSString *realAddress = rokuResponse;

	//Check to see if we need to filter the string.
	if ([rokuResponse containsString:@"LOCATION"])
	{
		NSRange locationOfLocation = [rokuResponse rangeOfString:@"LOCATION: "  options:NSCaseInsensitiveSearch];
		NSRange locationOfEnd = [rokuResponse rangeOfString:@"8060/"];
		
		NSString *address = [rokuResponse substringWithRange:NSMakeRange(locationOfLocation.location+locationOfLocation.length, locationOfEnd.location-(locationOfLocation.location+locationOfLocation.length)+4)];
		NSArray<NSString *> *componenets = [address componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		realAddress = componenets.firstObject;
	}
	
	NSMutableArray<NSString *> *ipArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"detectedRokuDevices"];
	
	if (![ipArray containsObject:realAddress])
	{
		[ipArray addObject:realAddress];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSUserDefaults standardUserDefaults] setValue:ipArray forKey:@"detectedRokuDevices"];
		}];

	}
	
	__block BOOL addDevice = YES;
	
	[self.rokuDevices enumerateObjectsUsingBlock:^(RokuDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if ([obj.ipAddress isEqualToString:realAddress])
		{
			addDevice = NO;
			*stop = YES;
		}
		
	}];
	
	if (addDevice)
	{
		RokuDeviceModel *newModel = [[RokuDeviceModel alloc] initWithIPAddress:realAddress];
		
		[newModel configureDevice];
		
		[[self mutableArrayValueForKey:@"rokuDevices"] addObject:newModel];
	}
	
	
	
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
	  fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext
{

	if ([sock.localAddress isEqualToData:address])
	{
		return;
	}
	
	NSString *searchData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (![searchData containsString:@"HTTP/1.1 200"])
	{
		return;
	}
	else
	{
		[self parseRokuNotificationData:searchData];
	}
	
	NSLog(@"Address: %@", address);
	NSLog(@"Data receieved: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
//	[self.enumeratorSocket receiveOnce:nil];
	
}


@end
