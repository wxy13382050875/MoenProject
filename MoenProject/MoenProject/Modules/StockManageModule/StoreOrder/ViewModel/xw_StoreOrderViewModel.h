//
//  xw_StoreOrderViewModel.h
//  MoenProject
//
//  Created by wuxinyi on 2021/9/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface xw_StoreOrderViewModel : xw_BaseViewModel
@property (nonatomic,strong) RACCommand * requestCommand;
@end

NS_ASSUME_NONNULL_END
