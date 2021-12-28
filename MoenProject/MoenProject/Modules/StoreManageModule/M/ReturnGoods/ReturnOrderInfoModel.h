//
//  ReturnOrderInfoModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class ReturnOrderSingleGoodsModel,ReturnOrderMealGoodsModel, CommonProdutcModel, CommonMealProdutcModel;
@interface ReturnOrderInfoModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *createUser;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *businessRole;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *returnCount;
@property (nonatomic, assign) NSInteger giftNum;


@property (nonatomic, copy) NSString *refundAmount;

/**订单的实际退款金额*/
@property (nonatomic, assign) NSInteger actualRefundAmount;

@property (nonatomic, copy) NSString *markStr;




@property (nonatomic, strong) NSArray<ReturnOrderSingleGoodsModel *> *productList;

@property (nonatomic, strong) NSArray<ReturnOrderMealGoodsModel *> *setMealList;


//赠品
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *giftProductInfos;

@property (nonatomic, strong) NSArray<CommonMealProdutcModel *> *giftOrderSetMealInfos;


/**提货状态*/
@property (nonatomic, copy) NSString *pickUpStatus;
/**提货状态*/
@property (nonatomic, copy) NSString *pickUpStatusID;

/**退款方式*/
@property (nonatomic, copy) NSString *returnMethod;
/**退款方式*/
@property (nonatomic, copy) NSString *returnMethodID;

/**退款原因*/
@property (nonatomic, copy) NSString *returnReason;
/**退款*/
@property (nonatomic, copy) NSString *returnReasonID;


@end

@interface ReturnOrderSingleGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *refundAmount;

/**实际退款金额*/
@property (nonatomic, copy) NSString *actualRefundAmount;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *orderItemProductId;

/**退货数量*/
@property (nonatomic, assign) NSInteger returnCount;

@property (nonatomic, copy) NSString *square;

@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, copy) NSString *sendInfo;

@end


@class ReturnOrderSingleGoodsModel;
@interface ReturnOrderMealGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *mealCode;

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, copy) NSString *comboName;

@property (nonatomic, copy) NSString *comboDescribe;

@property (nonatomic, copy) NSString *orderItemProductId;

@property (nonatomic, copy) NSString *square;

@property (nonatomic, assign) NSInteger count;

/**退货数量*/
@property (nonatomic, assign) NSInteger returnCount;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *refundAmount;

@property (nonatomic, copy) NSString *actualRefundAmount;

@property (nonatomic, assign) BOOL isSpecial;
/** 是否套餐*/
@property (nonatomic, assign) BOOL isSetMeal;
/** 是否套餐*/
@property (nonatomic, assign) BOOL isShowDetail;

/** 是否套餐*/
@property (nonatomic, copy) NSString * waitDeliverCount;
/** 是否套餐*/
@property (nonatomic, copy) NSString * deliverCount;


@property (nonatomic, strong) NSArray<ReturnOrderSingleGoodsModel *> *productList;

@end



NS_ASSUME_NONNULL_END
