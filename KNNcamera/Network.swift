//
//  Network.swift
//  柯尼相册
//
//  Created by dang on 2017/4/10.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders
import Accelerate
import AVFoundation
import AssetsLibrary

class Network: NSObject {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/model.data")
    var assetsLibrary = ALAssetsLibrary()
    //保存照片集合
    var assets = [ALAsset]()
    
    var objectMArray : NSMutableArray = []
    
    var countOne = 0
    
    // Outlets to label and view
    // @IBOutlet weak var predictLabel: UILabel!
    // @IBOutlet weak var predictView: UIImageView!
    
    // some properties used to control the app and store appropriate values
    var Net: Inception3Net? = nil
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var imageNum = 0
    var total = 6
    var textureLoader : MTKTextureLoader!
    var ciContext : CIContext!
    var sourceTexture : MTLTexture? = nil
    
    
    func startWork() -> NSMutableArray{
        
        // Load default device.
        device = MTLCreateSystemDefaultDevice()
        
    
        // Load any resources required for rendering.
        
        // Create new command queue.
        commandQueue = device!.makeCommandQueue()
        
        // make a textureLoader to get our input images as MTLTextures
        textureLoader = MTKTextureLoader(device: device!)
        
        // Load the appropriate Network
        Net = Inception3Net(withCommandQueue: commandQueue)
        
        // we use this CIContext as one of the steps to get a MTLTexture
        ciContext = CIContext.init(mtlDevice: device)
        
        if NSKeyedUnarchiver.unarchiveObject(withFile:path!) != nil {
            let data = NSKeyedUnarchiver.unarchiveObject(withFile:path!) as! Data
            objectMArray = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSMutableArray
        } else {
            self.findPicture()
        }
        
        return objectMArray;
    }
    
    /**
     This function gets a commanBuffer and encodes layers in it. It follows that by commiting the commandBuffer and getting labels
     
     
     - Returns:
     Void
     */
    func runNetwork(index: Int){
        
        // to deliver optimal performance we leave some resources used in MPSCNN to be released at next call of autoreleasepool,
        // so the user can decide the appropriate time to release this
        autoreleasepool{
            // encoding command buffer
            let commandBuffer = commandQueue.makeCommandBuffer()
            
            // encode all layers of network on present commandBuffer, pass in the input image MTLTexture
            Net!.forward(commandBuffer: commandBuffer, sourceTexture: sourceTexture)
            
            // commit the commandBuffer and wait for completion on CPU
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            let model = Net!.getLabel(assetIndex: index)
            
            objectMArray.add(model)
            //获取当前时间
            let now = NSDate()
            
            // 创建一个日期格式器
            let dformatter = DateFormatter()
            dformatter.dateFormat = "HH:mm:ss"
            print("\(dformatter.string(from: now as Date)) " + model.name)
        }
    }
    /**
     This function is used to fetch the appropriate image and store it in a MTLTexture
     so we can run our inference network on it
     
     
     - Returns:
     Void
     */
    func over() {
        
        for index in 0 ..< self.assets.count{
            // image is changing, hide predictions of previous layer
            // get appropriate image name and path to load it into a metalTexture
            do {
                let myAsset = self.assets[index]
                var cg = myAsset.thumbnail().takeUnretainedValue()
                var data = UIImagePNGRepresentation(UIImage(cgImage: cg))//!!!
                sourceTexture = try textureLoader.newTexture(with: data!, options: [:])
            }
            catch let error as NSError {
                fatalError("Unexpected error ocurred: \(error.localizedDescription).")
            }
            runNetwork(index: index)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: objectMArray)
        NSKeyedArchiver.archiveRootObject(data, toFile: path!)
    }
    
    func findPicture() {
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (ALAssetsGroup, stop) in
            if ALAssetsGroup != nil {
                ALAssetsGroup?.enumerateAssets({(result, index, stop) in
                    if result != nil {
                        self.assets.append(result!)
                        self.countOne += 1
                    }
                })
                print("assets:\(self.countOne)")
                self.over()
            }
        }) { (fail) in
            print(fail)
        }
    }
    
}

