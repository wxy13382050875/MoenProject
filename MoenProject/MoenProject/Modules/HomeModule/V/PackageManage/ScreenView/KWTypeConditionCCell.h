//
//  KWTypeConditionCCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentTypeModel.h"
#import "OrderScreenSideslipView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KWTypeConditionCCell : UICollectionViewCell

- (void)showDataWithSegmentTypeModel:(SegmentTypeModel *)model;

- (void)showDataWithKWOSSVDataModel:(KWOSSVDataModel *)model;

/**选择客户标签*/
- (void)showDataWithSegmentTypeModelForSelectedTag:(SegmentTypeModel *)model;

@end

NS_ASSUME_NONNULL_END
