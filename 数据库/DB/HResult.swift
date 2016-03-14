//
//  HResult.swift
//  MYDataBase
//
//  Created by space on 16/2/15.
//  Copyright © 2016年 Space. All rights reserved.
//

import Foundation

class HResult:NSObject{
    var CurrrentStmt:COpaquePointer
    var  data_count:Int?
    var cloumnArray:[String]?
    init(currentStmt:COpaquePointer){
        self.CurrrentStmt = currentStmt
    }
    
    func next()->Bool{
        if SQLITE_ROW == sqlite3_step(self.CurrrentStmt){
            return true
        }
        return false
    }
    
    func doubleForColumn(column:Int)->Double{
        return sqlite3_column_double(CurrrentStmt, Int32(column))
    }
    func intValueForColumn(column:Int)->Int{
        return Int(sqlite3_column_int(CurrrentStmt, Int32(column)))
    }
    func  StringForColumn(column:Int)->String{
        return String.fromCString(UnsafePointer(sqlite3_column_text(CurrrentStmt, Int32(column))))!
    }
    
    
    func stringFormColumnName(name:String)->String{
        initArray()
        let count = (self.cloumnArray! as NSArray).indexOfObject(name)
        return String.fromCString(UnsafePointer(sqlite3_column_text(CurrrentStmt, Int32(count))))!
    }
    func doubleFormColumnName(name:String)->Double{
        initArray()
        let count = (self.cloumnArray! as NSArray).indexOfObject(name)
        return sqlite3_column_double(CurrrentStmt, Int32(count))
    }
    func intValueForColumnName(name:String)->Int{
        initArray()
        let count = (self.cloumnArray! as NSArray).indexOfObject(name)
        return Int(sqlite3_column_int(CurrrentStmt, Int32(count)))
    }
    
    
    func dataForCurrentColumn()->[String:String]{
        var dic:[String:String] = [String:String]()
        let count = sqlite3_data_count(CurrrentStmt)
        for var i = 0 ; i < Int(count) ; i++ {
            let name = String.fromCString(sqlite3_column_name(CurrrentStmt, Int32(i)))
            let value = StringForColumn(i)
            guard let _ = name else{return dic}
            if ("\(value)" == "_IGNORE_" ){
                dic.updateValue("", forKey: name!)
            }else{
                dic.updateValue(value, forKey: name!)
            }
        }
        return dic
    }
   private func initArray(){
        if self.cloumnArray != nil {return}
        self.cloumnArray = [String]()
        let count = sqlite3_data_count(CurrrentStmt)
        for var i = 0 ; i < Int(count) ; i++ {
            let name = String.fromCString(sqlite3_column_name(CurrrentStmt, Int32(i)))
            self.cloumnArray?.append(name!)
        }
    }
    
}
