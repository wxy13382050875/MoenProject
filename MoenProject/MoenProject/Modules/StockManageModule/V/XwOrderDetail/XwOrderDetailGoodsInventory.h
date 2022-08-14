//
//  XwOrderDetailGoodsInventory.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XwOrderDetailModel.h"
#import "PurchaseOrderManageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface XwOrderDetailGoodsInventory : UITableViewCell
@property(nonatomic,strong)Goodslist* model;
@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@end

NS_ASSUME_NONNULL_END
