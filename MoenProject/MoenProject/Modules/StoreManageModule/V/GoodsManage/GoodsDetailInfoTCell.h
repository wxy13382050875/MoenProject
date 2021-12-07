//
//  GoodsDetailInfoTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailInfoTCell : UITableViewCell

- (void)showDataWithGoodsDetailModel:(GoodsDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
