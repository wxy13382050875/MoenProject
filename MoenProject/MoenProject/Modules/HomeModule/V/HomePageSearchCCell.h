//
//  HomePageSearchCCell.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomePageSearchCCellSearchBlock)(NSString* searchStr);

NS_ASSUME_NONNULL_BEGIN

@interface HomePageSearchCCell : UICollectionViewCell

@property (nonatomic, copy) HomePageSearchCCellSearchBlock searchBlock;

@property (nonatomic, assign) BOOL isClearContent;

@end

NS_ASSUME_NONNULL_END
