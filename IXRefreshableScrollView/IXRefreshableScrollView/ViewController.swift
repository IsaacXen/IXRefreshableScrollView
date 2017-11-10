//
//  ViewController.swift
//  IXRefreshableScrollView
//
//  Created by Isaac Chen on 10/11/2017.
//  Copyright © 2017 IXAN. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var scrollView: IXScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleStop(_ sender: NSButton) {
        if scrollView.isRefreshing { scrollView.stopRefreshing() }
        if scrollView.isLoading { scrollView.stopLoading() }
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 50
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: .tableCellId, owner: self) as! NSTableCellView
        
        cell.textField?.stringValue = "testing testing 123"
        
        return cell
    }
}

extension NSUserInterfaceItemIdentifier {
    static var tableCellId = NSUserInterfaceItemIdentifier("cellId")
}
