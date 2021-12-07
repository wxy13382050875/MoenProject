//
//  ReturnGoodsManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsManageVC : BaseViewController

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;
/**是否识别*/
@property (nonatomic, assign) BOOL isIdentify;

@end

NS_ASSUME_NONNULL_END
