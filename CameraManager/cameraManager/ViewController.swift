//
//  ViewController.swift
//  cameraManager
//
//  Created by 林浩翔 on 2019/5/17.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let set = CameraManager.cameraSetting { (set) in
            set.setCamera(.front)
            set.setMetadataScan(metadataObjectTypes: [.face], metadataDelegate: self)
        }
        
        set.startRunning(inView: self.view)
        
    }

    
    
    func setqrcode(){
        CameraManager.cameraSetting(persistenceKey: "qrcode", setting: { (set) in
            set.setCamera(.back)
            set.setMetadataScan(metadataObjectTypes: [.qr], metadataDelegate: self)
        }).startRunning(inView: self.view)
    }
    
    func setface(){
        CameraManager.cameraSetting(persistenceKey: "qrcode", setting: { (set) in
            set.setCamera(.front)
            set.setMetadataScan(metadataObjectTypes: [.face], metadataDelegate: self)
        }).startRunning(inView: self.view)
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if let faces = metadataObjects as? [AVMetadataFaceObject] {
            print("\(faces.count)个人头")
        }
        
//        for objc in metadataObjects {
//            
//            
//            if let object = (objc as? AVMetadataFaceObject){
//                print("一个人头")
//            }
//            
//        }
        
        
    }

}

