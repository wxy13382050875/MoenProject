//
//  StoreActivityListTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreActivityDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface StoreActivityListTCell : UITableViewCell



- (void)showDataWithStoreActivityDetailModel:(StoreActivityDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
