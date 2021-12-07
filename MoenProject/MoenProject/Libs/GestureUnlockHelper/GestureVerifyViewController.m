
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureViewController.h"

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@end

@implementation GestureVerifyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:CircleViewBackgroundColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"验证手势解锁";
//    [self setShowBackBtn:YES type:NavBackBtnImageBlackType];
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    
    
    [self httpPath_updateGestureWithPassword:gesture];
    
    return;
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功");
            
            if (self.isToSetNewGesture) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    }
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
            
            if ([operation.urlTag isEqualToString:Path_updateGesture]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
//                if ([model.code isEqualToString:@"1000"]) {
//                    [[NSToastManager manager] showtoast:@"手势设置成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
            }
        }
    }
}


/**手势登录Api */
- (void)httpPath_updateGestureWithPassword:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@([QZLUserConfig sharedInstance].mId) forKey:@"mId"];
    [parameters setValue:[QZLUserConfig sharedInstance].userPhone forKey:@"phone"];
    [parameters setValue:[TransCodingHelper md5:password] forKey:@"gesturePass"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_updateGesture;
}

@end
