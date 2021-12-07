//
//  VerificatHelper.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import "VerificatHelper.h"
#import "NSHttpClient.h"
@interface VerificatHelper()

@property (nonatomic, assign) SendCodeType sendCodeType;

@property (nonatomic, strong) UIButton *targetBtn;

@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, assign) NSInteger downCount;

@end

@implementation VerificatHelper

- (id)initWithSendCodeType:(SendCodeType)sendCodeType withControlTarget:(UIButton *)controlTarget
{
    if (self=[super init]) {
        _sendCodeType = sendCodeType;
        _targetBtn = controlTarget;
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(notice:) name:@"ReleaseTimer" object:nil];
    }
    return self;
}


- (void)SendCodeAction:(NSString *)phoneNumber
{

    NSString *requestUrl = @"";
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] init];
    [paras setValue:phoneNumber forKey:@"phone"];
    if (self.sendCodeType == SendCodeTypeAddBankCard) {
        [paras setValue:@"1" forKey:@"type"];
        requestUrl = Path_sendSMS;
    }
    if (self.sendCodeType == SendCodeTypeRealAuth) {
        [paras setValue:@"2" forKey:@"type"];
        requestUrl = Path_sendSMS;
    }
    if (self.sendCodeType == SendCodeTypeForgetPassword) {
        requestUrl = Path_sendSMS;
    }
    if (self.sendCodeType == SendCodeTypeDrawCrash) {
        [paras setValue:@"5" forKey:@"type"];
        requestUrl = Path_sendSMS;
    }
    if (self.sendCodeType == SendCodeTypePay) {
        [paras setValue:@"6" forKey:@"type"];
        requestUrl = Path_sendSMS;
    }
    if (self.sendCodeType == SendCodeTypeRegister) {
        requestUrl = Path_getCheckCodeShop;
    }
    if (self.sendCodeType == SendCodeTypeUserRegister) {
        requestUrl = Path_getCustomerCheckCode;
    }
    if (self.sendCodeType == SendCodeTypeForgetGesturePassword) {
        [paras setValue:@"7" forKey:@"type"];
        requestUrl = Path_gesture_smsCode;
    }
    WEAKSELF
    [[NSHttpClient client] asyncRequestWithURL:requestUrl type:NO paras:paras success:^(NSURLSessionDataTask *operation, NSObject *parserObject) {
        MoenBaseModel *responseModel = (MoenBaseModel *)parserObject;
        if ([responseModel.code isEqualToString:@"200"]) {
            if (self.nextTxt) {
                [self.nextTxt becomeFirstResponder];
            }
            weakSelf.downCount = 60;
            weakSelf.targetBtn.enabled = NO;
            [weakSelf.countDownTimer setFireDate:[NSDate date]];
            [weakSelf.targetBtn setTitleColor:AppTitleGrayColor forState:UIControlStateNormal];
//            [[NSToastManager manager] showtoast:[NSString stringWithFormat:@"验证码发送成功:%@",responseModel.datas[@"checkCode"]]];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"验证码发送成功:%@",responseModel.datas[@"checkCode"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
        }
        else
        {
            [[NSToastManager manager] showtoast:responseModel.message];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *requestErr) {
        if ([requestErr.domain isEqualToString:@"NSURLErrorDomain"]) {
            [[NSToastManager manager] showtoast:@"网络开小差了，请检查您的网络!"];
        }
    }];
    
}

- (void)countDownAction
{
//    NSLog(@"计时器");
    if (_downCount == 0) {
        [_countDownTimer setFireDate:[NSDate distantFuture]];
        _targetBtn.enabled = YES;
        [_targetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_targetBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
    }else{
        _downCount --;
        [_targetBtn setTitle:[NSString stringWithFormat:@"%ld秒后重获",(long)_downCount] forState:UIControlStateNormal];
    }
}

- (NSTimer *)countDownTimer
{
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        
        NSRunLoop *runLood = [NSRunLoop currentRunLoop];
        [runLood addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
    }
    return _countDownTimer;
}

- (void)didMoveToSuperview
{
    UIViewController *controller = [UIViewController currentViewController];
    //这里需要判断相应的controller是否存在
    if (controller){
        if (controller){
//            @weakify(self)
//            [controller.rac_willDeallocSignal
//             subscribeCompleted:^{
//                 @strongify(self)
//                 [self.countDownTimer invalidate];
//                 self.countDownTimer = nil;
//             }];
        }
    }
}

- (void)notice:(id)sender
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    
}

@end
