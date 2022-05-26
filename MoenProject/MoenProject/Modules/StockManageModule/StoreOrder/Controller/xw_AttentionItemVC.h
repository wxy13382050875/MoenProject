//
//  xw_AttentionItem.h
//  MoenProject
//
//  Created by wuxinyi on 2022/3/22.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "xw_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshAttentionBlock)(NSArray* array);
@interface xw_AttentionItemVC : BaseViewController
@property (nonatomic, copy) RefreshAttentionBlock refreshBlock;
@property (nonatomic, strong) NSArray *activityIndexIdList;

@property (nonatomic, assign) BOOL isDetail;
@end

NS_ASSUME_NONNULL_END
