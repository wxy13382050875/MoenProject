//
//  OrderOperationSuccessVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderOperationSuccessVCType)
{
    OrderOperationSuccessVCTypePlacing = 0, //下单
    OrderOperationSuccessVCTypeReturn ,      //退单
    OrderOperationSuccessVCTypeStockSave,      //进货单保存
    OrderOperationSuccessVCTypeStockSubmit,      //进货单提交
    OrderOperationSuccessVCTypeTransfersSave,      //调拔单保存
    OrderOperationSuccessVCTypeTransfersSubmit,      //调拔单提交
};

NS_ASSUME_NONNULL_BEGIN

@interface OrderOperationSuccessVC : BaseViewController

@property (nonatomic, assign) OrderOperationSuccessVCType controllerType;
@property (nonatomic, copy) NSString *orderID;

/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;

/**客户ID*/
@property (nonatomic, copy) NSString* customerId;

@end

NS_ASSUME_NONNULL_END
