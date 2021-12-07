//
//  CustomerRegistVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/17.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CustomerRegistVC.h"
#import "VerificatHelper.h"
#import "MembershipInfoModel.h"
#import "UserIdentifySuccessVC.h"
#import "StoreQRCodeModel.h"
#import "SDPhotoBrowser.h"
#import "SelectedTagVC.h"

@interface CustomerRegistVC ()<UITextFieldDelegate, SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UILabel *code_Lab;


@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;
@property (weak, nonatomic) IBOutlet UITextField *code_Txt;
@property (weak, nonatomic) IBOutlet UIButton *getCode_Btn;
@property (weak, nonatomic) IBOutlet UIButton *register_Btn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) StoreQRCodeModel *qrModel;

@property (nonatomic, strong) VerificatHelper *verificatHelper;

@end

@implementation CustomerRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"customer_registration", nil);
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setImage:ImageNamed(@"c_qrcode_icon") forState:UIControlStateNormal];
    [rightButton setImage:ImageNamed(@"c_qrcode_icon") forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.phone_Txt.delegate = self;
    self.phone_Txt.keyboardType = UIKeyboardTypePhonePad;
    self.code_Txt.delegate = self;
    self.code_Txt.keyboardType = UIKeyboardTypeNumberPad;
    
    self.phone_Lab.font = FONTLanTingR(14);
    self.phone_Lab.text = NSLocalizedString(@"c_phone_number", nil);
    
    self.code_Lab.font = FONTLanTingR(14);
    self.code_Lab.text = NSLocalizedString(@"c_verification_code", nil);
    
    self.phone_Txt.font = FONTLanTingR(14);
    self.phone_Txt.placeholder = NSLocalizedString(@"c_enter_phone_number", nil);
    
    self.code_Txt.font = FONTLanTingR(14);
    self.code_Txt.placeholder = NSLocalizedString(@"c_enter_validation_code", nil);
    
    self.getCode_Btn.titleLabel.font = FONTLanTingR(14);
    [self.getCode_Btn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
    self.getCode_Btn.titleLabel.text = NSLocalizedString(@"c_get_code", nil);
    [self.getCode_Btn setEnabled:NO];
    self.getCode_Btn.alpha = 0.5;
    
    self.register_Btn.titleLabel.font = FONTLanTingB(17);
    self.register_Btn.titleLabel.text = NSLocalizedString(@"c_register", nil);
    
}

- (void)configBaseData
{
    [self httpPath_shopQRCode];
    if (self.userPhone.length) {
        self.phone_Txt.text = self.userPhone;
        [self.getCode_Btn setEnabled:YES];
        self.getCode_Btn.alpha = 1;
        
    }
}

- (IBAction)getCodeAction:(id)sender {
    
    NSString *noticeStr = @"";
    if (self.phone_Txt.text.length == 0) {
        noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
    }
    else if (![Utils checkTelNumber:self.phone_Txt.text]) {
        noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
    }
    
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
        
    }else{
        [self.verificatHelper SendCodeAction:self.phone_Txt.text];
        self.verificatHelper.nextTxt = self.code_Txt;
//        [self.code_Txt becomeFirstResponder];
    }
    
}

- (IBAction)registerAction:(id)sender {
    NSLog(@"++++++");
    NSString *noticeStr = @"";
    if (self.phone_Txt.text.length == 0) {
        noticeStr = NSLocalizedString(@"t_please_enter_phone_number", nil);
    }
    else if (![Utils checkTelNumber:self.phone_Txt.text]) {
        noticeStr = NSLocalizedString(@"t_incorrect_format_phone", nil);
    }
    else if (self.code_Txt.text.length == 0)
    {
        noticeStr = NSLocalizedString(@"t_please_enter_validation_code", nil);
    }
    
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
    }else{
        [self httpPath_registerCustomer];
    }
}


- (void)showAction:(UIButton *)sender
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.rightBtn;
    browser.imageCount = 1;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.qrModel.shopQRCode];
}


- (void)skipToUserIdentifySuccessVCWithModel:(MembershipInfoModel *)model
{
    UserIdentifySuccessVC *userIdentifySuccessVC = [[UserIdentifySuccessVC alloc] init];
    userIdentifySuccessVC.controllerType = UserIdentifySuccessVCTypeRegister;
    userIdentifySuccessVC.infoModel = model;
    userIdentifySuccessVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userIdentifySuccessVC animated:YES];
}


#pragma Mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_Txt) {
        if ([string isEqualToString:@""]) {
            if (textField.text.length >= 12) {
                [self.getCode_Btn setEnabled:YES];
                self.getCode_Btn.alpha = 1;
            }
            else
            {
                [self.getCode_Btn setEnabled:NO];
                self.getCode_Btn.alpha = 0.5;
            }
        }
        else
        {
            if (textField.text.length >= 10) {
                [self.getCode_Btn setEnabled:YES];
                self.getCode_Btn.alpha = 1;
            }
            else
            {
                [self.getCode_Btn setEnabled:NO];
                self.getCode_Btn.alpha = 0.5;
            }
        }
        
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            
            return NO;
        }
    }
    if (textField == self.code_Txt) {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) {
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
        if ([operation.urlTag isEqualToString:Path_registerCustomer]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_registerCustomer]) {
                MembershipInfoModel *model = (MembershipInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [weakSelf httpPath_getCustomerWithPhoneNumber:model.phone];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            else if ([operation.urlTag isEqualToString:Path_getCustomer])
            {
                MembershipInfoModel *model = (MembershipInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    SelectedTagVC *selectedTagVC = [[SelectedTagVC alloc] init];
                    selectedTagVC.customerId = model.customerId;
                    selectedTagVC.infoModel = model;
                    selectedTagVC.controllerType = SelectedTagVCTypeFromRegister;
                    selectedTagVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:selectedTagVC animated:YES];
//                    [weakSelf skipToUserIdentifySuccessVCWithModel:model];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            else if ([operation.urlTag isEqualToString:Path_shopQRCode])
            {
                StoreQRCodeModel *model = (StoreQRCodeModel *)parserObject;
                self.qrModel = model;
            }
        }
    }
}

/**客户注册Api*/
- (void)httpPath_registerCustomer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.phone_Txt.text forKey:@"phone"];
    [parameters setValue:self.code_Txt.text forKey:@"checkCode"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_registerCustomer;
}

/**获取会员信息Api*/
- (void)httpPath_getCustomerWithPhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNumber forKey:@"phone"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_getCustomer;
}

/**获取门店二维码Api*/
- (void)httpPath_shopQRCode
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_shopQRCode;
}

#pragma Mark- getters and setters
- (VerificatHelper *)verificatHelper
{
    if (!_verificatHelper) {
        _verificatHelper = [[VerificatHelper alloc] initWithSendCodeType:SendCodeTypeUserRegister withControlTarget:self.getCode_Btn];
    }
    return _verificatHelper;
}

@end
