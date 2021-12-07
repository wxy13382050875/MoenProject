//
//  MasterShippingManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MasterShippingManageVC : BaseViewController

/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;
/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

@end

NS_ASSUME_NONNULL_END
