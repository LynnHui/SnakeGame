//
//  RecordList.swift
//  SnakeGame
//
//  Created by lynn.hui on 15/6/2.
//  Copyright (c) 2015年 lynn.hui. All rights reserved.
//

import UIKit

class RecordList: UIView ,UITableViewDataSource,UITableViewDelegate {
    var recordTable:UITableView!
    var list = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        recordTable = UITableView(frame:self.frame, style: UITableViewStyle.Grouped)
        recordTable.delegate = self
        recordTable.dataSource = self
        self.addSubview(recordTable)
    }
    
    func setRecordAction(records:Array<String>){
        list += (records)
        recordTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, 1, 1))
        return header;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        var msg = "\(list[list.count - 1 - indexPath.row])"
        cell!.textLabel?.textAlignment = NSTextAlignment.Center
        cell!.textLabel?.font = UIFont.systemFontOfSize(12.0)
        cell!.textLabel?.numberOfLines = 2
        cell!.textLabel?.text = msg
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, 1, 1))
        return header;
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func translatesAutoresizingMaskIntoConstraints() -> Bool {
        return false
    }
}
