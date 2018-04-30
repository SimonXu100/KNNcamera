//
//  KNDetailResultViewController.m
//  柯尼相册
//
//  Created by dang on 2017/4/11.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import "KNDetailResultViewController.h"

@interface KNDetailResultViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *probLal;

@end

@implementation KNDetailResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.probLal.text = self.name;
    self.imageView.image = [UIImage imageWithCGImage:self.asset.aspectRatioThumbnail];
}

@end
