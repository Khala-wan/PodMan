//
//  PodManProject+CoreDataClass.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/24.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
import CoreData

@objc(PodManProject)
public class PodManProject: NSManagedObject {
    //MARK:新增
    class func insertData(name:String,filePath:URL,isPod:Bool){
        
        //获取数据上下文对象
        let app = NSApplication.shared().delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        //创建user对象
        let EntityName = "PodManProject"
        let newProject = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:context) as! PodManProject
        
        //对象赋值
        newProject.name = name
        newProject.filePathData = try! filePath.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) as NSData
        newProject.isPod = isPod
        newProject.lintPath = filePath.absoluteString
        //保存
        app.saveContext()
    }
    
    //MARK:查询
    class func queryData(_ path:URL?)->[project]{
        
        //获取数据上下文对象
        let app = NSApplication.shared().delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        //        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "PodManProject"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        if let filePath:URL = path {
            let predicate = NSPredicate.init(format: String.init(format: "lintPath = '%@'", filePath.absoluteString), "")
            fetchRequest.predicate = predicate
        }else{
            fetchRequest.predicate = nil
        }
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [PodManProject]
            let result:[project] = fetchedObjects.map({ (info) -> project in
                
                var stale:Bool = true
                var fileURL:URL?
                do{
                    fileURL = try URL.init(resolvingBookmarkData: info.filePathData! as Data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &stale)!
                }catch{
                    fileURL = URL.init(string: "www.google.com")
                }
                return info.isPod ? project.pod(name: info.name!, path: fileURL!, version: "*", lintPath: info.lintPath!) : project.app(name: info.name!, path: fileURL!, lintPath: info.lintPath!)
            })
            return result
            
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK:删除
    class func deleteData(path:String)  {
        
        //获取数据上下文对象
        let app = NSApplication.shared().delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "PodManProject"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: String.init(format: "lintPath = '%@'", path), "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [PodManProject]
            
            //遍历查询的结果
            for info:PodManProject in fetchedObjects{
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
