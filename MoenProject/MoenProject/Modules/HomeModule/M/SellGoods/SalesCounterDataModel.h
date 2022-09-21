//
//  SalesCounterDataModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponInfoModel.h"
#import "CommonGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@class CouponInfoModel;
@interface SalesCounterDataModel : MoenBaseModel

/**订单优惠 */
@property (nonatomic, copy) NSString *orderDerate;


/**门店优惠 */
@property (nonatomic, copy) NSString *shopDerate;

/**其他优惠 */
@property (nonatomic, copy) NSString *otherDerate;

/**订金款额 */
@property (nonatomic, copy) NSString *reserveAmount;

/**尾款 */
@property (nonatomic, copy) NSString *remainAmount;

/**优惠券优惠 */
@property (nonatomic, copy) NSString *couponDerate;


/**实收金额 */
@property (nonatomic, copy) NSString *payAmount;


/**收货人 */
@property (nonatomic, copy) NSString *shipPerson;


/**电话 */
@property (nonatomic, copy) NSString *shipMobile;

/**地址 */
@property (nonatomic, copy) NSString *shipAddress;

/**地址id(有id存在地址信息) */
@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, assign) BOOL isUseAddress;

/**订单促销 */
@property (nonatomic, copy) NSString *rules;

/**应付款额 */
@property (nonatomic, copy) NSString *amountPayable;

/**应付款额 */
@property (nonatomic, copy) NSString *code;
/**可用资产*/
@property (nonatomic, strong) NSArray<CouponInfoModel *> *useCouponList;


/**不可用资产*/
@property (nonatomic, strong) NSArray<CouponInfoModel *> *notUseCouponList;

/**活动重点关注项 */
@property (nonatomic, assign) BOOL isActivity;

/**商品单品*/
@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderProductList;

/**单品套餐*/
@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderSetMealList;

/**赠品单品*/
@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderGiftProductList;

/**赠品套餐*/
@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderGiftSetMealList;
@end




NS_ASSUME_NONNULL_END
