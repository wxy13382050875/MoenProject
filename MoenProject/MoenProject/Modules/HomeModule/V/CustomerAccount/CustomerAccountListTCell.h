//
//  CustomerAccountListTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponInfoModel.h"
#import "StoreActivityDetailModel.h"


static NSString *KCustomerAccountListTCell = @"CustomerAccountListTCell";
static CGFloat KCustomerAccountListTCellHeight = 86;
static CGFloat KCustomerAccountListRefTCellHeight = 124;
/**
 *  选择事件回调
 *  clickType 0、选择类型  1、详情类型
 */
typedef void(^CustomerAccountListTCellSelectedBlock)(NSInteger clickType, NSInteger atIndex, BOOL isShowDetail);

NS_ASSUME_NONNULL_BEGIN

@interface CustomerAccountListTCell : UITableViewCell


- (void)showDataWithCouponInfoModel:(CouponInfoModel *)model WithIsEdit:(BOOL)isEdit AtIndex:(NSInteger)atIndex IsShowRef:(BOOL)isShowRef;

- (void)showDataWithStoreActivityCouponInfoModel:(StoreActivityCouponInfoModel *)model WithIsEdit:(BOOL)isEdit AtIndex:(NSInteger)atIndex;

@property (nonatomic, copy) CustomerAccountListTCellSelectedBlock selectedActionBlock;

@end

NS_ASSUME_NONNULL_END
