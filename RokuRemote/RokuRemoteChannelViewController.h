//
//  RokuRemoteChannelViewController.h
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RokuRemoteNetworkInterface.h"

@class RokuDeviceModel;

@interface RokuRemoteChannelViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSCollectionViewDataSource, NSCollectionViewDataSource>

@property (copy) NSString *activeApp;
@property (strong) NSImage *activeAppImage;
@property (assign) NSUInteger activeAppID;
@property (weak) RokuDeviceModel *currentDevice;

@end
