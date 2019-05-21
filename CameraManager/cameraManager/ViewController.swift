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
        
        CameraManager.shareInstance?.cameraSetting(persistenceKey: "testCamera" , setting: { (set) in
            set.setCamera(.back)
            set.setScanQrcode(scanSize: self.view.frame, metadataDelegate: self)
            set.setPreviewLayer(inView: self.view)
        })
        
        
        
        
        if CameraManager.shareInstance?.getCameraSet(key: "testCamera") == nil {
            print("nil")
        }else{
            print("已经存储")
            print(CameraManager.shareInstance?.getCameraSet(key: "testCamera"))

        }
    }

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        for objc in metadataObjects {
            if let object = (objc as? AVMetadataMachineReadableCodeObject)?.stringValue{
                print(object)
            }
        }
        
        
    }

}

