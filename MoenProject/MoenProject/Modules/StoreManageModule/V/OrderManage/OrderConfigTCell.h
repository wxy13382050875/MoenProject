//
//  OrderConfigTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

static NSString *KOrderConfigTCell = @"OrderConfigTCell";
static CGFloat KOrderConfigTCellHeight = 205;
NS_ASSUME_NONNULL_BEGIN

@interface OrderConfigTCell : UITableViewCell


- (void)showDataWithOrderDetailModel:(OrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
