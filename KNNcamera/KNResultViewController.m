//
//  KNResultViewController.m
//  柯尼相册
//
//  Created by dang on 2017/4/10.
//  Copyright © 2017年 OurEDA. All rights reserved.
//

#import "KNResultViewController.h"
#import "KNCollectionViewCell.h"
#import "PYSearch.h"
#import "KoniCamera-Swift.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetManager.h"
#import "KNDetailResultViewController.h"
#import "MBProgressHUD.h"

@interface KNResultViewController()<UICollectionViewDelegate, UICollectionViewDataSource, PYSearchViewControllerDelegate>
{
    NSMutableArray *objectMArray;
    BOOL isFirstIn;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) NSMutableArray *resultArr;
@property (nonatomic, strong) Network *net;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation KNResultViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    isFirstIn = YES;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.resultArr removeAllObjects];
    for (int index = 0; index < objectMArray.count; index++) {
        ObjectModel *model = objectMArray[index];
        if ([model.name rangeOfString:self.searchText].length > 0 && model.prob > 0.6) {
            [self.resultArr addObject:model];
        }
    }
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    if (isFirstIn) {
        [self startSearchNotificationAction];
        [self.collectionView reloadData];
        isFirstIn = NO;
    }
    [hud hide:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ObjectModel *model = self.resultArr[indexPath.item];
    ALAsset *asset = [AssetManager sharedInstance].assets[model.index];
    UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.imageView.image = image;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNDetailResultViewController *vc = [[KNDetailResultViewController alloc] init];
    ObjectModel *model = self.resultArr[indexPath.item];
    vc.asset = [AssetManager sharedInstance].assets[model.index];
    vc.name = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startSearchNotificationAction {
    objectMArray = [self.net startWork];
    for (int index = 0; index < objectMArray.count; index++) {
        ObjectModel *model = objectMArray[index];
        if ([model.name rangeOfString:self.searchText].length > 0 && model.prob > 0.7) {
            [self.resultArr addObject:model];
        }
    }
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-15)/4, (self.view.bounds.size.width-15)/4);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)resultArr {
    if (_resultArr == nil) {
        _resultArr = [[NSMutableArray alloc] init];
    }
    return _resultArr;
}

- (Network *)net {
    if (_net == nil) {
        _net = [[Network alloc] init];
    }
    return _net;
}
@end
