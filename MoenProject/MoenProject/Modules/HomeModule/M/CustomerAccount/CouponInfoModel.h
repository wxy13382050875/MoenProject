//
//  CouponInfoModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CouponInfoModel;
@interface CouponListModel : MoenBaseModel

/**banner图url*/
@property (nonatomic, strong) NSArray<CouponInfoModel *> *couponList;

@end

@class ShopInfo;
@interface CouponInfoModel : MoenBaseModel

@property (nonatomic, copy) NSString *assetId;

@property (nonatomic, copy) NSString *couponType;

@property (nonatomic, copy) NSString *payValue;

@property (nonatomic, copy) NSString *useCondition;

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;


@property (nonatomic, copy) NSString *info;


@property (nonatomic, copy) NSString *couponCategory;

/**是否选中*/
@property (nonatomic, assign) BOOL isSelected;

/**展示详情*/
@property (nonatomic, assign) BOOL isShowDetail;

/**适用门店*/
@property (nonatomic, strong) NSArray<ShopInfo *> *shopList;


@end


@interface ShopInfo : MoenBaseModel

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@end

NS_ASSUME_NONNULL_END
