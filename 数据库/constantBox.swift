//
//  constantBox.swift
//  2_5 画板
//
//  Created by space on 15/12/21.
//  Copyright © 2015年 Space. All rights reserved.
//

import UIKit
extension String{

    /**得到长度*/
    func lenght()->Int{
        return (self as NSString).length
    }

    /**增加多个片段 @"%@,%@","A","B" 只支持 %@,%d,%f三种*/
    mutating func appStringByFormmter(mat:String,_ arguments:AnyObject...)->String{
        func operation(arr:[String],cut:String)->[String]{
            var array:[String] = [String]()
            for var i = 0 ; i < arr.count ; i++ {
                var temp:[String]=[String]();
                temp.append(arr[i])
                if arr[i].containsString(cut){
                    temp = arr[i].componentsSeparatedByString(cut)
                }
                array = (array as NSArray).arrayByAddingObjectsFromArray(temp) as! [String]
            }
            return array
        }
        let this:NSString = mat as NSString
        var allPart:[String] = operation(operation(this.componentsSeparatedByString("%@"), cut: "%f"), cut: "%d")
        if(allPart.count==1){return self}
        let temp = (allPart as NSArray).copy() as! [String]
        var content:String = ""
        for var i = 0 ; i < temp.count ; i++ {
            let one = allPart[i]
            content.appendContentsOf(one)
            var value:String = ""
            if( i < arguments.count){value = "\(arguments[i])"}
            content.appendContentsOf(value)
        }
        self.appendContentsOf(content)
        return  self
    }
 
   
}


   