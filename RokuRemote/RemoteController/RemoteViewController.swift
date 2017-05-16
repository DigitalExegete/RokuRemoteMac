//
//  RemoteViewController.swift
//  RokuRemote
//
//  Created by William Jones on 4/23/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

import Cocoa

@objc class RemoteViewController: NSViewController, URLSessionDelegate, NSTableViewDelegate, NSTableViewDataSource, NSPopoverDelegate, RokuRemoteNetworkInterfaceDelegate {
	
	var deviceModel: RokuDeviceModel?
	@IBOutlet var channelButton: NSButton?
	@IBOutlet var channelPopover: NSPopover?
	@IBOutlet var currentChannelImageView: NSImageView?
	@IBOutlet var deviceTableView: NSTableView?
	var currentChannelImage: NSImage?

	
	
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
		NotificationCenter.default.addObserver(forName: Notification.Name.NSTableViewSelectionDidChange, object: self.deviceTableView, queue: nil) { (note: Notification) in
			
			if let deviceTableCellView: RokuTableCellView = self.deviceTableView?.view(atColumn: 0, row: (self.deviceTableView?.selectedRow)!, makeIfNecessary: false) as? RokuTableCellView {
			
				self.deviceModel = deviceTableCellView.objectValue
			
			}
			
			
		}
	}
	
	@IBAction func remoteButtonClicked(sender: Any?) {
		
		
		
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
