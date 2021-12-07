//
//  ReturnOrderDetailReasonTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
static  NSString *KReturnOrderDetailReasonTCell = @"ReturnOrderDetailReasonTCell";
static  NSString *KReturnOrderDetailReasonTCellForPickup = @"ReturnOrderDetailReasonTCellForPickup";
static  NSString *KReturnOrderDetailReasonTCellForRefund = @"ReturnOrderDetailReasonTCellForRefund";

static CGFloat KReturnOrderDetailReasonTCellH = 40;
NS_ASSUME_NONNULL_BEGIN

@interface ReturnOrderDetailReasonTCell : UITableViewCell


- (void)showDataWithString:(NSString *)reaseon;
- (void)showPickupWithString:(NSString *)pickupMethod;
- (void)showRefundWithString:(NSString *)refundMethod;
@end

NS_ASSUME_NONNULL_END
