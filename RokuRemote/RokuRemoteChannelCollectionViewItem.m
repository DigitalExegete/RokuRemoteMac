//
//  RokuRemoteChannelCollectionViewItem.m
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuRemoteChannelCollectionViewItem.h"
#import "RokuChannelModel.h"

@interface RokuRemoteChannelCollectionViewItem ()
@property (strong) CALayer *highlightLayer;
@end

@implementation RokuRemoteChannelCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	CALayer *backgroundLayer = [CALayer new];
	self.highlightLayer = backgroundLayer;
	[[self.view layer] addSublayer:backgroundLayer];
	[self.highlightLayer setFrame:self.view.bounds];
	self.highlightLayer.backgroundColor = [[NSColor alternateSelectedControlColor] colorWithAlphaComponent:0.25].CGColor;
	self.highlightLayer.hidden = YES;
	
}

- (void)viewDidAppear
{
	[self.highlightLayer setFrame:self.view.bounds];
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	self.highlightLayer.hidden = !selected;
	
}

- (RokuChannelModel *)representedObject
{
	return (RokuChannelModel *)[super representedObject];
}

- (void)setRepresentedObject:(RokuChannelModel *)representedObject
{
	if (representedObject)
	{
			
	}
	[super setRepresentedObject:representedObject];
}

@end
