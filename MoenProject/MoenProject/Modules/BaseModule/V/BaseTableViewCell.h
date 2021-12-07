//
//  BaseTableViewCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedActionBlock)(id model);

typedef void(^DetailActionBlock)(void);

@interface BaseTableViewCell : SKSTableViewCell

@property (nonatomic, copy) SelectedActionBlock selectedActionBlock;

@property (nonatomic, copy) DetailActionBlock detailActionBlock;

- (void)showDataWithModel:(id)dataModel withAtIndex:(NSInteger)atIndex;


@end

NS_ASSUME_NONNULL_END
