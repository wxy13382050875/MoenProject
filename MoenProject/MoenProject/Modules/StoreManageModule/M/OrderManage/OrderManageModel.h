//
//  OrderManageModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/4.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderItemInfoModel;
@interface OrderManageModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *createDate;

/**实退金额*/
@property (nonatomic, copy) NSString *actualRefundAmount;


@property (nonatomic, copy) NSString* productNum;

@property (nonatomic, assign) NSInteger giftNum;

@property (nonatomic, copy) NSString *payAmount;

@property (nonatomic, copy) NSString *recommender;


@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *returnOrderCode;

@property (nonatomic, strong) NSArray<OrderItemInfoModel *> *orderItemInfos;

@property (nonatomic, strong) NSArray<OrderItemInfoModel *> *productList;

@end


@interface OrderItemInfoModel : MoenBaseModel


@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *codeStr;

@property (nonatomic, copy) NSString *sku;

@end


@class OrderManageModel;
@interface OrderManageListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<OrderManageModel *> *orderList;

@property (nonatomic, strong) NSArray<OrderManageModel *> *returnOrderList;


@end




NS_ASSUME_NONNULL_END
