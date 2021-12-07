//
//  CouponRecordDetailTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponRecordDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponRecordDetailTCell : UITableViewCell

- (void)showDataWithCouponRecordDetailModel:(CouponRecordDetailModel *)model;


- (void)showDataWithAwardsDetailItemModel:(id)data;
@end

NS_ASSUME_NONNULL_END
