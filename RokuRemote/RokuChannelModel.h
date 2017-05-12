//
//  RokuChannelModel.h
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RokuChannelModel : NSObject

@property (strong) NSImage *channelImage;
@property (assign) NSInteger channelID;
@property (copy) NSString *channelName;

- (instancetype)initWithChannelName:(NSString *)channelName channelID:(NSInteger)channelID;

@end
