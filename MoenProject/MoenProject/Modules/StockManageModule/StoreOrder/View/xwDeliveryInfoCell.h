//
//  xwDeliveryInfoCell.h
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_BaseTableViewCell.h"
typedef NS_ENUM(NSInteger,DeliveryActionType)
{
    DeliveryActionTypeFirst = 0,//首次
    DeliveryActionTypeOther
};
NS_ASSUME_NONNULL_BEGIN
static NSString *KxwDeliveryInfoCell = @"xwDeliveryInfoCell";
static CGFloat KXwDeliveryInfoCellH = 230;
static CGFloat KXwDeliveryInfoCellFristH = 200;
@interface xwDeliveryInfoCell : xw_BaseTableViewCell
@property (nonatomic, assign) DeliveryActionType deliveryType;
@end

NS_ASSUME_NONNULL_END
