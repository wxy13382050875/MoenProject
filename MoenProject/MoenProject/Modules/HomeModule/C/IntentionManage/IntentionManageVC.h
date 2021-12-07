//
//  IntentionManageVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IntentionManageVCTyep)
{
    IntentionManageVCTypeDefault = 0,
    IntentionManageVCTypeWithHeader,
};
/**意向管理*/
@interface IntentionManageVC : BaseViewController

//门店人员id
@property (nonatomic, copy) NSString *personalId;

@property (nonatomic, assign) IntentionManageVCTyep controllerType;

@end

NS_ASSUME_NONNULL_END
