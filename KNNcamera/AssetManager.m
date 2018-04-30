//
//  AssetManager.m
//  柯尼相册
//
//  Created by dang on 2017/4/10.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import "AssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface AssetManager()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@end

@implementation AssetManager

+ (AssetManager *)sharedInstance {
    static AssetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AssetManager alloc] init];
    });
    return manager;
}

- (void)traversalAssets {
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    [self.assets addObject:result];
                }
            }];
            return;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
@end
