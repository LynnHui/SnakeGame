//
//  MenusView.swift
//  SnakeGame
//
//  Created by lynn.hui on 15/6/2.
//  Copyright (c) 2015年 lynn.hui. All rights reserved.
//

import UIKit

@objc protocol MenuDelegate{
    optional func callBackFromMenu(index: Int)
}
class MenusView: UIView ,UITableViewDataSource,UITableViewDelegate{
    var menuTable:UITableView!
    var delegate: MenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        menuTable = UITableView(frame:self.frame, style: UITableViewStyle.Plain)
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.addSubview(menuTable)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        switch indexPath.row{
        case 0:cell!.textLabel?.text = "重玩"
        default: cell!.textLabel?.text = "历史"
        }
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.callBackFromMenu!(indexPath.row)
        self.removeFromSuperview()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func translatesAutoresizingMaskIntoConstraints() -> Bool {
        return false
    }
}
