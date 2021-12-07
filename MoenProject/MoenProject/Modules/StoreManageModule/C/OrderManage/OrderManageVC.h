//
//  OrderManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, OrderManageVCType)
{
    /**ALL全部*/
    OrderManageVCTypeDefault = 0,
    /**GROOM:推荐订单*/
    OrderManageVCTypeGROOM,
    /**MAJOR:专业*/
    OrderManageVCTypeMAJOR,
};
NS_ASSUME_NONNULL_BEGIN

@interface OrderManageVC : BaseViewController

/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;
/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, assign) OrderManageVCType controllerType;

@end

NS_ASSUME_NONNULL_END
