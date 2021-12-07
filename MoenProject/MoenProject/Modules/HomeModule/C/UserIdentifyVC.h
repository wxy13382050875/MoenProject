//
//  UserIdentifyVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserIdentifyVCType)
{
    /**卖货*/
    UserIdentifyVCTypeSaleGoods = 0,
    /**退货*/
    UserIdentifyVCTypeReturnGoods,
};

NS_ASSUME_NONNULL_BEGIN

@interface UserIdentifyVC : BaseViewController

@property (nonatomic, assign) UserIdentifyVCType controllerType;

@end

NS_ASSUME_NONNULL_END
