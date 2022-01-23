//
//  OrderReturnStatusTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/2/11.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"

static NSString *KOrderReturnStatusTCell = @"OrderReturnStatusTCell";
static NSString *KOrderReturnStatusTCellForGift = @"OrderReturnStatusTCellForGift";
static NSString *KOrderReturnStatusTCellForSingle = @"OrderReturnStatusTCellForSingle";
static NSString *KOrderReturnStatusTCellForPackageGift = @"OrderReturnStatusTCellForPackageGift";

static CGFloat KOrderReturnStatusTCellHeight = 30;
static CGFloat KOrderReturnStatusTCellDHeight = 57;
NS_ASSUME_NONNULL_BEGIN


@interface OrderReturnStatusTCell : UITableViewCell

- (void)showDataWithCommonMealProdutcModel:(CommonMealProdutcModel *)goodsModel;

- (void)showDataWithCommonProdutcModel:(CommonProdutcModel *)model;

//- (void)showDataWithDeliverModel:(CommonProdutcModel *)model;
@end

NS_ASSUME_NONNULL_END
