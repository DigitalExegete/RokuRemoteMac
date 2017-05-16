//
//  RokuRemoteNetworkInterface.m
//  RokuRemote
//
//  Created by William Jones on 4/24/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "RokuRemoteNetworkInterface.h"
#import "RokuRemote-Swift.h"
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>
#include <curl/curl.h>

typedef BOOL (^BlockType)(NSDocument *, NSWindow *);

@interface RokuRemoteNetworkInterface()

@property (assign) CURL *urlHandle;
@property (strong) NSMutableData *transferData;
@property (strong) NSXMLDocument *postResults;
@property (strong) NSURLSession *rokuURLSession;
@property (strong) NSOperationQueue *urlSessionQueue;
@property (copy, readwrite) NSString *ipaddress;


@end

@implementation RokuRemoteNetworkInterface

-(instancetype)init
{
	self = [super init];
	
	if (self)
	{
	
		_transferData = [NSMutableData dataWithLength:16384];
	}
	return self;
	
}

- (instancetype)initWithIPAddress:(NSString *)ipaddr
{
	
	self = [super init];
	if (self)
	{
		_ipaddress = ipaddr;
	}
	return self;
	
}

- (void)configureSession
{
	
	self.urlSessionQueue = [[NSOperationQueue alloc] init];
	[self.urlSessionQueue setName:@"com.tmmt.rokuRemoteQueue"];
	[self.urlSessionQueue setMaxConcurrentOperationCount:1];
	
	NSURLSessionConfiguration *rokuRemoteSessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	
	self.rokuURLSession = [NSURLSession sessionWithConfiguration:rokuRemoteSessionConfig delegate:self delegateQueue:self.urlSessionQueue];
	
	
	
}

- (NSURL *)generateURLForCommand:(RokuRemoteControlActions)action
{

	NSString *pathComponent = nil;
	
	switch (action)
	{
		case RokuRemoteOkay:
			pathComponent = @"keypress/select";
			break;
		case RokuRemoteLeft:
			pathComponent = @"keypress/left";
			break;
		case RokuRemoteRight:
			pathComponent = @"keypress/right";
			break;
		case RokuRemoteUp:
			pathComponent = @"keypress/up";
			break;
		case RokuRemoteDown:
			pathComponent = @"keypress/down";
			break;
		case RokuRemoteBack:
			pathComponent = @"keypress/back";
			break;
		case RokuRemoteHome:
			pathComponent = @"keypress/home";
			break;
		case RokuRemotePlay:
			pathComponent = @"keypress/play";
			break;
		case RokuRemoteRev:
			pathComponent = @"keypress/rev";
			break;
		case RokuRemoteFwd:
			pathComponent = @"keypress/fwd";
			break;
		case RokuRemoteAsterisk:
			pathComponent = @"keypress/info";
			break;
		case RokuRemoteQuickback:
			pathComponent = @"keypress/instantreplay";
			break;
		default:
			break;
			
	}

	NSURL *rokuURL = [NSURL URLWithString:self.ipaddress];
	
	rokuURL = [rokuURL URLByAppendingPathComponent:pathComponent];
	
	return rokuURL;
}

- (NSURL *)generateURLForRequest:(RokuRemoteRequest)action channelID:(NSInteger)channelID
{
	
	NSString *pathComponent = nil;
	
	switch (action)
	{
		case RokuRemoteRequestActiveApp:
			pathComponent = @"query/active-app";
			break;
		case RokuRemoteRequestChannelIcon:
			pathComponent = [NSString stringWithFormat:@"query/icon/%ld",channelID];
			break;
		case RokuRemoteRequestChannelListing:
			pathComponent = @"query/apps";
			break;
		case RokuRemoteRequestDeviceInfo:
			pathComponent = @"query/device-info";
			break;
		default:
			break;
			
	}
	
	NSURL *rokuURL = [NSURL URLWithString:self.ipaddress];
	
	rokuURL = [rokuURL URLByAppendingPathComponent:pathComponent];
	
	return rokuURL;
}


- (void)sendRokuKeypressCommand:(RokuRemoteControlActions)action
{
	
	NSMutableURLRequest *rokuDataRemoteRequest = [[NSURLRequest requestWithURL:[self generateURLForCommand:action]] mutableCopy];
	[rokuDataRemoteRequest setHTTPMethod:@"POST"];
	
	NSURLSessionDataTask *task = [self.rokuURLSession dataTaskWithRequest:rokuDataRemoteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		
		
	}];
	
	[task resume];

	
}

- (void)sendRokuRequest:(RokuRemoteRequest)request channelID:(NSInteger)channelID
{
	
	NSURLRequest *rokuDataRemoteRequest = [NSURLRequest requestWithURL:[self generateURLForRequest:request channelID:channelID]];
	
	NSURLSessionDataTask *task = [self.rokuURLSession dataTaskWithRequest:rokuDataRemoteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (request == RokuRemoteRequestChannelIcon)
		{
			if (self.remoteDelegate)
			{
				if ([self.remoteDelegate respondsToSelector:@selector(networkInterface:receivedData:forChannel:)])
				{
					[[self remoteDelegate] networkInterface:self receivedData:data forChannel:channelID];
				}
			}
		}
		else
		{
			if (self.remoteDelegate)
			{
				if ([self.remoteDelegate respondsToSelector:@selector(networkInterface:receivedData:forRequest:)])
				{
					[[self remoteDelegate] networkInterface:self receivedData:data forRequest:request];
				}
			}
		}
		
		
		
//		NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
//		NSLog(@"Data is: %@", document);
		
	}];
	
	[task resume];

	
}

- (NSInteger)sendRokuCommand:(RokuRemoteControlActions)action
{
	
	NSURLRequest *rokuDataRemoteRequest = [NSURLRequest requestWithURL:[self generateURLForCommand:action]];
	
	NSURLSessionDataTask *task = [self.rokuURLSession dataTaskWithRequest:rokuDataRemoteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		

		NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
		NSLog(@"Data is: %@", document);
		
	}];

	[task resume];
	
	return 0;
	
}

size_t rokuRemoteCURLWriteCallback(char *ptr, size_t size, size_t nmemb, void *userdata)
{

	size_t realsize = size * nmemb;
	NSData *curlData = [[NSData alloc] initWithBytes:ptr length:realsize];

	RokuRemoteNetworkInterface *rrni = (__bridge RokuRemoteNetworkInterface *)userdata;
	
	NSXMLDocument *returnDocument = [[NSXMLDocument alloc] initWithData:curlData options:0 error:nil];
	
	rrni.postResults = returnDocument;
	
	return size*nmemb;
	
}

void rokuRemoteCURLCallback( char *buffer, size_t size, size_t nitems, void *instream )
{
	
}

@end
