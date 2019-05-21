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
    
    public func saveCameraSet(key:String,set:CameraSet){
        self.sets[key] = set
    }
    
    func getCameraSet(key:String)->CameraSet?{
        return self.sets[key]
    }
    
    func cameraSetting(persistenceKey : String? = nil ,setting : @escaping (CameraSet) -> Void){
        let set = CameraSet()
        setting(set)
        set.startRunning()
        if let key = persistenceKey{
            saveCameraSet(key: key, set: set)
        }
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
