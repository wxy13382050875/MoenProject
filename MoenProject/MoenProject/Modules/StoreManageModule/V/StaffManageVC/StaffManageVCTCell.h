//
//  StaffManageVCTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopStaffModel.h"

typedef void(^StaffManageVCTCellStopBlock)(NSInteger userID);

NS_ASSUME_NONNULL_BEGIN

@interface StaffManageVCTCell : UITableViewCell


- (void)showDataWithShopStaffModel:(ShopStaffModel *)model WithStopBlock:(StaffManageVCTCellStopBlock)stopBlock;

@end

NS_ASSUME_NONNULL_END
