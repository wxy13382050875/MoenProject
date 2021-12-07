//
//  IntentionUnregisterTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnLabelUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntentionUnregisterTCell : UITableViewCell

- (void)showDataWithUnLabelUserInfoModel:(UnLabelUserInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
