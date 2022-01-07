//
//  ChangeStockTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
#import "XwInventoryModel.h"
#import "XwLastGoodsListModel.h"
#import "xWStockOrderModel.h"
#import "PurchaseOrderManageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChangeStockTCell : BaseTableViewCell

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@property(nonatomic,copy)Inventorylist* model;
@property(nonatomic,copy)Lastgoodslist* lastModel;
@property(nonatomic,copy)Goodslist* goodsModel;

@property(nonatomic,strong)Goodslist* problemModel;
- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
