//
//  CameraSet.swift
//  cameraManager
//
//  Created by 浩翔林 on 2019/5/20.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import AVFoundation
import UIKit



class CameraSet {
    
    public var videoDevice: AVCaptureDevice? = nil

    public let session = AVCaptureSession()

    public let photoOutput = AVCaptureStillImageOutput()

    public let videoOutPut = AVCaptureVideoDataOutput()

    public let qrCodeOutput = AVCaptureMetadataOutput()

    public let previewLayer = AVCaptureVideoPreviewLayer()

    //设置前后摄像头
    func setCamera(_ position:AVCaptureDevice.Position){
        for device in AVCaptureDevice.devices(for: AVMediaType.video) {
            if device.position == position {
                videoDevice = device
                break
            }
        }
        if let device = videoDevice {
            do {
                let input = try AVCaptureDeviceInput(device:device)
                session.addInput(input)
            }catch{
                print(error)
            }
        }
    }
    
    
    //设置二维码扫码功能
    func setScanQrcode(scanSize:CGRect, metadataDelegate:AVCaptureMetadataOutputObjectsDelegate){
        qrCodeOutput.setMetadataObjectsDelegate(metadataDelegate, queue: DispatchQueue.main)
        session.addOutput(qrCodeOutput)
        qrCodeOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        let windowSize = UIScreen.main.bounds
        var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                              y:(windowSize.height-scanSize.height)/2,
                              width:scanSize.width, height:scanSize.height)
        //计算rectOfInterest 注意x,y交换位置
        scanRect = CGRect(x:scanSize.origin.y/windowSize.height,
                          y:scanSize.origin.x/windowSize.width,
                          width:scanSize.size.height/windowSize.height,
                          height:scanSize.size.width/windowSize.width);
        //设置可探测区域
        qrCodeOutput.rectOfInterest = scanRect
    }
    
    
    //设置实时预览画面
    func setPreviewLayer(inView : UIView){
        previewLayer.session = self.session
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = inView.bounds
        inView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    
    func startRunning(){
        self.session.startRunning()
    }
    
    func stopRunning(){
        self.session.startRunning()
    }
    
}
