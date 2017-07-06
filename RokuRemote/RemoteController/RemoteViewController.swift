//
//  RemoteViewController.swift
//  RokuRemote
//
//  Created by William Jones on 4/23/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

import Cocoa

@objc class RemoteViewController: NSViewController, URLSessionDelegate, NSTableViewDelegate, NSTableViewDataSource, NSPopoverDelegate, RokuRemoteNetworkInterfaceDelegate {
	
	let collapsedViewWidth: CGFloat = 289
	let expandedViewWidth: CGFloat = 530
	var deviceModel: RokuDeviceModel?
	@IBOutlet var channelButton: NSButton?
	@IBOutlet var channelPopover: NSPopover?
	@IBOutlet var currentChannelImageView: NSImageView?
	@IBOutlet var deviceTableView: NSTableView?
	@IBOutlet var rokuRemoteViewWidth: NSLayoutConstraint?
	var currentChannelImage: NSImage?
	var moreButtonImage: NSImage?
	@IBOutlet var expandButton: NSButton?
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func awakeFromNib() {

	}
	
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.expandButton?.image = UserDefaults.standard.bool(forKey: "remoteExpanded") ? NSImage(named: NSImageNameGoRightTemplate) : NSImage(named: NSImageNameGoRightTemplate)
		
		rokuRemoteViewWidth?.animator().constant = UserDefaults.standard.bool(forKey: "remoteExpanded") ? self.expandedViewWidth : self.collapsedViewWidth

		self.expandButton?.animator().frameCenterRotation = UserDefaults.standard.bool(forKey: "remoteExpanded") ? 180 : 0

		
		NotificationCenter.default.addObserver(forName: Notification.Name.NSTableViewSelectionDidChange, object: self.deviceTableView, queue: nil) { (note: Notification) in
			
			if let deviceTableCellView: RokuTableCellView = self.deviceTableView?.view(atColumn: 0, row: (self.deviceTableView?.selectedRow)!, makeIfNecessary: false) as? RokuTableCellView {
			
				self.deviceModel = deviceTableCellView.objectValue
			
			}
			
			
		}

        if (self.deviceTableView?.numberOfRows as Int!) > 0 && self.deviceTableView?.selectedRow != -1 {



            if let deviceTableCellView: RokuTableCellView = self.deviceTableView?.view(atColumn: 0, row: (self.deviceTableView?.selectedRow)!, makeIfNecessary: false) as? RokuTableCellView {
                
                self.deviceModel = deviceTableCellView.objectValue
                
            }
        }


	}
	
	@IBAction func expandButtonClicked(sender: NSButton?) {
		
		rokuRemoteViewWidth?.animator().constant = (sender?.state==NSOnState) ? self.expandedViewWidth : self.collapsedViewWidth
		
		self.expandButton?.animator().image = (sender?.state==NSOnState) ? NSImage(named: NSImageNameGoRightTemplate) : NSImage(named: NSImageNameGoRightTemplate)
		
		self.expandButton?.animator().frameCenterRotation = (sender?.state==NSOnState) ? 180 : 0

	}
	
	@IBAction func remoteButtonClicked(sender: RokuPushButton?) {
		
		let realAction: RokuRemoteControlActions = RokuRemoteControlActions.init(rawValue: (sender?.buttonAction)!)!
		let currentDevice = self.deviceModel
		currentDevice?.sendRokuKeypressCommand(realAction)

	}
	
	@IBAction func remoteTransportClick(sender: NSSegmentedControl? ) {
		
		let segCell: NSSegmentedCell? = sender?.cell as! NSSegmentedCell?
		 //(forSegment:UInt((sender?.selectedSegment))
		
		let realAction: RokuRemoteControlActions = RokuRemoteControlActions.init(rawValue: UInt((segCell?.tag(forSegment: (sender?.selectedSegment)!))!))!

        if self.deviceModel == nil {
            if let deviceTableCellView: RokuTableCellView = self.deviceTableView?.view(atColumn: 0, row: (self.deviceTableView?.selectedRow)!, makeIfNecessary: false) as? RokuTableCellView {

                self.deviceModel = deviceTableCellView.objectValue

            }

        }

        let currentDevice = self.deviceModel
		currentDevice?.sendRokuKeypressCommand(realAction)

		
	}
	
	@IBAction func channelButtonClicked(sender: NSButton?) {
		
		self.channelPopover?.delegate = self
		self.channelPopover?.show(relativeTo: (self.channelButton?.bounds)!, of: sender!, preferredEdge: NSRectEdge.maxY)
		
	}
	
	override func mouseDown(with event: NSEvent) {
		
		var clickPoint = event.locationInWindow
		clickPoint = self.view.convert(clickPoint, from: nil)
		
		let clickedLayer = self.view.layer?.hitTest(clickPoint)
		
		if let controlAction = clickedLayer?.value(forKey: "rokuAction") as! NSNumber?
		{
		
			let realAction: RokuRemoteControlActions = RokuRemoteControlActions.init(rawValue: (controlAction.uintValue))!
			let currentDevice = self.deviceModel
			currentDevice?.sendRokuKeypressCommand(realAction)
			
		}
		
		
	}
	
	
	class override func exposedBindings() -> [String] {
		
		return ["deviceModel"]
	
	}
	
	func networkInterface(_ networkInterface: RokuRemoteNetworkInterface!, receivedData data: Data!, forChannel rokuChannelID: UInt) {
		
		CATransaction.begin()
		self.currentChannelImage = NSImage(data: data)
		self.currentChannelImageView?.image = self.currentChannelImage
		CATransaction.commit()
	}
	
}
