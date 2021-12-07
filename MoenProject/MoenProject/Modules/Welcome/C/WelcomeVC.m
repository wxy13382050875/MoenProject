//
//  WelcomeVC.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import "WelcomeVC.h"
#import "WelcomeModel.h"
#import "FDAlertView.h"

@interface WelcomeVC ()<UIScrollViewDelegate,FDAlertViewDelegate>
{
    //更新弹框
    UIAlertController *_updateAlert;
    UIImageView *_defaultView;
}
@property (nonatomic, strong) UIView *FirstLaunchView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *page;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *ImgArray;

@property (nonatomic, assign) BOOL isGetLocation;
@property (nonatomic, assign) BOOL isForceUpdate;
@property (nonatomic, copy) NSString *updateURL;

/**纬度*/
@property (nonatomic, assign) NSString *latitudeStr;
/**经度*/
@property (nonatomic, assign) NSString *longitudeStr;
@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    [self setDefaultView];
    [self HttpPath_versionTerminal];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self layoutLaunchViewNeedUpdata:NO IsForceUpdate:NO versionLinkUrl:nil];
}

- (void)setDefaultView{
    NSDictionary * dic = @{@"320x480" : @"LaunchImage-700", @"320x568" : @"LaunchImage-700-568h", @"375x667" : @"LaunchImage-800-667h", @"414x736" : @"LaunchImage-800-Portrait-736h", @"375x812" : @"LaunchImage-1100-Portrait-2436h"};
    
    NSString * key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
    NSString *laughImgStr = dic[key];
    UIImageView *defaultView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    defaultView.image = [UIImage imageNamed:laughImgStr];
    _defaultView = defaultView;
    [self.view addSubview:defaultView];
    
}


- (void)layoutLaunchViewNeedUpdata:(BOOL)needUpdate IsForceUpdate:(BOOL)isForceUpdate versionLinkUrl:(NSString *)versionLinkUrl{
    
    //是否第一次登陆过
    BOOL isFirstEnteredin =  [QZLUserConfig sharedInstance].isFirstEnterIn;
    //第一次打开app
    if (!isFirstEnteredin ) {
        //需要更新
        if (needUpdate) {
            //需要强制更新
            if (isForceUpdate) {
                
                NSDictionary * dic = @{@"320x480" : @"LaunchImage-700", @"320x568" : @"LaunchImage-700-568h", @"375x667" : @"LaunchImage-800-667h", @"414x736" : @"LaunchImage-800-Portrait-736h", @"375x812" : @"LaunchImage-1100-Portrait-2436h"};
                
                NSString * key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
                NSString *laughImgStr = dic[key];
                self.ImgArray = @[laughImgStr];
                
            }else{
                //不需要强制更新
                self.ImgArray = @[@"WelcomeImage1",@"WelcomeImage2",@"WelcomeImage3"];
            }
            //弹框
            [self alertUpdateIsForce:isForceUpdate updateUrl:versionLinkUrl];
            
        }else{
            //不需要更新
            self.ImgArray = @[@"WelcomeImage1",@"WelcomeImage2",@"WelcomeImage3",];
        }
    }else{
        //不是第一次打开app
        if (needUpdate) {
            //需要更新
            //弹框
            [self alertUpdateIsForce:isForceUpdate updateUrl:versionLinkUrl];
        }else{
            
//            [self.adHandler showAdImageViewIn:self.view];
            //不需要更新
            //收起controller
                        if (self.completionBlock) {
                            self.completionBlock(nil);
                        }
        }
        
        return;
    }
    //布局首次登陆视图
    self.FirstLaunchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _FirstLaunchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.FirstLaunchView];
    //布局滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.ImgArray.count, SCREEN_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.FirstLaunchView addSubview:_scrollView];
    //布局图片
    for (int i = 0; i < self.ImgArray.count; i++) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        _imageView.image = [UIImage imageNamed:self.ImgArray[i]];
        
        [self.scrollView addSubview:_imageView];
        //第一次登陆且不是强制更新，最后一个加按钮
        if (i == self.ImgArray.count-1 && !isFirstEnteredin && !isForceUpdate) {
            //布局进入按钮
            _imageView.userInteractionEnabled = YES;
            
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [enterBtn setImage:ImageNamed(@"Welcome_Start_Btn") forState:UIControlStateNormal];
            [enterBtn addTarget:self action:@selector(handleEnter:) forControlEvents:UIControlEventTouchUpInside];
            [_imageView addSubview:enterBtn];
            CGFloat bottomOffsetY = 55;
            [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_imageView.mas_centerX);
                make.bottom.equalTo(_imageView.mas_bottom).offset(-bottomOffsetY);
                make.width.mas_equalTo(160.0f);
                make.height.mas_equalTo(35);
            }];
        }
    }
}

- (void)handleEnter:(UIButton *)sender {
    
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.01;
    } completion:^(BOOL finished) {
        
        if (self.completionBlock) {
            self.completionBlock(nil);
        }
        
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}


/**提示更新*/
- (void)alertUpdateIsForce:(BOOL)isForceUpdate updateUrl:(NSString *)updateUrl{
    NSString *titleStr = @"";
    self.isForceUpdate = isForceUpdate;
    self.updateURL = updateUrl;
    titleStr = isForceUpdate?@"发现新版本，此版本为强制更新版本，为了您更好地体验，请立即更新":@"发现新版本,请立即更新";
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:titleStr preferredStyle:UIAlertControllerStyleAlert];
//    _updateAlert = alertController;
//    UIAlertAction *actionEnsure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
//        exit(0);
//    }];
    //需要强制更新
    if (isForceUpdate) {
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_update_remind", nil) alterType:FDAltertViewTypeTips message:titleStr delegate:self buttonTitles:NSLocalizedString(@"c_update", nil), nil];
        [alert show];
        
//        [alertController addAction:actionEnsure];
//
//        BOOL isFirstLoggedin =  [QZLUserConfig sharedInstance].isFirstEnterIn;
//
//        if (!isFirstLoggedin) {
//            //第一次登陆
//            //直接提示需要更新
//            [self presentViewController:alertController animated:YES completion:nil];
//
//        }else{
//
//            //回传
//            //收起 welcomeController
//            //传出 alertController
//            if (self.completionBlock) {
//                self.completionBlock(alertController);
//            }
//        }
    }
    //不需要强制更新
    else
    {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_update_remind", nil) alterType:FDAltertViewTypeTips message:titleStr delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_update", nil), nil];
        [alert show];
        
//        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alertController addAction:actionCancel];
//        [alertController addAction:actionEnsure];
//
//        //关闭启动页
//        BOOL isFirstLoggedin =  [QZLUserConfig sharedInstance].isFirstEnterIn;
//
//        if (!isFirstLoggedin) {
//            //第一次登陆
//            //直接提示需要更新
//            [self presentViewController:alertController animated:YES completion:nil];
//        }else{
//
//            //回传
//            //收起 welcomeController
//            //传出 alertController
//            if (self.completionBlock) {
//                self.completionBlock(alertController);
//            }
//        }
        
    }
    
}

#pragma mark - NeedUpdate

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (self.isForceUpdate) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURL]];
            exit(0);
        }
    }
    else
    {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURL]];
            exit(0);
        }
        else
        {
            if (self.completionBlock) {
                self.completionBlock(nil);
            }
        }
    }
}


- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_versionTerminal])
        {
            [self layoutLaunchViewNeedUpdata:NO IsForceUpdate:NO versionLinkUrl:nil];
        }
    }
    else
    {
            if ([operation.urlTag isEqualToString:Path_versionTerminal])
            {
                WelcomeModel *dataModel = (WelcomeModel *)parserObject;
                
                /*
                 0是最新版本
                 1不是最新版本
                 2需要强制更新
                 */
                switch (dataModel.forceUpdate) {
                    case 1:
                    {
                        //版本更新地址
                        NSString *versionLinkUrl = dataModel.apkUrl;
                        [self layoutLaunchViewNeedUpdata:YES IsForceUpdate:NO versionLinkUrl:versionLinkUrl];
                    }
                        break;
                    case 2:
                    {
                        //版本更新地址
                        NSString *versionLinkUrl = dataModel.apkUrl;
                        [self layoutLaunchViewNeedUpdata:YES IsForceUpdate:YES versionLinkUrl:versionLinkUrl];
                    }
                        break;
                    case 0:
                    {
                        //版本更新地址
                        [self layoutLaunchViewNeedUpdata:NO IsForceUpdate:NO versionLinkUrl:nil];
                    }
                        break;
                    default:
                        break;
                }
                
            }
    }
}


//版本更新请求
- (void)HttpPath_versionTerminal
{
    //获取版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"IOS" forKey:@"terminalType"];
    [parameters setValue:app_Version forKey:@"currentVersion"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_versionTerminal;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
