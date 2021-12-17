//
//  XwProblemInventoryVC.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/16.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"
#import "PurchaseOrderManageVC.h"
#import "XwOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XwProblemInventoryVC : BaseViewController
@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@property (nonatomic, strong) NSString* goodsType;
@property (nonatomic, strong) XwOrderDetailModel* model;
@end

NS_ASSUME_NONNULL_END
