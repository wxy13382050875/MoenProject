//
//  StockQuerySkuVC.h
//  MoenProject
//
//  Created by wuxinyi on 2022/1/16.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshBlock)(NSString* goodsID);
@interface StockQuerySkuVC : BaseViewController
@property (nonatomic, copy) RefreshBlock refreshBlock;
@end

NS_ASSUME_NONNULL_END
