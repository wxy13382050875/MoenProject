//
//  couponCategoryTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *KcouponCategoryTCell = @"couponCategoryTCell";
static CGFloat KcouponCategoryTCellHeitht = 35;

NS_ASSUME_NONNULL_BEGIN

@interface couponCategoryTCell : UITableViewCell

- (void)showDataWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
