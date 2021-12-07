//
//  LoginVC.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/15.
//

#import "LoginVC.h"
#import "UIViewController+HeightAdjustKeyBorad.h"
#import "LoginInfoModel.h"
#import "VerificatHelper.h"
#import "CommonSkipHelper.h"
#import "ChangeStoreVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *return_Btn;

//登录
@property (weak, nonatomic) IBOutlet UIView *login_View;
@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;
@property (weak, nonatomic) IBOutlet UITextField *password_Txt;
@property (weak, nonatomic) IBOutlet UIButton *login_Btn;
@property (weak, nonatomic) IBOutlet UIButton *loginway_change_Btn;
@property (weak, nonatomic) IBOutlet UIButton *forget_Btn;
@property (weak, nonatomic) IBOutlet UIView *code_login_line_View;
@property (weak, nonatomic) IBOutlet UIButton *code_login_send_Btn;

//忘记密码
@property (weak, nonatomic) IBOutlet UIView *forget_View;
@property (weak, nonatomic) IBOutlet UITextField *phone_Second_Txt;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *code_Txt;
@property (weak, nonatomic) IBOutlet UITextField *password_Second_Txt;
@property (weak, nonatomic) IBOutlet UITextField *rePassword_Txt;
@property (weak, nonatomic) IBOutlet UIButton *confirm_Btn;

//修改密码
@property (weak, nonatomic) IBOutlet UIView *passwordChangeView;
@property (weak, nonatomic) IBOutlet UITextField *change_oldpassword_Txt;
@property (weak, nonatomic) IBOutlet UITextField *change_newpassword_Txt;
@property (weak, nonatomic) IBOutlet UITextField *change_renewpassword_Txt;
@property (weak, nonatomic) IBOutlet UIButton *change_confirm_Btn;

@property (nonatomic, strong) VerificatHelper *verificatHelper;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phone_Txt.font = FONTLanTingR(15);
    self.password_Txt.font = FONTLanTingR(15);
    self.login_Btn.titleLabel.font = FONTLanTingR(17);
    self.loginway_change_Btn.titleLabel.font = FONTLanTingR(15);
    self.forget_Btn.titleLabel.font = FONTLanTingR(15);
    self.code_login_send_Btn.titleLabel.font = FONTLanTingR(14);
    
    self.phone_Second_Txt.font = FONTLanTingR(15);
    self.code_Txt.font = FONTLanTingR(15);
    self.password_Second_Txt.font = FONTLanTingR(15);
    self.rePassword_Txt.font = FONTLanTingR(15);
    self.confirm_Btn.titleLabel.font = FONTLanTingR(17);
    self.getCodeBtn.titleLabel.font = FONTLanTingR(14);
    
    
    self.change_oldpassword_Txt.font = FONTLanTingR(15);
    self.change_newpassword_Txt.font = FONTLanTingR(15);
    self.change_renewpassword_Txt.font = FONTLanTingR(15);
    self.change_confirm_Btn.titleLabel.font = FONTLanTingR(17);
    
    
    
    [self BaseUIConfig];
    [self viewPositionAdjustKeyboard];
}

- (void)dealloc
{
    if (self.controllerType == LoginVCType_login) {
        [QZLUserConfig sharedInstance].isLogining = NO;
    }
}

- (void)BaseUIConfig
{
    if (self.controllerType == LoginVCType_login) {
        [self.return_Btn setHidden:YES];
        [self.login_View setHidden:NO];
        self.phone_Txt.delegate = self;
        self.password_Txt.delegate = self;
        

//        15641193024 - 000000
//        18980808085 - 000000
//        15123130000 - 000000
//        13740197911 - 000000
//        15500000000 - qwerty
        
//        店长：18224568785，密码：123456
//        导购：15998437034，密码：000000
//        18101399087
//        13740188188
//        15602035888 000000
        
//        15900009000   000000
//        18101399087   123456
//        self.phone_Txt.text = @"15900009000";
//        self.password_Txt.text = @"000000";
    }
    else if (self.controllerType == LoginVCType_login_with_code)
    {
        [self.login_View setHidden:NO];
        self.phone_Txt.delegate = self;
        self.password_Txt.delegate = self;
        self.password_Txt.keyboardType = UIKeyboardTypeNumberPad;
        self.password_Txt.placeholder = NSLocalizedString(@"c_enter_validation_code", nil);
        self.password_Txt.secureTextEntry = NO;
        self.password_Txt.sd_width = 150;
        [self.code_login_line_View setHidden:NO];
        [self.code_login_send_Btn setHidden:NO];
        [self.forget_Btn setHidden:YES];
        [self.loginway_change_Btn setTitle:NSLocalizedString(@"c_login_with_password", nil) forState:UIControlStateNormal];
        
//        self.self.phone_Txt.text = @"15641193021";
    }
    else if (self.controllerType == LoginVCType_forget)
    {
        [self.forget_View setHidden:NO];
        self.phone_Second_Txt.delegate = self;
        self.code_Txt.delegate = self;
        self.password_Second_Txt.delegate = self;
        self.rePassword_Txt.delegate = self;
        self.password_Second_Txt.keyboardType = UIKeyboardTypeDefault;
        self.rePassword_Txt.keyboardType = UIKeyboardTypeDefault;
        [self.confirm_Btn setTitle:NSLocalizedString(@"c_confirm_submit", nil) forState:UIControlStateNormal];
//        self.phone_Second_Txt.text = @"15641193021";
    }
    else if (self.controllerType == LoginVCType_change)
    {
        self.change_oldpassword_Txt.delegate = self;
        self.change_newpassword_Txt.delegate = self;
        self.change_renewpassword_Txt.delegate = self;
        self.change_oldpassword_Txt.keyboardType = UIKeyboardTypeDefault;
        self.change_newpassword_Txt.keyboardType = UIKeyboardTypeDefault;
        self.change_renewpassword_Txt.keyboardType = UIKeyboardTypeDefault;
        [self.passwordChangeView setHidden:NO];
    }
}

#pragma Mark -- Event Response
/**关闭 LoginVC*/
- (IBAction)CloseAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- 登录
/**登录Api*/
- (IBAction)LoginAction:(UIButton *)sender {
    

    NSString *noticeStr = @"";
    
    if (self.controllerType == LoginVCType_login_with_code) {
        if (self.phone_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
        }
        else if (![Utils checkTelNumber:self.phone_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
        }
        else if (self.password_Txt.text.length < 6) {
            noticeStr = NSLocalizedString(@"t_please_enter_validation_code", nil);
        }
    }
    else
    {
        if (self.phone_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
        }
        else if (![Utils checkTelNumber:self.phone_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
        }
        else if (self.password_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_password", nil);
        }
        else if (![Utils checkPassword:self.password_Txt.text])
        {
            noticeStr = NSLocalizedString(@"t_please_enter_correct_password", nil);
        }
    }

    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
        
    }else{
        if (self.controllerType == LoginVCType_login_with_code)
        {
            [self httpPath_login_selectWithLoginType:@"code"];
        }
        else
        {
            [self httpPath_login_selectWithLoginType:@"password"];
        }
    }
}

#pragma  mark -- 切换登录方式
/**切换登录方式 点击事件*/
- (IBAction)RegistAction:(UIButton *)sender {
    
    if (self.controllerType == LoginVCType_login) {
        LoginVC *login = [[LoginVC alloc] init];
        login.controllerType = LoginVCType_login_with_code;
        [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:login animated:YES completion:nil];
    }
    else if (self.controllerType == LoginVCType_forget) {
        
        NSString *noticeStr = @"";
        if (self.phone_Second_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
        }
        else if (![Utils checkTelNumber:self.phone_Second_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
        }
        else if (self.code_Txt.text.length < 6) {
            noticeStr = NSLocalizedString(@"t_please_enter_validation_code", nil);
        }
        else if (self.password_Second_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_new_password", nil);
        }
        else if (![Utils checkPassword:self.password_Second_Txt.text])
        {
            noticeStr = NSLocalizedString(@"t_please_enter_correct_new_password", nil);
        }
        else if (self.rePassword_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_confirm_password", nil);
        }
        else if (![Utils checkPassword:self.rePassword_Txt.text])
        {
            noticeStr = NSLocalizedString(@"t_please_enter_correct_confirm_password", nil);
        }
        else if (![self.password_Second_Txt.text isEqualToString:self.rePassword_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_inconsistent_passwords", nil);
        }
        if (noticeStr.length) {
            [[NSToastManager manager] showtoast:noticeStr];
        }else{
            [self httpPath_forgetPassword];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)changeConfirmAction:(UIButton *)sender {
    
    NSString *noticeStr = @"";
    if (self.change_oldpassword_Txt.text.length == 0) {
        noticeStr = NSLocalizedString(@"t_please_enter_original_password", nil);
    }
    else if (![Utils checkPassword:self.change_oldpassword_Txt.text])
    {
        noticeStr = NSLocalizedString(@"t_please_enter_correct_original_password", nil);
    }
    else if (self.change_newpassword_Txt.text.length == 0) {
        noticeStr = NSLocalizedString(@"t_please_enter_new_password", nil);
    }
    else if (![Utils checkPassword:self.change_newpassword_Txt.text])
    {
        noticeStr = NSLocalizedString(@"t_please_enter_correct_new_password", nil);
    }
    else if (self.change_renewpassword_Txt.text.length == 0) {
        noticeStr = NSLocalizedString(@"t_please_enter_password", nil);
    }
    else if (![Utils checkPassword:self.change_renewpassword_Txt.text])
    {
        noticeStr = NSLocalizedString(@"t_please_enter_correct_password", nil);
    }
    else if (![self.change_newpassword_Txt.text isEqualToString:self.change_renewpassword_Txt.text]) {
        noticeStr = NSLocalizedString(@"t_inconsistent_passwords", nil);
    }
    
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
    }else{
        [self httpPath_changePassword];
    }
}


#pragma mark -- 忘记密码
/**忘记密码*/
- (IBAction)ForgetAction:(UIButton *)sender {
    LoginVC *login = [[LoginVC alloc] init];
    login.controllerType = LoginVCType_forget;
    [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:login animated:YES completion:nil];
}

/**获取验证码  验证码登录  忘记密码*/
- (IBAction)SendCodeAction:(UIButton *)sender {
    
    NSString *noticeStr = @"";
    if (self.controllerType == LoginVCType_login_with_code) {
        if (self.phone_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
        }
        else if (![Utils checkTelNumber:self.phone_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
        }
    }
    else
    {
        if (self.phone_Second_Txt.text.length == 0) {
            noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
        }
        else if (![Utils checkTelNumber:self.phone_Second_Txt.text]) {
            noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
        }
    }
    
    
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
        
    }else{
        
         if (self.controllerType == LoginVCType_login_with_code) {
            [self.verificatHelper SendCodeAction:self.phone_Txt.text];
         }
        else
        {
            [self.verificatHelper SendCodeAction:self.phone_Second_Txt.text];
        }
        
    }
}


#pragma Mark -- UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.phone_Txt) {
        
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_Second_Txt ||
        textField == self.phone_Txt) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    if (textField == self.code_Txt) {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    
    if (self.controllerType == LoginVCType_login) {
        if (textField == self.password_Txt) {
            if (textField.text.length >= 20 && ![string isEqualToString:@""]) {
                return NO;
            }
        }
    }
    else
    {
        if (textField == self.password_Txt) {
            if (textField.text.length >= 6 && ![string isEqualToString:@""]) {
                return NO;
            }
        }
    }
    
    
    if (textField == self.password_Second_Txt ||
        textField == self.rePassword_Txt ||
        textField == self.change_oldpassword_Txt ||
        textField == self.change_newpassword_Txt ||
        textField == self.change_renewpassword_Txt) {
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"t_request_error", nil)];
        if ([operation.urlTag isEqualToString:Path_oauth_token]) {
//            [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_login_sendsmscode]) {
                
            }
            else if ([operation.urlTag isEqualToString:Path_forgetPassword])
            {
                LoginInfoModel *model = (LoginInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                   [[NSToastManager manager] showtoast:NSLocalizedString(@"t_successful_password_modification", nil)];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            else if ([operation.urlTag isEqualToString:Path_oauth_token]) {
                LoginInfoModel *model = (LoginInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [QZLUserConfig sharedInstance].token = model.access_token;
                    [QZLUserConfig sharedInstance].isLoginIn = YES;
                    [self httpPath_getUserConfig];                    
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            else if ([operation.urlTag isEqualToString:Path_getUserConfig])
            {
                UserLoginInfoModelList *listModel = (UserLoginInfoModelList *)parserObject;
                
                if ([listModel.code isEqualToString:@"200"]) {
                    self.password_Txt.text = @"";
                    [QZLUserConfig sharedInstance].loginPhone = self.phone_Txt.text;
                    if (listModel.userConfigDataList.count == 1) {
                        UserLoginInfoModel *model = listModel.userConfigDataList[0];
                        [QZLUserConfig sharedInstance].userRole = model.userRole;
                        [QZLUserConfig sharedInstance].dealerId = model.dealerId;
                        [QZLUserConfig sharedInstance].dealerName = model.dealerName;
                        [QZLUserConfig sharedInstance].shopId = model.shopId;
                        [QZLUserConfig sharedInstance].shopName = model.shopName;
                        [QZLUserConfig sharedInstance].employeeId = model.employeeId;
                        [QZLUserConfig sharedInstance].isMultipleStores = NO;

                        if (!self.isFirstShow) {
                            [self dismissViewControllerAnimated:NO completion:^{
                                [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
                            }];
                        }
                        else
                        {
                            [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
                        }
                    }
                    else if(listModel.userConfigDataList.count > 1)
                    {
                        [QZLUserConfig sharedInstance].isMultipleStores = YES;
                        dispatch_async(dispatch_get_main_queue(),^{
                        //选择门店
                            ChangeStoreVC *changeStoreVC = [[ChangeStoreVC alloc] init];
                            changeStoreVC.dataArr = [listModel.userConfigDataList mutableCopy];
                            changeStoreVC.modalPresentationStyle = 0;
                            changeStoreVC.controllerType = self.isFirstShow ? ChangeStoreVCTypeFromFirstLogin:ChangeStoreVCTypeDefault;
                            [self presentViewController:changeStoreVC animated:YES completion:nil];
                        });
                    }
                    else
                    {
                        [[NSToastManager manager] showtoast:@"用户暂不属于任何门店"];
                    }
                }
                else
                {
                    [[NSToastManager manager] showtoast:listModel.message];
                }
            }
            else if ([operation.urlTag isEqualToString:Path_changePassword])
            {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [QZLUserConfig sharedInstance].token = @"";
                    [QZLUserConfig sharedInstance].isLoginIn = NO;
                    [QZLUserConfig sharedInstance].shopId = @"";
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"t_successful_password_modification", nil)];
                    [self dismissViewControllerAnimated:NO completion:^{
                        //退出登录
                        LoginVC *loginVC = [[LoginVC alloc] init];
                        loginVC.controllerType = LoginVCType_login;
                        [[UIViewController currentViewController] presentViewController:loginVC animated:YES completion:nil];
                    }];
                }
            }
        }
    }
}

/**修改密码Api*/
- (void)httpPath_changePassword
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[TransCodingHelper SHA256:self.change_oldpassword_Txt.text] forKey:@"originalPassword"];
    [parameters setValue:[TransCodingHelper SHA256:self.change_newpassword_Txt.text] forKey:@"newPassword"];
    [parameters setValue:[TransCodingHelper SHA256:self.change_renewpassword_Txt.text] forKey:@"confirmNewPassword"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_changePassword;
}

/**忘记密码Api*/
- (void)httpPath_forgetPassword
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.phone_Second_Txt.text forKey:@"phone"];
    [parameters setValue:self.code_Txt.text forKey:@"checkCode"];
    [parameters setValue:[TransCodingHelper SHA256:self.password_Second_Txt.text] forKey:@"newPassword"];
    [parameters setValue:[TransCodingHelper SHA256:self.rePassword_Txt.text] forKey:@"confirmNewPassword"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_forgetPassword;
}

/**登录Api*/
- (void)httpPath_login_selectWithLoginType:(NSString *)LoginType
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([LoginType isEqualToString:@"password"]) {
        [parameters setValue:self.phone_Txt.text forKey:@"username"];
        [parameters setValue:[TransCodingHelper SHA256:self.password_Txt.text] forKey:@"password"];
        if ([self.phone_Txt.text isEqualToString:@"18101399087"]) {
            [QZLUserConfig sharedInstance].isTestEnter = YES;
        }
        else
        {
            [QZLUserConfig sharedInstance].isTestEnter = NO;
        }
    }
    else
    {
        [parameters setValue:[NSString stringWithFormat:@"%@__%@",self.phone_Txt.text,self.password_Txt.text] forKey:@"username"];
        [parameters setValue:self.password_Txt.text forKey:@"password"];
        [QZLUserConfig sharedInstance].isTestEnter = NO;
    }
    
    [parameters setValue:@"app" forKey:@"client_id"];
    [parameters setValue:@"appSecret" forKey:@"client_secret"];
    [parameters setValue:@"password" forKey:@"grant_type"];
    self.requestType = YES;
    self.requestParams = parameters;
    self.requestURL = Path_oauth_token;
}

/**获取登录用户信息Api*/
- (void)httpPath_getUserConfig
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getUserConfig;
}




#pragma Mark- getters and setters
- (VerificatHelper *)verificatHelper
{
    if (!_verificatHelper) {
        if (self.controllerType == LoginVCType_login_with_code) {
            _verificatHelper = [[VerificatHelper alloc] initWithSendCodeType:SendCodeTypeRegister withControlTarget:self.code_login_send_Btn];
            _verificatHelper.nextTxt = self.password_Txt;
        }
        else
        {
            _verificatHelper = [[VerificatHelper alloc] initWithSendCodeType:SendCodeTypeForgetPassword withControlTarget:self.getCodeBtn];
        }
        
    }
    return _verificatHelper;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
