//
//Created by ESJsonFormatForMac on 21/12/05.
//

#import <Foundation/Foundation.h>
#import "xWStockOrderModel.h"
@interface XwOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderCreater;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, copy) NSString *orderRemarks;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *returnReason;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, copy) NSString *operator;

@property (nonatomic, copy) NSString *orderApplyProgress;

@property (nonatomic, copy) NSString *generalOrderProgress;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, strong) NSArray *sendOrderInfo;

@property (nonatomic, copy) NSString *wishReceiveDate;

@property (nonatomic, strong) NSArray *goodsList;

@end




