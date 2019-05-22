//
//  CameraManager.swift
//  cameraManager
//
//  Created by 林浩翔 on 2019/5/17.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import UIKit
import AVFoundation

enum deviceType {
    case video
    case audio
}

class CameraManager {
    
    static let shareInstance:CameraManager? = {
        return CameraManager.checkDeviceCamera(types: [.video,.audio])
    }()
    
    fileprivate var sets:[String:CameraSet] = [String:CameraSet]()
    
    func cameraSetting(persistenceKey : String? = nil ,setting : @escaping (CameraSet) -> Void){
        var set = CameraSet()
        if let key = persistenceKey , let keySet = getCameraSet(key: key) {
            set = keySet
            set.queue = DispatchQueue(label: "cameraManager_\(key)")
            set.stopRunning()
        }
        setting(set)
        if let key = persistenceKey , getCameraSet(key: key) == nil{
            saveCameraSet(key: key, set: set)
        }
    }
    
    class func cameraSetting(setting : @escaping (CameraSet) -> Void)->CameraSet{
        let set = CameraSet()
        setting(set)
        return set
    }
    
    func startRunning(persistenceKey : String){
        if let set = getCameraSet(key: persistenceKey){
            set.startRunning()
        }
    }
    
    func stopRunning(persistenceKey : String){
        if let set = getCameraSet(key: persistenceKey){
            set.stopRunning()
        }
    }
}



extension CameraManager {
    
    public func saveCameraSet(key:String,set:CameraSet){
        self.sets[key] = set
    }
    
    func getCameraSet(key:String)->CameraSet?{
        return self.sets[key]
    }
    
    public class func checkDeviceCamera(types:[deviceType]) ->CameraManager?{
        if types.contains(.video){
            let captureDevices = AVCaptureDevice.devices(for: AVMediaType.video)
            guard captureDevices.first != nil else{
                print("没可用的摄像头")
                return nil
            }
        }
        if types.contains(.audio){
            guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
                print("获取音频过程中有异常")
                return nil
            }
            guard let _ = try? AVCaptureDeviceInput(device: audioDevice) else {
                print("获取音频过程中有异常")
                return nil
            }
        }
        return CameraManager()
    }
    
}
