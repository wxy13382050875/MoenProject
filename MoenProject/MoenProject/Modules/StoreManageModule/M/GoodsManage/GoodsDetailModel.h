//
//  GoodsDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailModel : MoenBaseModel

/**商品id*/
@property (nonatomic, assign) NSInteger ID;

/**图片*/
@property (nonatomic, copy) NSString *smallImageUrlC;

/**图片*/
@property (nonatomic, copy) NSString *imtUrl;

/**商品sku*/
@property (nonatomic, copy) NSString *skuId;

/**商品名称*/
@property (nonatomic, copy) NSString *name;

/**商品销售价格*/
@property (nonatomic, copy) NSString *price;

/**套餐中商品数量*/
@property (nonatomic, assign) NSInteger num;

/**商品品类*/
@property (nonatomic, copy) NSString *firstCategory;

/**商品系列*/
@property (nonatomic, copy) NSString *series;

/**规格*/
@property (nonatomic, copy) NSString *specification;

/**销售单位*/
@property (nonatomic, copy) NSString *packUnit;

/**摩恩PR00价*/
@property (nonatomic, copy) NSString *retailPrice;

/**商品图片*/
@property (nonatomic, strong) NSArray *list;

@end


@class GoodsDetailModel;
@interface GoodsListModel : MoenBaseModel

/**banner图url*/
@property (nonatomic, strong) NSArray<GoodsDetailModel *> *productListDetailData;

@end




NS_ASSUME_NONNULL_END
