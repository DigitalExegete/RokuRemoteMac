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

@interface RokuRemoteChannelViewController ()
@property (strong) RokuRemoteNetworkInterface *channelNetworkInterface;
//@property (strong) NSOperationQueue *channelOperationQueue;
@property (weak) IBOutlet NSTableView *channelTableView;
@property (weak) IBOutlet NSCollectionView *channelCollectionView;
@property (assign) NSInteger numberOfChannels;
@property (strong) NSXMLElement *channelsElement;
@property (assign) BOOL showingCollectionView;
@property (strong) NSMutableArray<RokuChannelModel *> *rokuChannels;
@end

@implementation RokuRemoteChannelViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		_channelNetworkInterface = [RokuRemoteNetworkInterface new];
		[_channelNetworkInterface configureSession];
		[_channelNetworkInterface setRemoteDelegate:self];
		_rokuChannels = [@[] mutableCopy];
		
	}
	return self;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.channelNetworkInterface sendRokuRequest:RokuRemoteRequestChannelListing channelID:-1];
    // Do view setup here.
	
	[[self channelCollectionView] registerClass:[RokuRemoteChannelCollectionViewItem class] forItemWithIdentifier:@"com.tmmt.rokuRemote.channelView"];
	
}

//MARK: - NSTableViewDataSource Methods -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	
	return self.numberOfChannels;
	
}


- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSString *retValue = nil;
	
	if ([tableColumn.identifier isEqualToString:@"rokuChannelName"])
	{
		retValue = [[[self.channelsElement children] objectAtIndex:row] stringValue];
	}
	else
	{
		retValue = [[(NSXMLElement *)[[self.channelsElement children] objectAtIndex:row] attributeForName:@"id"] stringValue];
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

	[collectionViewItem setRepresentedObject:[[self rokuChannels] objectAtIndex:[indexPath indexAtPosition:indexPath.length-1]]];
	
	return collectionViewItem;
	
}

//MARK: - RokuRemoteNetworkInterfaceDelegate Methods -

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forChannel:(NSUInteger)rokuChannelID
{

	NSUInteger rokuChannelIndex = [[self rokuChannels] indexOfObjectPassingTest:^BOOL(RokuChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if (obj.channelID == rokuChannelID)
		{
			*stop = YES;
			return YES;
		}
		
		return NO;
	}];
	
	RokuChannelModel *model = [[self rokuChannels] objectAtIndex:rokuChannelIndex];
	
	NSImage *channelIcon = [[NSImage alloc] initWithData:data];
	
	model.channelImage = channelIcon;
	
//	NSLog(@"Data is: %@", data);
	
	
}

- (void)processRokuChannels:(NSXMLElement *)channelsElement
{

	[[self rokuChannels] removeAllObjects];
	
	[[[self channelsElement] children] enumerateObjectsUsingBlock:^(NSXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSXMLElement *element = (NSXMLElement *)obj;
		
		RokuChannelModel *channelModel = [[RokuChannelModel alloc] initWithChannelName:element.stringValue channelID:[[element attributeForName:@"id"].stringValue integerValue]];
		
		[[self rokuChannels] addObject:channelModel];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		
			[self.channelNetworkInterface sendRokuRequest:RokuRemoteRequestChannelIcon channelID:channelModel.channelID];
			
		}];
		
	}];
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.channelTableView reloadData];
		[self.channelCollectionView reloadData];
	}];

	
	
}

- (void)networkInterface:(RokuRemoteNetworkInterface *)networkInterface receivedData:(NSData *)data forRequest:(RokuRemoteRequest)remoteRequest
{
	
	switch (remoteRequest)
	{
		case RokuRemoteRequestChannelListing:
		{
			NSXMLDocument *channelListingDocument = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
			NSArray<NSXMLNode *> *channels = [[channelListingDocument rootElement] children];
			NSLog(@"Channels: %@", channels);
			self.numberOfChannels = channels.count;
			self.channelsElement = channelListingDocument.rootElement;
			
			[self processRokuChannels:self.channelsElement];
			
			
		}
			break;
		default:
			break;
			
	}
	
}


@end
