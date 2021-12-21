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
typedef void(^RefreshBlock)();
@interface XwOrderDetailVC : BaseViewController
@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@property (nonatomic, copy) RefreshBlock refreshBlock;
@end


NS_ASSUME_NONNULL_END
