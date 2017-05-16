//
//  RokuRemoteChannelViewController.m
//  RokuRemote
//
//  Created by William Jones on 5/11/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

#import "RokuRemoteChannelViewController.h"
#import "RokuRemoteNetworkInterface.h"
#import "RokuRemoteChannelCollectionViewItem.h"
#import "RokuRemote-Swift.h"
#import "RokuChannelModel.h"
#import "RokuDeviceModel.h"
#import "RokuDeviceEnumerator.h"
#import "RokuTableCellView.h"

@interface RokuRemoteChannelViewController ()

@property (strong) RokuRemoteNetworkInterface *channelNetworkInterface;
@property (weak) IBOutlet NSTableView *channelTableView; //deviceTableView!
@property (weak) IBOutlet NSCollectionView *channelCollectionView;
@property (assign) NSInteger numberOfChannels;
@property (strong) NSXMLElement *channelsElement;
@property (assign) BOOL showingCollectionView;
@property (weak) RokuDeviceEnumerator *deviceEnumerator;
@property (strong) IBOutlet NSArrayController *deviceArrayController;

@end

@implementation RokuRemoteChannelViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		
		_deviceEnumerator = [RokuDeviceEnumerator sharedEnumerator];
		
		

	}
	return self;
	
}

- (void)viewDidLoad {

	[super viewDidLoad];
	
	[[self channelCollectionView] registerClass:[RokuRemoteChannelCollectionViewItem class] forItemWithIdentifier:@"com.tmmt.rokuRemote.channelView"];
	
	[self.deviceEnumerator addObserver:self forKeyPath:@"rokuDevices" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	[self.deviceEnumerator enumerateRokuDevices];
	[[self deviceArrayController] setContent:self.deviceEnumerator.rokuDevices];
	
}


//MARK: - Key Value Observing -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	
	if ([keyPath isEqualToString:@"rokuDevices"])
	{
		if (change[NSKeyValueChangeOldKey])
		{
			[change[NSKeyValueChangeOldKey] removeObserver:self forKeyPath:@"channelCount"];
		}
		
		self.currentDevice = self.deviceEnumerator.rokuDevices.lastObject;
		
		[self.currentDevice addObserver:self forKeyPath:@"channelCount" options:NSKeyValueObservingOptionNew context:nil];
		
		self.numberOfChannels = self.currentDevice.deviceChannels.count;
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[self channelCollectionView] reloadData];
			[[self channelTableView] reloadData];
		}];


	}
	else if ([keyPath isEqualToString:@"channelCount"])
	{
		self.numberOfChannels = self.currentDevice.deviceChannels.count;
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self.channelCollectionView reloadData];
			[self.channelTableView reloadData];
		}];

	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
	
}


//MARK: - NSTableViewDataSource Methods -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{

	return self.deviceEnumerator.rokuDevices.count;
	
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
	
	RokuTableCellView *retView = [tableView makeViewWithIdentifier:@"rokuDeviceCell" owner:self];
	
	[retView setObjectValue:self.deviceEnumerator.rokuDevices[row]];
	
	return retView;
	
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	
	if (self.channelTableView.selectedRow!=-1)
	{
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			self.currentDevice = self.deviceEnumerator.rokuDevices[self.channelTableView.selectedRow];
			[self.currentDevice sendRokuRequest:RokuRemoteRequestActiveApp channelID:-1];			
		}];
	}
	
}

- (RokuDeviceModel *)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
	RokuDeviceModel *retValue = nil;
	
	if ([tableColumn.identifier isEqualToString:@"rokuDeviceCell"])
	{
		retValue = [self.deviceEnumerator.rokuDevices objectAtIndex:row];
	}
	else
	{
		retValue = nil;
	}
	
	return retValue;
}

//MARK: - NSCollectionViewDelegate/DataSource Methods -

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	
	return self.numberOfChannels;
	
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
	
	RokuRemoteChannelCollectionViewItem *collectionViewItem = [collectionView makeItemWithIdentifier:@"com.tmmt.rokuRemote.channelView" forIndexPath:indexPath];

	[collectionViewItem setRepresentedObject:[[self currentDevice].deviceChannels objectAtIndex:[indexPath indexAtPosition:indexPath.length-1]]];
	
	return collectionViewItem;
	
}



@end
