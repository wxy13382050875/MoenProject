//
//  ChangeStoreTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/12/31.
//  Copyright © 2019 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeStoreTCell : UITableViewCell
@property(nonatomic,strong)UserLoginInfoModel* model;
@property(nonatomic,strong)UserLoginInfoModel* warehouseModel;
- (void)showDataWithUserLoginInfoModel:(UserLoginInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
