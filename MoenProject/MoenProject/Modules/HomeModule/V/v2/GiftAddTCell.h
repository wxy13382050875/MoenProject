//
//  GiftAddTCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2020/1/2.
//  Copyright © 2020 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *KGiftAddTCell = @"GiftAddTCell";
static CGFloat KGiftAddTCellH = 40;
typedef void(^CellSelectedActionBlock)(void);


@interface GiftAddTCell : UITableViewCell

@property (nonatomic, copy) CellSelectedActionBlock cellSelectedActionBlock;

@end

NS_ASSUME_NONNULL_END
