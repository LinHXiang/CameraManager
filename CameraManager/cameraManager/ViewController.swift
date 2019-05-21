//
//  ViewController.swift
//  cameraManager
//
//  Created by 林浩翔 on 2019/5/17.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CameraManager.shareInstance?.cameraSetting(persistenceKey: "testCamera" , setting: { (set) in
            set.setCamera(.back)
            set.setPreviewLayer(inView: self.view)
        })
        
        
        
        
        if CameraManager.shareInstance?.getCameraSet(key: "testCamera") == nil {
            print("nil")
        }else{
            print("已经存储")
            print(CameraManager.shareInstance?.getCameraSet(key: "testCamera"))

        }
    }


}

