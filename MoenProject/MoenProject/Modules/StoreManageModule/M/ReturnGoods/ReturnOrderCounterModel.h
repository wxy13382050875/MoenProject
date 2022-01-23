//
//  ReturnOrderCounterModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**退货柜台 数据模型*/

@class ReturnOrderCounterGoodsModel, CommonProdutcModel, CommonMealProdutcModel;
@interface ReturnOrderCounterModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *refundAmount;
@property (nonatomic, assign) NSInteger actualRefundAmount;


@property (nonatomic, assign) NSInteger returnCount;

@property (nonatomic, assign) NSInteger giftNum;

@property (nonatomic, strong) NSArray<ReturnOrderCounterGoodsModel *> *productList;

@property (nonatomic, strong) NSArray<CommonProdutcModel *> *giftProductInfos;

@property (nonatomic, strong) NSArray<CommonMealProdutcModel *> *giftOrderSetMealInfos;

@property (nonatomic, assign) CGFloat returnAmount;


@property (nonatomic, copy) NSString *markStr;



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

/**退货柜台 商品数据模型*/
@interface ReturnOrderCounterGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *orderItemProductId;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *refundAmount;
@property (nonatomic, copy) NSString *actualRefundAmount;

@property (nonatomic, copy) NSString *square;
/**是否特殊单品*/
@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, assign) CGFloat returnAmount;

/**退货数量*/
@property (nonatomic, assign) NSInteger canReturnCount;
@end

NS_ASSUME_NONNULL_END
