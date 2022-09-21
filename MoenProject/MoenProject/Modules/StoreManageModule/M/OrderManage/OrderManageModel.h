//
//  OrderManageModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/4.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@class OrderItemInfoModel,CommonGoodsModel;
@interface OrderManageModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *createDate;

/**实退金额*/
@property (nonatomic, copy) NSString *actualRefundAmount;


@property (nonatomic, copy) NSString* productNum;

@property (nonatomic, copy) NSString* giftNum;

@property (nonatomic, copy) NSString *payAmount;

@property (nonatomic, copy) NSString *recommender;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, assign) BOOL wholeOtherReturn;//添加是否可以整单退货字段/类型：Boolean  必有字段  备注：二期新增，是否可以整单退货，true可以，false 不可以。提示 本订单存在总仓预约商品，请终止后再进行退货
@property (nonatomic, copy) NSString *isAppointment;


@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *returnOrderCode;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, strong) NSArray<OrderItemInfoModel *> *orderItemInfos;

@property (nonatomic, strong) NSArray<OrderItemInfoModel *> *productList;

@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderSetMealList;
//
@property (nonatomic, strong) NSArray<CommonGoodsModel *> *orderProductList;
@end


@interface OrderItemInfoModel : MoenBaseModel


@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *codeStr;

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, copy) NSString *count;

@end


@class OrderManageModel;
@interface OrderManageListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<OrderManageModel *> *orderList;

@property (nonatomic, strong) NSArray<OrderManageModel *> *returnOrderList;


@end




NS_ASSUME_NONNULL_END
