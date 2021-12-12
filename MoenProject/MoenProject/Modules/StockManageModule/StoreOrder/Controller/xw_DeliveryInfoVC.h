//
//  xw_DeliveryInfoVC.h
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"
#import "xwDeliveryInfoCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface xw_DeliveryInfoVC : BaseViewController

@property (nonatomic, assign) DeliveryWayType controllerType;
@property(nonatomic,strong)NSString* orderID;
@end

NS_ASSUME_NONNULL_END
