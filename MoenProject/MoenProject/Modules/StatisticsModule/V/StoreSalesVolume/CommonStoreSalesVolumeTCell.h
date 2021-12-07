//
//  CommonStoreSalesVolumeTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreSalesVolumeModel.h"
#import "StoreSalesPersonalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonStoreSalesVolumeTCell : UITableViewCell


- (void)showDataWithStoreSalesVolumeModel:(StoreSalesVolumeModel *)model WithIsToday:(BOOL)isTodayBest;


- (void)showDataWithStoreSalesPersonalModel:(StoreSalesPersonalModel *)model;
@end

NS_ASSUME_NONNULL_END
