//
//  KNResultViewController.h
//  柯尼相册
//
//  Created by dang on 2017/4/10.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNResultViewController : UIViewController

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
