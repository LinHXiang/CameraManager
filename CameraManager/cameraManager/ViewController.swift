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
        
        setface()
        
    }

    
    
    func setqrcode(){
        CameraManager.shareInstance?.cameraSetting(persistenceKey: "qrcode", setting: { (set) in
            set.setCamera(.back)
            set.setMetadataScan(metadataObjectTypes: [.qr], metadataDelegate: self)
            set.setPreviewLayer(inView: self.view)
        })
    }
    
    func setface(){
        CameraManager.shareInstance?.cameraSetting(persistenceKey: "qrcode", setting: { (set) in
            set.setCamera(.back)
            set.setMetadataScan(metadataObjectTypes: [.face], metadataDelegate: self)
            set.setPreviewLayer(inView: self.view)
        })
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        for objc in metadataObjects {
            if let object = (objc as? AVMetadataMachineReadableCodeObject)?.stringValue{
                print(object)
            }
        }
        
        
    }

}

