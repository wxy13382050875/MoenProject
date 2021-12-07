//
//  StoreStockVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, StockVCType)
//{
//    /**商品库存*/
//    StockGoods = 0,
//    /**样品库存*/
//    StockSample,
//};
#import "PurchaseOrderManageVC.h"
#import "StockSearchGoodsVC.h"
NS_ASSUME_NONNULL_BEGIN
/**商品管理*/
@interface StoreStockVC : BaseViewController

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;


@end

NS_ASSUME_NONNULL_END
