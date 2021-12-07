
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "GestureVerifyViewController.h"
//#import "AccountAndSafeCommonVC.h"
//#import "LoginInfoModel.h"

@interface GestureViewController ()<UINavigationControllerDelegate, CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:CircleViewBackgroundColor];
//    [self setShowBackBtn:YES type:NavBackBtnImageBlackType];
    self.navigationController.delegate = self;
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)dealloc
{
    if (self.type == GestureViewControllerTypeLogin) {
        [QZLUserConfig sharedInstance].isLogining = NO;
    }
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        case GestureViewControllerTypeModify:
            [self setupSubViewsModifyVC];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = AppBgBlueGrayColor;
    [self.view addSubview:line];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(15, 30, 60, 30)];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImage:ImageNamed(@"n_back_black_icon") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH - 160, 30)];
    titleLab.font = FONT(18);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = AppNavTitleBlackColor;
    titleLab.text = @"手势登录";
    [self.view addSubview:titleLab];
    
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[UIImage imageNamed:@"m_ portrait_icon"]];
    [self.view addSubview:imageView];
    
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(imageView.frame) + 15, SCREEN_WIDTH - 160, 30)];
    phoneLab.font = FONT(15);
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.textColor = AppNavTitleBlackColor;
    phoneLab.text = [QZLUserConfig sharedInstance].userPhone;
    [self.view addSubview:phoneLab];
    
    
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton new];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 90, kScreenW/2, 20) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton new];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 90, kScreenW/2, 20) title:@"切换登录方式" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}


- (void)setupSubViewsModifyVC
{
    [self.lockView setType:CircleViewTypeSetting];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = AppBgBlueGrayColor;
    [self.view addSubview:line];
    
    self.title = @"修改手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didClickRightItem {
    NSLog(@"点击了重设按钮");
    // 1.隐藏按钮
    self.navigationItem.rightBarButtonItem.title = nil;

    // 2.infoView取消选中
    [self infoViewDeselectedSubviews];

    // 3.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];

    // 4.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagManager:
        {
            NSLog(@"点击了管理手势密码按钮");
//            AccountAndSafeCommonVC *accountAndSafeCommonVC = [[AccountAndSafeCommonVC alloc] init];
//            accountAndSafeCommonVC.title = @"忘记密码";
//            accountAndSafeCommonVC.controllerType = AccountAndSafe_ForgetPassword;
//            [self.navigationController pushViewController:accountAndSafeCommonVC animated:YES];
//
//            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
//            gestureVerifyVc.isToSetNewGesture = YES;
//            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
            
        }
            break;
        case buttonTagForget:
            NSLog(@"切换登录方式");
            [UTVCSkipHelper presentLoginVCWithLoginWays:YES];
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        if (self.type == GestureViewControllerTypeSetting) {
            [self httpPath_addGesture:gesture];
        }
        else if (self.type == GestureViewControllerTypeModify)
        {
            [self httpPath_updateGesture:gesture];
        }
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
//        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
//        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        [self httpPath_gesture_loginWithPassword:gesture];
//        if (equal) {
//            NSLog(@"登陆成功！");
////            [self httpPath_addGesture:gesture];
////            [self.navigationController popToRootViewControllerAnimated:YES];
//        } else {
//            NSLog(@"密码错误！");
//            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
//        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中

- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    BOOL isLoginType = [viewController isKindOfClass:[self class]];

    if (self.type == GestureViewControllerTypeLogin) {
//        [self.navigationController setNavigationBarHidden:isLoginType animated:YES];
    }
}



#pragma mark --  private methods
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_addGesture]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_addGesture]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"1000"]) {
                    [self httpPath_switch];
                }
            }
            if ([operation.urlTag isEqualToString:Path_switch]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"1000"]) {
                    [[NSToastManager manager] showtoast:@"手势设置成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            if ([operation.urlTag isEqualToString:Path_updateGesture]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"1000"]) {
                    [[NSToastManager manager] showtoast:@"手势修改成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            if ([operation.urlTag isEqualToString:Path_gesture_login]) {
//                LoginInfoModel *model = (LoginInfoModel *)parserObject;
//                if ([model.code isEqualToString:@"1000"]) {
//                    [[NSToastManager manager] showtoast:@"登陆成功"];
//                    [QZLUserConfig sharedInstance].userName = model.userName;
//                    [QZLUserConfig sharedInstance].token = model.token;
//                    [QZLUserConfig sharedInstance].invitaionCode = model.invitaionCode;
//                    [QZLUserConfig sharedInstance].isLoginIn = YES;
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
            }
        }
    }
}


/**手势登录Api */
- (void)httpPath_gesture_loginWithPassword:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[QZLUserConfig sharedInstance].userPhone forKey:@"regPhone"];
    [parameters setValue:[TransCodingHelper md5:password] forKey:@"regPassword"];
    [parameters setValue:@"ios" forKey:@"loginTerminal"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_gesture_login;
}

/**手势开关Api */
- (void)httpPath_switch
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@([QZLUserConfig sharedInstance].mId) forKey:@"mId"];
    [parameters setValue:@(1) forKey:@"gestureStatus"];
    [parameters setObject:[QZLUserConfig sharedInstance].token forKey:@"Authorization"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_switch;
}

/**设置手势密码Api */
- (void)httpPath_addGesture:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@([QZLUserConfig sharedInstance].mId)forKey:@"mId"];
    [parameters setValue:[QZLUserConfig sharedInstance].userPhone forKey:@"phone"];
    [parameters setValue:[TransCodingHelper md5:password]  forKey:@"gesturePass"];
    [parameters setValue:@(1) forKey:@"gestureStatus"];
    [parameters setObject:[QZLUserConfig sharedInstance].token forKey:@"Authorization"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_addGesture;
}


/**修改手势密码Api */
- (void)httpPath_updateGesture:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@([QZLUserConfig sharedInstance].mId)forKey:@"mId"];
    [parameters setValue:[QZLUserConfig sharedInstance].userPhone forKey:@"phone"];
    [parameters setValue:[TransCodingHelper md5:password]  forKey:@"gesturePass"];
    [parameters setObject:[QZLUserConfig sharedInstance].token forKey:@"Authorization"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_updateGesture;
}

@end
