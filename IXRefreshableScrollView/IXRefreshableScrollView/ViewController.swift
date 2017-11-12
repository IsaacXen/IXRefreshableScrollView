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
    @IBOutlet weak var tableView: NSTableView!
    
    var tableDatas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.target = self
        scrollView.refreshAction = #selector(refresh)
        
        for _ in 0..<50 {
           tableDatas.append("testing testing 123")
        }
        
        tableView.reloadData()
    }

    @IBAction func handleRefresh(_ sender: NSButton) {
        scrollView.beginRefreshing()
    }
    
    @IBAction func handleLoad(_ sender: NSButton) {
        
    }
    
    
    @IBAction func handleStop(_ sender: NSButton) {
        if scrollView.isRefreshing { scrollView.stopRefreshing() }
        if scrollView.isLoading { scrollView.stopLoading() }
    }
    
    @objc func refresh() {
        for _ in 0..<5 {
            tableDatas.insert("new added string", at: 0)
        }
        
        DispatchQueue.global().async {
            sleep(2)
         
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollView.stopRefreshing()
            }
        }
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableDatas.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: .tableCellId, owner: self) as! NSTableCellView
        
        cell.textField?.stringValue = tableDatas[row]
        
        return cell
    }
}

extension NSUserInterfaceItemIdentifier {
    static var tableCellId = NSUserInterfaceItemIdentifier("cellId")
}
