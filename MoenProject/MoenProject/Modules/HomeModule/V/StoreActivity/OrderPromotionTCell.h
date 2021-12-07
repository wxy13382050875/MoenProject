//
//  OrderPromotionTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetailModel.h"
#import "CommonGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *KOrderPromotionTCell = @"OrderPromotionTCell";
static CGFloat KOrderPromotionTCellH = 40;

@interface OrderPromotionTCell : UITableViewCell


- (void)showDataWithCommonGoodsModelForSearch:(CommonGoodsModel *)model;

- (void)showDataWithPromotionInfoModel:(PromotionInfoModel *)model;


- (void)showDataWithOrderAcitvitiesString:(NSString *)activitiesStr WithOrderDerate:(NSString *)orderDerate;
@end

NS_ASSUME_NONNULL_END
