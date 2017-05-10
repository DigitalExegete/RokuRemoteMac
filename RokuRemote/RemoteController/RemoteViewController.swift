//
//  RemoteViewController.swift
//  RokuRemote
//
//  Created by William Jones on 4/23/17.
//  Copyright © 2017 Treblotto Music & Music Technology. All rights reserved.
//

import Cocoa

@objc class RemoteViewController: NSViewController, URLSessionDelegate {
	
	var remoteInterface: RemoteNetworkInterface?
	
	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
	}
	
	override func awakeFromNib() {

	}
	
	@IBAction func remoteButtonClicked(sender: Any?) {
		
		
		
	}
	
}
