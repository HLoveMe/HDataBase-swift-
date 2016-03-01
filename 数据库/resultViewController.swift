

//
//  resultViewController.swift
//  HDataBase(swift)
//
//  Created by space on 16/2/29.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit

class resultViewController: UITableViewController {
    var dataArray:[Student] = [Student]()
    override func viewDidLoad() {
        super.viewDidLoad()
        HDataBox.selectAllObjects(&self.dataArray)
        initRight()
    }
    func initRight(){
        let one = UIBarButtonItem.init(title: "removeAll", style:  UIBarButtonItemStyle.Plain, target: self, action: "removeAll")
        self.navigationItem.rightBarButtonItem = one
    }
    func removeAll(){
        self.dataArray.removeAll()
        HDataBox.deleteAllObjects(Student.self)
        self.tableView.reloadData()
    }
}
extension resultViewController{
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  self.dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let ID:String = "ID"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: ID)
        }
        let stu = self.dataArray[indexPath.row]
        let one = UILabel.init(frame: cell!.bounds)
        one.textAlignment = .Center
        one.text = stu.ToString
        cell?.contentView.addSubview(one)
        return cell!;
    }
   
}
