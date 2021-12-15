//
//  XwOrderDetailVC.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/5.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"
#import "PurchaseOrderManageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface XwOrderDetailVC : BaseViewController
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, assign) BOOL isDeliver;
@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@end


NS_ASSUME_NONNULL_END
