//
//  UserIdentifySuccessVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MembershipInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserIdentifySuccessVCType)
{
    //注册成功
    UserIdentifySuccessVCTypeRegister = 0,
    
    //识别成功
    UserIdentifySuccessVCTypeDistinguish
};

@interface UserIdentifySuccessVC : BaseViewController


@property (nonatomic, assign) UserIdentifySuccessVCType  controllerType;


@property (nonatomic, strong) MembershipInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
