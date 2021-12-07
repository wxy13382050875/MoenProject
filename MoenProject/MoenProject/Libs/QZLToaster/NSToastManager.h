//
//  XiangQuToastManager.h
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 yinchao. All rights reserved.
//

#import "MBProgressHUD.h"


@interface NSToastManager : NSObject
//管理
+ (instancetype)manager;

// 展示toast  toastStrt：提示内容
- (void)showtoast:(NSString *)toastStr;

// 展示toast
- (void)showprogress;

/**展示模态Loading框*/
- (void)showmodalityprogress;


// 隐藏 progress
- (void)hideprogress;



@end
