//
//  RokuRemoteChannelViewController.h
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RokuRemoteNetworkInterface.h"

@interface RokuRemoteChannelViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, RokuRemoteNetworkInterfaceDelegate, NSCollectionViewDataSource, NSCollectionViewDataSource>

@end
