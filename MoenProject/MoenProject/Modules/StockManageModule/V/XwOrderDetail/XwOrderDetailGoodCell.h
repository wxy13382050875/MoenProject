//
//  XwOrderDetailGoodCell.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/11.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "XwOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^GoodsShowDetailBlock)(BOOL isShow);

@interface XwOrderDetailGoodCell : UITableViewCell
@property (nonatomic, copy) Goodslist* model;
@property (nonatomic, copy) Goodslist* delModel;


@property (nonatomic, copy) GoodsShowDetailBlock goodsShowDetailBlock;
@end

NS_ASSUME_NONNULL_END
