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
    
    public let metadataOutput = AVCaptureMetadataOutput()
    
    public let previewLayer = AVCaptureVideoPreviewLayer()
    
    var queue = DispatchQueue(label: "cameraManager_default")
    
    func startRunning(inView : UIView,layerFrame:CGRect? = nil ,videoGravity:AVLayerVideoGravity = .resizeAspectFill){
        self.setPreviewLayer(inView: inView, layerFrame: layerFrame, videoGravity: videoGravity)
        self.session.startRunning()
    }
    
    func stopRunning(){
        self.session.stopRunning()
    }
    
    //设置前后摄像头
    func setCamera(_ position:AVCaptureDevice.Position , deviceSetting:((AVCaptureDevice)->Void)? = nil){
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
            deviceSetting?(device)
        }
    }
    
    func setPhotoOutPut(outPutSetting : ((AVCaptureStillImageOutput) -> Void)? = nil){
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        outPutSetting?(photoOutput)
    }
    
    func setVideoOutPut(videoDataOutputDelegate:AVCaptureVideoDataOutputSampleBufferDelegate? = nil,outPutSetting : ((AVCaptureVideoDataOutput) -> Void)? = nil){
        if session.canAddOutput(videoOutPut) {
            session.addOutput(videoOutPut)
        }
        videoOutPut.setSampleBufferDelegate(videoDataOutputDelegate, queue: queue)
        outPutSetting?(videoOutPut)
    }
    
    func setMetadataScan(scanSize:CGRect? = nil, metadataObjectTypes:[AVMetadataObject.ObjectType], metadataDelegate:AVCaptureMetadataOutputObjectsDelegate){
        metadataOutput.setMetadataObjectsDelegate(metadataDelegate, queue: DispatchQueue.main)
        session.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = metadataObjectTypes
        
        if let size = scanSize{
            let windowSize = UIScreen.main.bounds
            var scanRect = CGRect(x:(windowSize.width-size.width)/2,
                                  y:(windowSize.height-size.height)/2,
                                  width:size.width, height:size.height)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:size.origin.y/windowSize.height,
                              y:size.origin.x/windowSize.width,
                              width:size.size.height/windowSize.height,
                              height:size.size.width/windowSize.width);
            //设置可探测区域
            metadataOutput.rectOfInterest = scanRect
        }
    }
    
    //设置实时预览画面
    fileprivate func setPreviewLayer(inView : UIView,layerFrame:CGRect? = nil ,videoGravity:AVLayerVideoGravity = .resizeAspectFill){
        previewLayer.session = self.session
        previewLayer.videoGravity = videoGravity
        previewLayer.frame = layerFrame ?? inView.bounds
        inView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    func setSessionPreset(_ Preset:AVCaptureSession.Preset){
        if (session.canSetSessionPreset(Preset)) {
            session.sessionPreset = Preset
        }
    }
    
    //控制闪光灯
    func controlTorch(torchMode:AVCaptureDevice.TorchMode? = nil){
        if let mode = torchMode , videoDevice?.torchMode != torchMode{
            do {
                try videoDevice?.lockForConfiguration()
            } catch {
                return
            }
            videoDevice?.torchMode = mode
            videoDevice?.unlockForConfiguration()
        }else{
            if videoDevice?.torchMode == .on{
                do {
                    try videoDevice?.lockForConfiguration()
                } catch {
                    return
                }
                videoDevice?.torchMode = .off
                videoDevice?.unlockForConfiguration()
            }else {
                do {
                    try videoDevice?.lockForConfiguration()
                } catch {
                    return
                }
                videoDevice?.torchMode = .on
                videoDevice?.unlockForConfiguration()
            }
        }
    }
    
    //快门拍照
    func shutter(photoCallBack:@escaping (UIImage)->Void){
        
        guard let conntion = photoOutput.connection(with: .video) else {
            print("conntion error")
            return
        }
        
        photoOutput.captureStillImageAsynchronously(from: conntion, completionHandler: { (CMSampleBuffer, error) in
            
            guard CMSampleBuffer != nil else {
                print("CMSampleBuffer error :\(String(describing: (error)))")
                return
            }
            
            guard let photoData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer!) else {
                print("image data error")
                return
            }
            
            guard let image = UIImage(data: photoData) else {
                print("image transform error")
                return
            }
            
            photoCallBack(image)
        })
    }
}
