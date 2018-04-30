//
//  KNViewController.m
//  柯尼相册
//
//  Created by dang on 2017/4/8.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import "KNViewController.h"
#import "PYSearch.h"
#import "PYSearchConst.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KNCollectionViewCell.h"
#import "AssetManager.h"

@interface KNViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *collView;
    BOOL isFirstIn;
}
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@end


@implementation KNViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    isFirstIn = YES;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-15)/4, (self.view.bounds.size.width-15)/4);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置每一行的间距
    flowLayout.minimumLineSpacing = 5;
    
    // 设置每个cell的间距
    flowLayout.minimumInteritemSpacing = 5;
    
    // 设置每组的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:flowLayout];
    collView.backgroundColor = [UIColor whiteColor];
    collView.delegate = self;
    collView.dataSource = self;
    [collView registerNib:[UINib nibWithNibName:@"KNCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationItem];
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    self.assets = [[NSMutableArray alloc] init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    [self.assets addObject:result];
                }
            }];
            [self.view addSubview:collView];
            AssetManager *manager = [AssetManager sharedInstance];
            manager.assets = self.assets;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (isFirstIn) {
        collView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
        isFirstIn = NO;
    } else {
        collView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.item];
    UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.imageView.image = image;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    // 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索相册" didSearchBlock:nil];
    // 设置风格
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
    searchViewController.searchSuggestionHidden = YES;
    // 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
    return NO;
}

#pragma mark - private method
- (void)initNavigationItem {
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.py_x = PYMargin * 0.5;
    titleView.py_y = 7;
    titleView.py_width = self.view.py_width - 64 - titleView.py_x * 2;
    titleView.py_height = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.tintColor = [UIColor colorWithHexString:@"969696"];
    //去掉灰色背景
    [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    [searchBar setBackgroundColor:[UIColor clearColor]];
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 15.0f;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:5];
    //设置边框为白色
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [searchBar setPlaceholder:@"搜索相册"];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
}

@end
