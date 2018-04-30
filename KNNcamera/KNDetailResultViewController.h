//
//  KNDetailResultViewController.h
//  柯尼相册
//
//  Created by dang on 2017/4/11.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface KNDetailResultViewController : UIViewController

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) NSString *name;

@end
