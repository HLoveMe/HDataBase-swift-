//
//
//  Created by space on 16/1/30.
//  Copyright © 2016年 Space. All rights reserved.
//

import Foundation

class HDataBox {
    private  init(){}
    static private  var dataBase:HDataBase!
    static private var document:String  =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
    static private var currentModel:AnyObject?
    
    /**增删改查*/
     
     /**增加*/
    static  func insertObject(obj:AnyObject) ->Bool{
        currentModel = obj
        createTableAndDataBase(obj.dynamicType)
        let sqlStr = sqlString(.insert, clazz: obj.dynamicType)
        return dataBase.executeUpdateSQL(sqlStr)
    }
    /**删除*/
    static func deleteObject(obj:AnyObject)->Bool{
        currentModel = obj
        createTableAndDataBase(obj.dynamicType)
        let delete = sqlString(.delete, clazz: obj.dynamicType)
        return dataBase.executeUpdateSQL(delete)
    }
    /**删除所有该类数据*/
    static func deleteAllObjects(clazz:AnyClass)->Bool{
        var sql = "delete from t_"
        sql+="\(clazz)"
        return  dataBase.executeUpdateSQL(sql)
    }
    
    /**改 更新*/
    static func updataObject(obj:AnyObject,onlyTag:String/**唯一标识的属性名*/)->Bool{
        currentModel = obj
        guard let value  = obj.valueForKeyPath(onlyTag) else {return false}
        pars = [onlyTag:value]
        createTableAndDataBase(obj.dynamicType)
        let updata = sqlString(.updata, clazz: obj.dynamicType)
        
       return  dataBase.executeUpdateSQL(updata)
    }
    /**查询 指定条件的值*/
    static private var pars:[String:AnyObject]?
    static func selectObjects<T:NSObject>(parameter:[String:AnyObject]?,inout array:[T])->[T]{
        pars = parameter
        createTableAndDataBase(T.self)
        let sqlStr = sqlString(.select, clazz: T.self)
        let result:HResult = dataBase.executeQuerySQL(sqlStr)!
        objects(result, temp: &array)
        return array
    }
    /**查询 指定SQL*/
    static func selectObjects<T:NSObject>(sqlSring:String,inout array:[T])->[T]{
        createTableAndDataBase(T.self)
        let result:HResult = dataBase.executeQuerySQL(sqlSring)!
        objects(result, temp:&array)
        return array
        
    }
    /**查询所有数据*/
    static func selectAllObjects<T:NSObject>(inout array:[T])->[T]{
        selectObjects(nil, array: &array)
        return array
    }
    
    /**删除表*/
    static func deleteTable(clazz:AnyClass)->Bool{
        createTableAndDataBase(clazz)
        let sql =  sqlString(.deleteTable, clazz: clazz)
        return dataBase.executeUpdateSQL(sql)
    }
    /**删除数据库*/
    static func deleteDB()->Bool{
       let path = DBPath()
       let manager = NSFileManager.init()
        do{
            try manager.removeItemAtPath(path)
        }catch{
            return false
        }
        return true
    }
}
extension HDataBox{
    /**表名*/
    static private func tableName(clazz:AnyClass)->String{
        var temp = NSStringFromClass(clazz)
        let projectName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let range = temp.rangeOfString(projectName)
        temp.removeRange(Range.init(start: temp.startIndex, end: range!.endIndex.advancedBy(1)))
        var t = "t_"
        t.appendContentsOf(temp)
        return t
    }
    /**数据库*/
    static private func DBPath()->String{
        var temp = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        temp.appendContentsOf(".db")
        return (document as NSString).stringByAppendingPathComponent(temp)
    }
    static private func dataBaseWithAnyClass(anyclazz:AnyClass)->HDataBase{
        return HDataBase.init(path: DBPath())
    }
    
    static private func createTableAndDataBase(clazz:AnyClass){
        dataBase = dataBaseWithAnyClass(clazz)
        dataBase.open()
        let one = sqlString(.create, clazz: clazz)
        dataBase.executeUpdateSQL(one)
    }
    
    static func sqlString(type:operationType,clazz:AnyClass)->String{
        var sqlString:String = String()
        switch type{
        case .create:
            sqlString.appendContentsOf(" create table if not exists " + " \(tableName(clazz))")
            sqlString.appendContentsOf(self.option(.create, anyObj:clazz))
            break
        case .insert:
            //          " insert into t_Thing (time,title) values('one','where')"
            sqlString.appendContentsOf("insert into " + "\(tableName(clazz))")
            sqlString.appendContentsOf(option(.insert, anyObj:clazz))
            sqlString.appendContentsOf(values(currentModel!))
            break
        case .delete:
            //            delete from t_Thing where id = '331'
            sqlString.appendContentsOf(" delete from " + "\(tableName(clazz))")
            sqlString.appendContentsOf(" where ")
            sqlString.appendContentsOf(keyValues(currentModel!))
            
            break
        case .updata:
//            update table set column1='' where column2=''
            sqlString.appendContentsOf("update " + "\(tableName(clazz))" + " set ")
            sqlString.appendContentsOf(keyValues(currentModel!))
            sqlString = (sqlString as NSString).stringByReplacingOccurrencesOfString("and", withString: ",")
            sqlString.appendContentsOf(" where ")
            for one in pars!.keys {
                let value = pars![one]
                if ("\(value)" != "\(currentModel!.valueForKeyPath(one))"){return ""}
                if let _ = value{
                    sqlString.appendContentsOf(one + " = " + "'" + "\(value)" + "'")
                }
            }
            var temp = ""
            temp =  (sqlString as NSString).stringByReplacingOccurrencesOfString("Optional(", withString: "")
            sqlString = (temp as NSString).stringByReplacingOccurrencesOfString(")", withString: "")
            break
        case .select:
            sqlString.appendContentsOf("select * from " + "\(tableName(clazz))" + " where '1' = '1' ")
            if let _ = pars {
                for one in pars!.keys {
                    sqlString.appendContentsOf(" and ")
                    let value = pars![one]!
                    sqlString.appendContentsOf(one)
                    sqlString.appendContentsOf(" = ")
                    sqlString.appendContentsOf("\(value)")
                    sqlString.appendContentsOf(" and ")
                }
                sqlString.removeRange(Range.init(start: sqlString.endIndex.advancedBy(-5), end: sqlString.endIndex))
            }
            break
            
        case .deleteTable:
                sqlString.appendContentsOf("drop table " + "\(tableName(clazz))")
            break
        case .dropDB:
            
            break
            
        }
        
        return sqlString
    }
    //    (name,value,some)
    static func option(type:operationType,anyObj:AnyClass)->String{
        var optionStr = " ("
        let mirr = Mirror(reflecting:(anyObj as! NSObject.Type).init())
        for one in mirr.children {
            let name:String = one.label!
            optionStr.appendContentsOf(name)
            if type == .create {
                optionStr.appendContentsOf(" text ")
            }
            optionStr.appendContentsOf(",")
        }
        optionStr.removeRange(Range.init(start: optionStr.endIndex.advancedBy(-1), end: optionStr.endIndex))
        optionStr.appendContentsOf(")")
        return  optionStr
    }
    //    values(xxxx)
    static func values(obj:AnyObject)->String{
        var optionStr = " values("
        let mirr = Mirror(reflecting: obj)
        for one in mirr.children {
            let name:String = one.label!
            //             NSData
            var value = "_IGNORE_"
            if let temp = obj.valueForKeyPath(name){
                value = "\(temp)"
            }
            optionStr.appendContentsOf("'")
            optionStr.appendContentsOf(value)
            optionStr.appendContentsOf("'")
            optionStr.appendContentsOf(",")
        }
        optionStr.removeRange(Range.init(start: optionStr.endIndex.advancedBy(-1), end: optionStr.endIndex))
        optionStr.appendContentsOf(")")
        return  optionStr
    }
    //  name="zzh" and price="66元" and age=67
    static func keyValues(obj:AnyObject)->String{
        var optionStr = " "
        let mirr = Mirror(reflecting: obj)
        for one in mirr.children {
            let name = one.label!
            let value = obj.valueForKeyPath(name)
            optionStr.appendContentsOf(name)
            optionStr.appendContentsOf(" = ")
            optionStr.appendContentsOf(" '")
        
            if let _ = value {
                optionStr.appendContentsOf("\(value)")
                
            }else{
                optionStr.appendContentsOf("\("_IGNORE_")")
            }
            optionStr.appendContentsOf("' ")
            optionStr.appendContentsOf(" and ")
            
        }
        var temp = ""
        temp =  (optionStr as NSString).stringByReplacingOccurrencesOfString("Optional(", withString: "")
        temp = (temp as NSString).stringByReplacingOccurrencesOfString(")", withString: "")
        temp.removeRange(Range.init(start: temp.endIndex.advancedBy(-5), end: temp.endIndex))
        return temp
    }
    /**result 转模型*/
    static private func objects<T:NSObject>(result:HResult,inout temp:[T])->[T]{
        while  result.next() {
            let mirr = Mirror(reflecting:T())
            let model:T = T()
            for one in mirr.children {
                let name = one.label!
                let value =  result.stringFormColumnName(name)
                if  value != "_IGNORE_"{
                    model.setValue(value, forKey:name)
                }
            }
            temp.append(model)
        }
        return temp
    }
}

enum operationType:String{
    case create
    case insert
    case delete
    case updata
    case select
    case deleteTable
    case dropDB
}