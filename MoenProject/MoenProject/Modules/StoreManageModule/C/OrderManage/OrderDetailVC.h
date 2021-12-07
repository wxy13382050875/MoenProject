//
//  OrderDetailVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseOrderManageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailVC : BaseViewController

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@property (nonatomic, copy) NSString *orderID;
@end

NS_ASSUME_NONNULL_END
