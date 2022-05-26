//
//  OrderDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/7.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonGoodsModel.h"
#import "XwActivityModel.h"
NS_ASSUME_NONNULL_BEGIN


@class CommonProdutcModel,CommonMealProdutcModel;
@interface OrderDetailModel : MoenBaseModel

/**订单编号*/
@property (nonatomic, copy) NSString *codeStr;


/**订单创建时间*/
@property (nonatomic, copy) NSString *createDate;

/**预约时间*/
@property (nonatomic, copy) NSString *appointmentDate;


/**会员账户*/
@property (nonatomic, copy) NSString *account;


/**创建人*/
@property (nonatomic, copy) NSString *createUser;


/**业务角色*/
@property (nonatomic, copy) NSString *businessRole;


/**是否订单优惠*/
@property (nonatomic, assign) BOOL isOrderDerate;


/**满减条件*/
@property (nonatomic, copy) NSString *maxAmount;


/**订单满减金额*/
@property (nonatomic, copy) NSString *orderDerate;




/**是否赠送礼品*/
@property (nonatomic, assign) BOOL isFreeGift;



/**是否摩恩全国活动*/
@property (nonatomic, assign) BOOL isMoen;


/**提货状态*/
@property (nonatomic, copy) NSString *pickUpStatus;


/**支付方式*/
@property (nonatomic, copy) NSString *paymentMethod;


/**配送方式*/
@property (nonatomic, copy) NSString *shoppingMethod;


/**商品数量*/
@property (nonatomic, assign) NSInteger productCount;


/**赠品数量*/
@property (nonatomic, assign) NSInteger giftNum;



/**应付金额*/
@property (nonatomic, copy) NSString *amountPayable;


/**实付金额*/
@property (nonatomic, copy) NSString *payAmount;


/**优惠券优惠金额*/
@property (nonatomic, copy) NSString *couponDerate;


/**门店优惠金额*/
@property (nonatomic, copy) NSString *shopDerate;


/**安装状态*/
@property (nonatomic, copy) NSString *installStatus;


/**收货人*/
@property (nonatomic, copy) NSString *shipPerson;


/**收货人电话*/
@property (nonatomic, copy) NSString *shipMobile;


/**收货人地址*/
@property (nonatomic, copy) NSString *shipAddress;


/**备注*/
@property (nonatomic, copy) NSString *comment;


/**退货状态*/
@property (nonatomic, copy) NSString *returnOrderStatus;

/**订单单品信息*/
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *orderProductList;

/**订单套餐*/
@property (nonatomic, strong) NSArray<CommonMealProdutcModel *> *orderSetMealList;



/**订单单品信息*/
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *orderGiftProductList;

/**订单套餐*/
@property (nonatomic, strong) NSArray<CommonMealProdutcModel *> *orderGiftSetMealList;

/**发货信息*/
@property (nonatomic, strong) NSArray *sendOrderInfoList;

/*订单状态*/
@property (nonatomic, copy) NSString *orderStatus;

/*订单状态名称*/
@property (nonatomic, copy) NSString *orderStatusText;


/*商品发货数量*/
@property (nonatomic, copy) NSString *deliverCount;

/**订单套餐*/
@property (nonatomic, strong) NSArray<XwActivityModel *> *activityIndexList;
@end




NS_ASSUME_NONNULL_END
