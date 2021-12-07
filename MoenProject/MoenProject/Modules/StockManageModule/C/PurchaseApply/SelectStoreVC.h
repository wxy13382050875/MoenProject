//
//  ChangeStoreVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/12/30.
//  Copyright © 2019 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,ChangeStoreVCType)
{
    /**默认*/
    ChangeStoreVCTypeDefault = 0,
    /**初次登陆选择*/
    ChangeStoreVCTypeFromFirstLogin,

};

@interface SelectStoreVC : BaseViewController

@property (nonatomic, assign) ChangeStoreVCType controllerType;

@property (nonatomic, strong) NSMutableArray *dataArr;



@end

NS_ASSUME_NONNULL_END
