//
//  SalesCounterConfigModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesCounterConfigModel : MoenBaseModel

/**是否赠送礼品*/
@property (nonatomic, assign) BOOL isFreeGift;

/**是否摩恩全国活动店*/
@property (nonatomic, assign) BOOL isMoen;

/**提货状态*/
@property (nonatomic, copy) NSString *pickUpStatus;
/**提货状态*/
@property (nonatomic, copy) NSString *pickUpStatusID;


/**配送方式*/
@property (nonatomic, copy) NSString *shoppingMethod;
/**配送方式*/
@property (nonatomic, copy) NSString *shoppingMethodID;

/**支付方式*/
@property (nonatomic, copy) NSString *paymentMethod;
/**支付方式*/
@property (nonatomic, copy) NSString *paymentMethodID;

/**门店优惠金额*/
@property (nonatomic, copy) NSString *shopDerate;


/**订单应付金额 用于判断门店优惠输入*/
@property (nonatomic, copy) NSString *payAmount;

/**备注*/
@property (nonatomic, copy) NSString *info;

@end

NS_ASSUME_NONNULL_END
