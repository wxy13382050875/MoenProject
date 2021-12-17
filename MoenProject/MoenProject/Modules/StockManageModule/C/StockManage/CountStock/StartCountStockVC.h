//
//  StartCountStockVC.h
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseOrderManageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface StartCountStockVC : BaseViewController
@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;
@property(nonatomic,strong)NSString* goodsType;
@end

NS_ASSUME_NONNULL_END
