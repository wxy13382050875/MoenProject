//
//  VerificatHelper.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SendCodeType)
{
    /**添加银行卡*/
    SendCodeTypeAddBankCard = 0,
    /**实名认证*/
    SendCodeTypeRealAuth,
    /**忘记密码*/
    SendCodeTypeForgetPassword,
    /**忘记手势密码*/
    SendCodeTypeForgetGesturePassword,
    /**提现*/
    SendCodeTypeDrawCrash,
    /**注册*/
    SendCodeTypeRegister,
    
    /**客户注册*/
    SendCodeTypeUserRegister,
    
    /**立即投资*/
    SendCodeTypePay,
};

/**验证码帮助类*/
@interface VerificatHelper : NSObject

- (id)initWithSendCodeType:(SendCodeType)sendCodeType withControlTarget:(UIButton *)controlTarget;

- (void)SendCodeAction:(NSString *)phoneNumber;

@property (nonatomic, strong) UITextField *nextTxt;

@end
