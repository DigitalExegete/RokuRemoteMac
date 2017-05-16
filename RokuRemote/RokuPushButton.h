//
//  RokuPushButton.h
//  RokuRemote
//
//  Created by William Jones on 5/15/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RokuRemoteNetworkInterface.h"

@interface RokuPushButton : NSButton

@property (readwrite, assign) IBInspectable NSUInteger buttonAction; //RokuRemoteControlAction

@end
