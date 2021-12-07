//
//  CouponStoreAddressTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *KCouponStoreAddressTCell = @"CouponStoreAddressTCell";
static CGFloat KCouponStoreAddressTCellHeight = 30;
NS_ASSUME_NONNULL_BEGIN

@interface CouponStoreAddressTCell : UITableViewCell

- (void)showDataWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
