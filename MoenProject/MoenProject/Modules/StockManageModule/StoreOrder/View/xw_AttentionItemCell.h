//
//  xw_AttentionItemCell.h
//  MoenProject
//
//  Created by wuxinyi on 2022/3/22.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "xw_BaseTableViewCell.h"
#import "XwActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface xw_AttentionItemCell : UITableViewCell
@property (nonatomic, strong) XwActivityModel* model;
@property (nonatomic, assign) BOOL isEnabled;
@end

NS_ASSUME_NONNULL_END
