//
//  IntentionManageTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerIntentModel.h"

static NSString *KIntentionManageTCell = @"IntentionManageTCell";
static CGFloat KIntentionManageTCellHeight = 137;


typedef void(^IntentionManageTCellDeleteGoodsBlock)(NSString *goodsId);

NS_ASSUME_NONNULL_BEGIN

@interface IntentionManageTCell : UITableViewCell

- (void)showDataWithCustomerIntentGoodsModel:(CustomerIntentGoodsModel *)model;

@property (nonatomic, copy) IntentionManageTCellDeleteGoodsBlock deletGoodsBlock;
@end

NS_ASSUME_NONNULL_END
