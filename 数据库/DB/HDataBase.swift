//
//  HDataBase.swift
//  000
//
//  Created by space on 16/2/15.
//  Copyright © 2016年 Space. All rights reserved.
//

import Foundation

class HDataBase{
    var path:String?
    var _DB:COpaquePointer?
    init(path:String) {
        self.path = path
    }
    func open()->Bool{
        let one = UnsafeMutablePointer<COpaquePointer>.alloc(1)
        let code:Int32 = sqlite3_open((path! as  NSString).fileSystemRepresentation,one)
        if code == SQLITE_OK {
             _DB = one.memory
            return true
        }
        return false
    }
    func close()->Bool{
        sqlite3_close(_DB!)
        if nil == _DB {return true}
        return false
    }
    /**无返回值的操作*/
    func  executeUpdateSQL(sql:String)->Bool{
        let one = UnsafeMutablePointer<Int8>.alloc(1)
        let msg = UnsafeMutablePointer<UnsafeMutablePointer<Int8>>.alloc(1)
        msg.memory = one
        let ExecCode:Int32 = sqlite3_exec(_DB!, sql.CString(), nil, nil, msg)
        if ExecCode != SQLITE_OK {
            return false
        }
        return true
    }
    /**有返回值得操作*/
    func executeQuerySQL(sql:String)->HResult?{
        var stmt:COpaquePointer = nil
        let one = UnsafeMutablePointer<COpaquePointer>.alloc(1)
        let code:Int32 = sqlite3_prepare_v2(_DB!,sql.CString(),-1,one, nil)
        if code != SQLITE_OK {
            sqlite3_finalize(stmt)
            return nil
        }
        stmt = one.memory
        return  HResult.init(currentStmt: stmt)
    }
}
extension String{
    func CString()->UnsafePointer<Int8>{
        return (self as NSString).cStringUsingEncoding(4)
    }
}
