//
//  ExchangeGoodsSelectVC.h
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "xw_BaseViewController.h"
#import "ExchangeGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectGoodsBlock)(GoodslistModel* model);
@interface ExchangeGoodsSelectVC : BaseViewController
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) SelectGoodsBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
