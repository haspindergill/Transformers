

//
//  TableDataSource.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation
import UIKit


typealias  ListCellConfigureBlock = (_ cell : AnyObject , _ item : AnyObject? , _ indexPath : IndexPath?) -> ()
typealias  DidSelectedRow = (_ indexPath : IndexPath) -> ()
typealias  DidDeleteRow = (_ indexPath : IndexPath) -> ()


class TableDataSource: NSObject {
    
    
    var items : Array<AnyObject>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 44.0
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var aRowDeletedListener : DidDeleteRow?

    init (items : Array<AnyObject>? , height : CGFloat , tableView : UITableView? , cellIdentifier : String?  , configureCellBlock : ListCellConfigureBlock? , aRowSelectedListener : @escaping DidSelectedRow, aRowDeletedListener : @escaping DidDeleteRow) {
        
        self.tableView = tableView
        
        self.items = items
        
        self.cellIdentifier = cellIdentifier
        
        self.tableViewRowHeight = height
        
        self.configureCellBlock = configureCellBlock
        
        self.aRowSelectedListener = aRowSelectedListener
        
        self.aRowDeletedListener = aRowDeletedListener
                
    }
    
    
    override init() {
        super.init()
    }
    
}



extension TableDataSource : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        if let block = self.configureCellBlock , let item: AnyObject = self.items?[indexPath.row]{
            block(cell , item ,indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let block = self.aRowSelectedListener{
            block(indexPath)
        }
        self.tableView?.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let block = self.aRowDeletedListener{
                block(indexPath)
            }
        }
    }
    
}


