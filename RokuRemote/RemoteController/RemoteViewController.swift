//
//  RemoteViewController.swift
//  RokuRemote
//
//  Created by William Jones on 4/23/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

import Cocoa

@objc class RemoteViewController: NSViewController, URLSessionDelegate, NSTableViewDelegate, NSTableViewDataSource {
	
	var remoteInterface: RokuRemoteNetworkInterface = RokuRemoteNetworkInterface()
	
	required init?(coder: NSCoder) {
		
		remoteInterface.configureSession()
		super.init(coder: coder)
	}
	
	override func awakeFromNib() {

	}
	
	@IBAction func remoteButtonClicked(sender: Any?) {
		
		
		
	}
	
	override func mouseDown(with event: NSEvent) {
		
		var clickPoint = event.locationInWindow
		clickPoint = self.view.convert(clickPoint, from: nil)
		
		let clickedLayer = self.view.layer?.hitTest(clickPoint)
		
		if let controlAction = clickedLayer?.value(forKey: "rokuAction") as! NSNumber?
		{
		
			let realAction: RokuRemoteControlActions = RokuRemoteControlActions.init(rawValue: (controlAction.uintValue))!
			remoteInterface.sendRokuKeypressCommand(realAction)
			
		}
		
	}
	
}
