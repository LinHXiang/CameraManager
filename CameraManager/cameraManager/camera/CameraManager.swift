//
//  CameraManager.swift
//  cameraManager
//
//  Created by 林浩翔 on 2019/5/17.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import UIKit




class CameraManager {
    
    static let shareInstance = CameraManager()
    
    fileprivate var sets:[String:CameraSet] = [String:CameraSet]()
    
    func saveCameraSet(key:String,set:CameraSet){
        self.sets[key] = set
    }
    
    func getCameraSet(key:String)->CameraSet?{
        return self.sets[key]
    }
    
    

}
