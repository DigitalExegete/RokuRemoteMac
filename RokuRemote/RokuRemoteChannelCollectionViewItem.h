//
//  RokuRemoteChannelCollectionViewItem.h
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RokuChannelModel.h"

//@class RokuChannelModel;

@interface RokuRemoteChannelCollectionViewItem : NSCollectionViewItem

- (RokuChannelModel *)representedObject;
- (void)setRepresentedObject:(RokuChannelModel *)representedObject;

@end
