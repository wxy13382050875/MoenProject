//
//  StoreActivityVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StoreActivityVCType)
{
    StoreActivityVCCurrent = 0, //当前的门店活动
    StoreActivityVCHistory,      //门店活动历史信息
    StoreActivityVCPersonal,     //客户活动
};

NS_ASSUME_NONNULL_BEGIN

@interface StoreActivityVC : BaseViewController

@property (nonatomic, assign) StoreActivityVCType controllerType;

/**用户ID StoreActivityVCPersonal需要*/
@property (nonatomic, copy) NSString *customerId;

@end

NS_ASSUME_NONNULL_END
