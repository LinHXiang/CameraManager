//
//  File.swift
//  CameraProtocol
//
//  Created by 浩翔林 on 2019/5/20.
//  Copyright © 2019 林浩翔. All rights reserved.
//

protocol camera_FinishSetting {
    
    func finishSetUpAndStartRunning() -> camera_FinishSetting
    
    func stopRunning()
}
