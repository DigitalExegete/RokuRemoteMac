//
//  RokuTableCellView.m
//  RokuRemote
//
//  Created by William Jones on 5/14/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuTableCellView.h"

#import "RokuDeviceModel.h"

@implementation RokuTableCellView

@dynamic objectValue;

- (RokuDeviceModel *)objectValue
{
	return (RokuDeviceModel *)[super objectValue];
}


@end
