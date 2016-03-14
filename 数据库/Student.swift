//
//  Student.swift
//  HDataBase(swift)
//
//  Created by space on 16/2/29.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit

class Student:NSObject{
    var name:String?
    var age:Int=0
    var gender:String?
    var address:String?
    var weight:Double=0
    var source:Int=0
}

extension Student{
    var ToString:String{
        get{
            var des:String = String()
            let mirr = Mirror(reflecting: self)
            for one in mirr.children {
                let name = one.label!
                let value = one.value
                des.appStringByFormmter("%@:%@  ", name,"\(value)")
            }
            return des
        }
    }
}
