//
//  LoginVC.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LoginVCType)
{
    /**登录*/
    LoginVCType_login = 0,
    /**验证码登录*/
    LoginVCType_login_with_code,
    /**忘记密码*/
    LoginVCType_forget,
    /**修改密码*/
    LoginVCType_change,
};

@interface LoginVC : BaseViewController

@property (nonatomic, assign) LoginVCType controllerType;

/**是否是首次登陆呈现*/
@property (nonatomic, assign) BOOL isFirstShow;

@end
