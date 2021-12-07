//
//  HomePageBannerCCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageBannerCCell : UICollectionViewCell

- (void)showDataWithHomeDataModel:(HomeDataModel *)model;
@end

NS_ASSUME_NONNULL_END
