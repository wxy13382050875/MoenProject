//
//  SelectedTagVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MembershipInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectedTagVCType)
{
    //默认状态
    SelectedTagVCTypeCommon = 0,
    
    //注册成功后自动进入状态
    SelectedTagVCTypeFromRegister
};

@interface SelectedTagVC : BaseViewController


@property (nonatomic, assign) SelectedTagVCType controllerType;

@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, strong) MembershipInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
