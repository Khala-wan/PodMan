//
//  PodSpecs+CoreDataClass.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/3.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
import CoreData

@objc(PodSpecs)
public class PodSpecs: NSManagedObject {
    //MARK:新增
    class func insertData(name:String,https:String,ssh:String){
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        //创建对象
        let EntityName = "PodSpecs"
        let newProject = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:context) as! PodSpecs
        
        //对象赋值
        newProject.name = name
        newProject.httpsURL = https
        newProject.sshURL = ssh
        //保存
        app.saveContext()
    }
    
    //MARK:查询
    class func queryData(_ name:String?)->[PodSpecs]{
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        //        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "PodSpecs"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        fetchRequest.predicate = nil
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [PodSpecs]
            return fetchedObjects
            
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK:删除
    class func deleteData(name:String)  {
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "PodSpecs"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: String.init(format: "name = '%@'", name), "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [PodSpecs]
            
            //遍历查询的结果
            for info:PodSpecs in fetchedObjects{
                //删除对象
                context.delete(info)
                
                //重新保存
                app.saveContext()
            }
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
}
