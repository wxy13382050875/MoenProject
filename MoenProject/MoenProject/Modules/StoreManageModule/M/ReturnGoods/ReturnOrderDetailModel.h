//
//  ReturnOrderDetailModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ReturnOrderDetailGoodsModel;
@interface ReturnOrderDetailModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *returnCode;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *custCode;

@property (nonatomic, copy) NSString *businessRole;

@property (nonatomic, copy) NSString *pickUpStatus;

@property (nonatomic, copy) NSString *paymentMethod;

@property (nonatomic, assign) NSInteger productCount;

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *otherReson;

@property (nonatomic, copy) NSString *refundAmount;

@property (nonatomic, copy) NSString *actualRefundAmount;


@property (nonatomic, strong) NSArray<ReturnOrderDetailGoodsModel *> *productList;



@end


@interface ReturnOrderDetailGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *photo;

@end




NS_ASSUME_NONNULL_END
