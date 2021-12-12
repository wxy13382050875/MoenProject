//
//  xwDeliveryInfoCell.h
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_BaseTableViewCell.h"
#import "XwUpdateDeliveryModel.h"
typedef NS_ENUM(NSInteger,DeliveryActionType)
{
    DeliveryActionTypeFirst = 0,//首次
    DeliveryActionTypeOther
};
typedef NS_ENUM(NSInteger, DeliveryWayType)
{
    /**总仓发货*/
    DeliveryWayTypeStocker,
    /**门店自提*/
    DeliveryWayTypeShopSelf,
};
NS_ASSUME_NONNULL_BEGIN
static NSString *KxwDeliveryInfoCell = @"xwDeliveryInfoCell";
static CGFloat KXwDeliveryInfoCellH = 155;
static CGFloat KXwDeliveryInfoCellFristH = 190;
@interface xwDeliveryInfoCell : xw_BaseTableViewCell
@property (nonatomic, assign) DeliveryActionType deliveryType;
@property (nonatomic, strong) Orderproductinfodatalist* model;
@property (nonatomic, assign) DeliveryWayType controllerType;

@end

NS_ASSUME_NONNULL_END
