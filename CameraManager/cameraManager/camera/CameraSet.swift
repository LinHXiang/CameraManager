//
//  CameraSet.swift
//  cameraManager
//
//  Created by 浩翔林 on 2019/5/20.
//  Copyright © 2019 林浩翔. All rights reserved.
//

import AVFoundation
import UIKit

enum deviceType {
    case video
    case audio
}

class CameraSet {
    var videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)

    let session = AVCaptureSession()

    let photoOutput = AVCapturePhotoOutput()

    let videoOutPut = AVCaptureVideoDataOutput()

    let qrCodeOutput = AVCaptureMetadataOutput()

    let previewLayer = AVCaptureVideoPreviewLayer()

    class func checkDeviceCamera(types:[deviceType]) ->CameraManager?{
        if types.contains(.video){
            
            
            
            let captureDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.init(rawValue: 0)], mediaType: .video, position: .back)
            
//            AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position];
//
//            NSArray *devicesIOS  = devicesIOS10.devices;
//            for (AVCaptureDevice *device in devicesIOS) {
//                if ([device position] == position) {
//                    return device;
//                }
//            }
//            return nil;
            
        //            AVCaptureDeviceDiscoverySession
        
//            let captureDevices  = AVCaptureDevice.devices(for: AVMediaType.video)
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
    //
    //    //设置前后摄像头
    //    func setCamera(isFront:Bool) -> CameraManager{
    //        for device in AVCaptureDevice.devices(for: AVMediaType.video) {
    //            let position = isFront ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
    //            if device.position == position {
    //                videoDevice = device
    //                break
    //            }
    //        }
    //        return self
    //    }
    //
    //    func setVideoInput()-> CameraManager?{
    //        if let device = videoDevice {
    //            guard let input = try? AVCaptureDeviceInput(device:device) else{
    //                return nil
    //            }
    //            session.addInput(input)
    //            return self
    //        }
    //        return nil
    //    }
    //
    //    //设置二维码扫码功能
    //    func setScanQrcode(scanSize:CGRect, metadataDelegate:AVCaptureMetadataOutputObjectsDelegate) -> CameraManager{
    //        qrCodeOutput.setMetadataObjectsDelegate(metadataDelegate, queue: DispatchQueue.main)
    //        session.addOutput(qrCodeOutput)
    //        qrCodeOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    //
    //        let windowSize = UIScreen.main.bounds
    //        var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
    //                              y:(windowSize.height-scanSize.height)/2,
    //                              width:scanSize.width, height:scanSize.height)
    //        //计算rectOfInterest 注意x,y交换位置
    //        scanRect = CGRect(x:scanSize.origin.y/windowSize.height,
    //                          y:scanSize.origin.x/windowSize.width,
    //                          width:scanSize.size.height/windowSize.height,
    //                          height:scanSize.size.width/windowSize.width);
    //        //设置可探测区域
    //        qrCodeOutput.rectOfInterest = scanRect
    //
    //        return self
    //    }
    //
    //    //设置实时预览画面
    //    func setPreviewLayer(inView : UIView) -> camera_FinishSetting{
    //        previewLayer.session = self.session
    //        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    //        previewLayer.frame = inView.bounds
    //        inView.layer.insertSublayer(previewLayer, at: 0)
    //        return self as! camera_FinishSetting
    //    }
    //
    //    internal func finishSetUpAndStartRunning()->camera_FinishSetting{
    //        self.session.startRunning()
    //        return self as! camera_FinishSetting
    //    }
    //
    //    internal func stopRunning(){
    //        self.session.stopRunning()
    //
    //    }
}
