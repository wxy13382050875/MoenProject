//
//  StoreActivityDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class StoreActivityDetailModel;
@interface StoreActivityListModel : MoenBaseModel

/**banner图url*/
@property (nonatomic, strong) NSArray<StoreActivityDetailModel *> *getPromoList;

@end


@class StoreActivityMealModel, StoreActivityCouponInfoModel;
@interface StoreActivityDetailModel : MoenBaseModel

/** 备注：促销活动ID*/
@property (nonatomic, copy) NSString *promoId;

/** 备注：2018双十一套餐促销活动*/
@property (nonatomic, copy) NSString *promoName;

/** 备注：(活动类型)（ORDER，COUPON，SET_MEAL）*/
@property (nonatomic, copy) NSString *proType;


/** 备注：2018/11/11- 2018-11-22*/
@property (nonatomic, copy) NSString *promoTime;

/** 备注：(活动描述)*/
@property (nonatomic, copy) NSString *promoDes;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *typeId;

@property (nonatomic, copy) NSString *activityAbstract;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;
//订单促销
@property (nonatomic, strong) NSArray *orderPromo;

@property (nonatomic, strong) NSArray<StoreActivityMealModel *> *comboPromo;

@property (nonatomic, strong) NSArray<StoreActivityCouponInfoModel *> *couponPromo;


@end

@class StoreActivityMealProductsModel;
@interface StoreActivityMealModel : MoenBaseModel

@property (nonatomic, copy) NSString *comboImageUrl;

@property (nonatomic, assign) NSInteger comboPrice;

@property (nonatomic, copy) NSString *comboCode;

@property (nonatomic, assign) NSInteger comboId;

@property (nonatomic, copy) NSString *comboName;

@property (nonatomic, copy) NSString *comboDes;

/**是否展示详情*/
@property (nonatomic, assign) BOOL isShowDetail;

@property (nonatomic, strong) NSArray<StoreActivityMealProductsModel *> *products;


@end

@interface StoreActivityMealProductsModel : MoenBaseModel

@property (nonatomic, copy) NSString *productImageUrl;
@property (nonatomic, copy) NSString *productSku;
@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) NSInteger count;

@end



@class StoreActivityShopInfo;
@interface StoreActivityCouponInfoModel : MoenBaseModel

@property (nonatomic, copy) NSString *couponTypeId;

@property (nonatomic, copy) NSString *couponCategory;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) NSInteger couponMoney;

@property (nonatomic, copy) NSString *couponType;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *couponCondition;

/**是否选中*/
@property (nonatomic, assign) BOOL isSelected;

/**展示详情*/
@property (nonatomic, assign) BOOL isShowDetail;

/**适用门店*/
@property (nonatomic, strong) NSArray<StoreActivityShopInfo *> *couponShops;


@end


@interface StoreActivityShopInfo : MoenBaseModel

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@end

NS_ASSUME_NONNULL_END
