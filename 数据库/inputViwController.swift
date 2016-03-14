//
//  inputViwController.swift
//  HDataBase(swift)
//
//  Created by space on 16/2/29.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit

class inputViwController: UIViewController {

    @IBOutlet var one: UITextField!
    @IBOutlet var two: UITextField!
    @IBOutlet var there: UITextField!
    @IBOutlet var four: UITextField!
    @IBOutlet var five: UITextField!
    @IBOutlet var six: UITextField!
    @IBOutlet var textFields: [UITextField]!
    let win:UIWindow = {
        var one:UIWindow = UIWindow.init(frame: CGRectMake(0, 0, 100, 30))
        one.backgroundColor = UIColor.blackColor()
        let size:CGSize = UIScreen.mainScreen().bounds.size
        one.center = CGPointMake(0.5 * size.width,0.5 * size.height)
        let lab = UILabel.init(frame: one.bounds)
        lab.textAlignment = .Center
        lab.textColor = UIColor.orangeColor()
        one.addSubview(lab)
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let one  = UIBarButtonItem.init(title: "清空", style: .Plain, target: self, action: "remove")
        self.navigationItem.rightBarButtonItem = one
    }
    func remove(){
        for one in self.textFields {
            one.text = ""
        }
    }
    
}
extension inputViwController{
    /** 新增数据
        HDataBox.insertObject(stu)
    */
    @IBAction func save(sender: AnyObject) {
        var text:String = ""
        var flag:Bool = false
        if let stu = self.getStudent(){
           flag = HDataBox.insertObject(stu)
        }
        text = flag ? "SUccess" : "false"
        self.win.hidden = false
        let lab:UILabel = self.win.subviews.first as! UILabel
        lab.text = text
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.win.hidden = true
        }
    }

    /** 删除某条数据
       HDataBox.deleteObject(stu!)
     */
    @IBAction func deleteOne(sender: AnyObject) {
        let stu = self.getStudent()
        guard let _ = stu else {return     }
        HDataBox.deleteObject(stu!)
    }

    /** 得到某类型的所有数据
      HDataBox.selectAllObjects(&self.dataArray)
     */
    @IBAction func lookAll(sender: AnyObject) {
    self.navigationController?.pushViewController(resultViewController(), animated: true)
    }
    
    /** 更多数据库操作 请看
          HDataBox.swift
    */
}
extension inputViwController{
    func getStudent()->Student?{
        var flag:Bool = false
        for one in self.textFields {
            if(one.text?.lenght()>=1){
                flag = true
                break
            }
        }
        if (!flag){return nil}
        let stu:Student = Student()
        if(one.text?.lenght()>=1){stu.name = one.text}
        if(two.text?.lenght()>=1){stu.age = (two.text! as NSString).integerValue}
        if(there.text?.lenght()>=1){stu.gender = there.text}
        if(four.text?.lenght()>=1){stu.address = four.text}
        if(five.text?.lenght()>=1){stu.weight = (five.text! as NSString).doubleValue}
        if(six.text?.lenght()>=1){stu.source = (six.text! as NSString).integerValue}
        return stu;
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for one in self.textFields {
            one.resignFirstResponder()
        }
    }
}