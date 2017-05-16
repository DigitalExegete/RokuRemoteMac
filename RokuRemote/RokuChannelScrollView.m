//
//  RokuChannelScrollView.m
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuChannelScrollView.h"

@implementation RokuChannelScrollView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (BOOL)allowsVibrancy
{
	return YES;
}
@end


@interface RokuClipView : NSClipView

@end

@implementation RokuClipView

- (BOOL)allowsVibrancy
{
	return YES;
}

@end
