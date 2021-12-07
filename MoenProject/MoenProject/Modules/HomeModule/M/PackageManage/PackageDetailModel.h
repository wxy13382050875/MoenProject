//
//  PackageDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PromotionInfoModel, GoodsDetailModel;
@interface PackageDetailModel : MoenBaseModel

/**套餐ID*/
@property (nonatomic, assign) NSInteger comId;

/**套餐图片*/
@property (nonatomic, copy) NSString *imgUrl;

/**产品描述*/
@property (nonatomic, copy) NSString *comboDescribe;

/**产品名称*/
@property (nonatomic, copy) NSString *comboName;

/**套餐号*/
@property (nonatomic, copy) NSString *comboCode;


/**促销信息集合*/
@property (nonatomic, strong) NSArray<PromotionInfoModel *> *list;

/**商品发布信息*/
@property (nonatomic, strong) NSArray<GoodsDetailModel *> *productList;

@end


@class PackageDetailModel;
@interface PackageListModel : MoenBaseModel

/**套餐列表*/
@property (nonatomic, strong) NSArray<PackageDetailModel *> *listData;

@end


@interface PromotionInfoModel : MoenBaseModel

/**促销活动名称*/
@property (nonatomic, copy) NSString *name;

/**套餐号*/
@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END
