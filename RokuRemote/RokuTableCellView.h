//
//  RokuTableCellView.h
//  RokuRemote
//
//  Created by William Jones on 5/14/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RokuDeviceModel;

@interface RokuTableCellView : NSTableCellView

@property (nullable, strong) RokuDeviceModel *objectValue;

//- (RokuDeviceModel *)objectValue;
//
//- (void)setObjectValue:(RokuDeviceModel *)objectValue;

@end
