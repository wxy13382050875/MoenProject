//
//  PurchaseCounterVC.h
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/31.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StockSearchGoodsVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface PurchaseCounterVC : BaseViewController
@property (nonatomic, copy) NSString *storeID;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSString *goodsType;

@property (nonatomic, assign) SearchGoodsVCType controllerType;

@end

NS_ASSUME_NONNULL_END
