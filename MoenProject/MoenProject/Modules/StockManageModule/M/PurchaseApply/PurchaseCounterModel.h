//
//  PurchaseCounter.h
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/31.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN



@class CommonProdutcModel,CommonMealProdutcModel;

@interface PurchaseCounterModel : MoenBaseModel

/**订单单品信息*/
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *orderProductList;

/**订单套餐*/
@property (nonatomic, strong) NSArray<CommonMealProdutcModel *> *orderSetMealList;

@end


NS_ASSUME_NONNULL_END
