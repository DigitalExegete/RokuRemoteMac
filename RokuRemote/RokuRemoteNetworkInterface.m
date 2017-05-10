//
//  RokuRemoteNetworkInterface.m
//  RokuRemote
//
//  Created by William Jones on 4/24/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuRemoteNetworkInterface.h"
#include <curl/curl.h>

@interface RokuRemoteNetworkInterface()

@property (assign) CURL *urlHandle;
@property (strong) NSMutableData *transferData;
@property (strong) NSXMLDocument *postResults;
@property (strong) NSURLSession *rokuURLSession;
@property (strong) NSOperationQueue *urlSessionQueue;


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

	NSURL *rokuURL = [NSURL URLWithString:@"http://192.168.1.52:8060"];
	
	rokuURL = [rokuURL URLByAppendingPathComponent:@"query/active-app"];
	

	

	
//	NSString *baseUrl = @"http://192.168.1.52:8060/";
//	
//	NSString *retString = [baseUrl stringByAppendingString:@"query/active-app"];
//
//	return retString;
//
	return rokuURL;
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
