//
//  XwImproveReservationVC.h
//  MoenProject
//
//  Created by 武新义 on 2022/8/29.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XwImproveReservationVC : BaseViewController

/**订单ID*/
@property (nonatomic, copy) NSString *orderID;

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;
@end

NS_ASSUME_NONNULL_END
