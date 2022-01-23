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

@property (nonatomic, copy) NSString *orderTimeStart;

@property (nonatomic, copy) NSString *orderTimeEnd;

@property (nonatomic, copy) NSString *operator;

@property (nonatomic, copy) NSString *orderApplyProgress;

@property (nonatomic, copy) NSString *generalOrderProgress;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *orderStatusText;

@property (nonatomic, copy) NSString *progressName;

@property (nonatomic, copy) NSString *wishReceiveDate;

@property (nonatomic, strong) NSArray *goodsList;

@property (nonatomic, strong) NSArray *sendOrderInfo;

@property (nonatomic, copy) NSString *checkRemarks;

@property (nonatomic, copy) NSString *taskID;
//发货单详情
@property (nonatomic, copy) NSString *sendOrderStatus;

@property (nonatomic, copy) NSString *sendOrderTime;

@property (nonatomic, copy) NSString *businessMark;

@property (nonatomic, copy) NSString *sendOrderID;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *senderKey;

@property (nonatomic, copy) NSString *ordeID;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *goodsType;

//AD审核信息
@property (nonatomic, copy) NSString *adRemarks;
//门店审核信息
@property (nonatomic, copy) NSString *shopRemarks;
//快递单号
@property (nonatomic, copy) NSString *expressCode;
//总仓任务详情备注
@property (nonatomic, copy) NSString *remarks;


@end




