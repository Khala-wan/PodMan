//
//  Pod+CoreDataClass.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/2.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
import CoreData

@objc(Pod)
public class Pod: NSManagedObject {
    //MARK:新增
    class func insertData(item:PodModel){
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        //创建对象
        let EntityName = "Pod"
        let newProject = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:context) as! Pod
        
        //对象赋值
        newProject.name = item.name
        newProject.specsRepo = item.specsRepo
        newProject.isPrivate = item.isPrivate!
        newProject.allowWarnings = item.allowWarnings!
        newProject.useLibraries = item.useLibraries!
        newProject.dictionary = item.dictionary
        //保存
        app.saveContext()
    }
    
    //MARK:查询
    class func queryData(_ name:String)->Pod?{
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 1  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Pod"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: String.init(format: "name = '%@'", name), "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Pod]
            return fetchedObjects.first
            
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK:修改
    class func changeData(_ newPod:Pod){
        
        //获取数据上下文对象
        let app = NSApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 1  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Pod"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: String.init(format: "name = '%@'", newPod.name!), "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Pod]
            let old:Pod = fetchedObjects.first!
            //对象赋值
            old.allowWarnings = newPod.allowWarnings
            old.useLibraries = newPod.useLibraries
            app.saveContext()
            
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
        fetchRequest.fetchLimit = 1  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Pod"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: String.init(format: "name = '%@'", name), "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Pod]
            
            //遍历查询的结果
            for info:Pod in fetchedObjects{
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
