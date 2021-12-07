//
//  UserIdentifySuccessCCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MembershipInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserIdentifySuccessCCell : UICollectionViewCell

- (void)showDataWithMembershipInfoModel:(MembershipInfoModel *)model WithControllerType:(NSInteger)controllerType;
@end

NS_ASSUME_NONNULL_END
