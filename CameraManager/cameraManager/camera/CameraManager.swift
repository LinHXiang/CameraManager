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
    
    class func cameraSetting(persistenceKey : String? = nil ,setting : @escaping (CameraSet) -> Void) -> CameraSet{
        var cameraSet = CameraSet()
        if let key = persistenceKey {
            if let set = self.shareInstance?.getCameraSet(key: key){
                cameraSet = set
                cameraSet.stopRunning()
            }else{
                setting(cameraSet)
                cameraSet.queue = DispatchQueue(label: "cameraManager_\(key)")
                self.shareInstance?.saveCameraSet(key: key, set: cameraSet)
            }
        }else{
            setting(cameraSet)
        }
        return cameraSet
    }
}

//object method
extension CameraManager{
    func startRunning(persistenceKey : String ,inView : UIView ,layerFrame:CGRect? = nil ,videoGravity:AVLayerVideoGravity = .resizeAspectFill){
        if let set = getCameraSet(key: persistenceKey){
            set.startRunning(inView: inView, layerFrame: layerFrame, videoGravity: videoGravity)
        }
    }
    
    func stopRunning(persistenceKey : String?){
        if let set = getCameraSet(key: persistenceKey){
            set.stopRunning()
        }
    }
    
    func getCameraSet(key:String?)->CameraSet?{
        guard key != nil else {
            return nil
        }
        return self.sets[key!]
    }
}

//class method
extension CameraManager{
    class func getInstanceCameraSet(key:String?)->CameraSet?{
        return self.shareInstance?.getCameraSet(key: key)
    }
    
    class func startInstanceCameraSetRunning(persistenceKey : String ,inView : UIView ,layerFrame:CGRect? = nil ,videoGravity:AVLayerVideoGravity = .resizeAspectFill){
        self.shareInstance?.startRunning(persistenceKey: persistenceKey, inView: inView, layerFrame: layerFrame, videoGravity: videoGravity)
    }
    
    class func stopInstanceCameraSetRunning(persistenceKey : String?){
        self.shareInstance?.stopRunning(persistenceKey: persistenceKey)
    }
}

//fileprivate
extension CameraManager {
    
    fileprivate func saveCameraSet(key:String,set:CameraSet){
        self.sets[key] = set
    }
    
    fileprivate class func checkDeviceCamera(types:[deviceType]) ->CameraManager?{
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
