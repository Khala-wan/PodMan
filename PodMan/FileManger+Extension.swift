//
//  FileManger+Extension.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/23.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

extension FileManager{
    func findFileWith(url:URL,suffix:String)throws ->(String,URL){
        let files:FileManager.DirectoryEnumerator = self.enumerator(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)!
        
        for file in files.allObjects{
            let fileURL:URL = file as! URL
            
            if let fileName = fileURL.pathComponents.last,fileName.hasSuffix(suffix) {
                return (fileName.components(separatedBy: ".")[0],fileURL)
            }
        }
        throw NSError()
    }
    
    func getVersionFromPodspec(url:URL)->String{
        _ = url.startAccessingSecurityScopedResource()
        var readHandler:FileHandle?
        do{
            readHandler = try FileHandle(forReadingFrom:url)
        }catch{
            return "-"
        }
        
        if let data = readHandler?.readDataToEndOfFile(){
            let readString = String(data: data, encoding: String.Encoding.utf8)
            guard readString != nil else {
                return "-"
            }
            for line in readString!.components(separatedBy: "\n"){
                if line.contains("s.version") {
                    let version:String = line.components(separatedBy: "=")[1].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "'", with: "")
                    return version
                }
            }
            readHandler?.closeFile()
        }
        url.stopAccessingSecurityScopedResource()
        return "-"
    }
    
    func exportFileExists(path:URL)->Bool{
        guard !path.absoluteString.contains(".Trash") else {
            return false
        }
        _ = path.startAccessingSecurityScopedResource()
        do{
            let result = try self.contentsOfDirectory(at: path.deletingLastPathComponent(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter({ (url) -> Bool in
                let fileName:String = url.lastPathComponent
                return fileName.contains("xcodeproj") || fileName.contains("podspec")
            })
            path.stopAccessingSecurityScopedResource()
            return result.count > 0
        }catch{
            path.stopAccessingSecurityScopedResource()
            return false
        }
    }
}
