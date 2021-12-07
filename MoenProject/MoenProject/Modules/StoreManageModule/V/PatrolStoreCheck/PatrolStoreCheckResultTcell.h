//
//  PatrolStoreCheckResultTcell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolShopDetailModel.h"
#import "PatrolProblemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatrolStoreCheckResultTcell : UITableViewCell


- (void)showDataWithPatrolShopDetailModel:(PatrolShopDetailModel *)model;


- (void)showDataWithPatrolProblemModel:(PatrolProblemModel *)model;
@end

NS_ASSUME_NONNULL_END
