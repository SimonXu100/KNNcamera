// 
//  代码地址: https://github.com/iphone5solo/PYSearch

//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  搜索建议控制器

#import <UIKit/UIKit.h>

typedef void(^PYSearchSuggestionDidSelectCellBlock)(UITableViewCell *selectedCell);

@interface PYSearchSuggestionViewController : UITableViewController

/** 搜索建议 */
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
/** 选中cell时调用此Block  */
@property (nonatomic, copy) PYSearchSuggestionDidSelectCellBlock didSelectCellBlock;

+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock;

@end
