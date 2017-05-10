//
//  AppDelegate.m
//  RokuRemote
//
//  Created by William Jones on 4/23/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "AppDelegate.h"
#import "RokuRemote-Swift.h"
#include <curl/curl.h>
#include "RokuRemoteNetworkInterface.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (strong) IBOutlet RemoteViewController *remoteViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	RokuRemoteNetworkInterface *rrni = [RokuRemoteNetworkInterface new];
	
	[rrni configureSession];
	
	[rrni sendRokuCommand:Play];
	
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
