//
//  AssetManager.h
//  柯尼相册
//
//  Created by dang on 2017/4/10.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetManager : NSObject

@property (nonatomic, strong) NSMutableArray *assets;

+ (AssetManager *)sharedInstance;

@end
