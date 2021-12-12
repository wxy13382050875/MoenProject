//
//  Xw_SelectWarehouseVC.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/12.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^operationBlock)(NSString*returnAddress, NSString* stockeId);
@interface Xw_SelectWarehouseVC : BaseViewController
@property (nonatomic, copy) operationBlock operaBlock;
@end

NS_ASSUME_NONNULL_END
