//
//  MineVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "MineVC.h"
#import "MineItemTCell.h"
#import "LoginVC.h"
#import "PhotoDisplayView.h"
#import "FDAlertView.h"
#import "SDPhotoBrowser.h"
#import "StoreQRCodeModel.h"
#import "CommonWebViewVC.h"
#import "VideoTestVC.h"

#import "MineAwardsTCell.h"
#import "AwardsOverviewModel.h"
#import "StatisticsAwardsVC.h"
#import "StoreStaffsVC.h"
#import "ChangeStoreVC.h"
#import "LoginInfoModel.h"

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate, SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *portrait_Img;
@property (weak, nonatomic) IBOutlet UILabel *account_Lab;
@property (weak, nonatomic) IBOutlet UILabel *account_name_Lab;
@property (nonatomic,strong) PhotoDisplayView *photoDisplayView;
@property (nonatomic, strong) StoreQRCodeModel *qrCodeModel;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSMutableArray *firstSectionArr;

@property (nonatomic, strong) AwardsOverviewModel *awardsOverviewModel;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.account_Lab.text = [NSTool handlePhoneNumberStarFormatWithNumberString:[QZLUserConfig sharedInstance].loginPhone];
    NSString *role = [[QZLUserConfig sharedInstance].userRole isEqualToString: @"SHOP_LEADER"] ? @"店长":@"导购";
    self.account_name_Lab.text = role;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLab.text = [QZLUserConfig sharedInstance].shopName;
    [self httpPath_GetTotalReward];
}


- (void)configBaseUI
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    [self.tableview registerNib:[UINib nibWithNibName:@"MineItemTCell" bundle:nil] forCellReuseIdentifier:@"MineItemTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"MineAwardsTCell" bundle:nil] forCellReuseIdentifier:@"MineAwardsTCell"];
    
    
    
    self.portrait_Img.userInteractionEnabled = YES;
    [self.portrait_Img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelfView)]];
    
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,44)];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.font = FONTLanTingB(17);
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLab;
    
    
    self.account_Lab.font = FontBinB(15);
    self.account_name_Lab.font = FONTLanTingR(15);
}

- (void)configBaseData
{
    [self httpPath_shopQRCode];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    app_Version = [NSString stringWithFormat:@"V%@",app_Version];
    
    if ([QZLUserConfig sharedInstance].isMultipleStores == YES) {
        self.firstSectionArr = @[@{@"img":@"m_change_password_icon",@"title":@"修改密码",@"desc":@""},
        @{@"img":@"m_change_store_icon",@"title":@"切换门店",@"desc":@""},
        @{@"img":@"m_abount_icon",@"title":@"关于",@"desc":app_Version}].mutableCopy;
    }
    else
    {
        self.firstSectionArr = @[@{@"img":@"m_change_password_icon",@"title":@"修改密码",@"desc":@""},
        @{@"img":@"m_abount_icon",@"title":@"关于",@"desc":app_Version}].mutableCopy;
    }
    
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.firstSectionArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    if (indexPath.section == 1) {
        return 60;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    if (section == 1) {
        return 200;
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        MineAwardsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineAwardsTCell" forIndexPath:indexPath];
//        NSDictionary *itemData = [[NSDictionary alloc] init];
//        itemData = self.firstSectionArr[indexPath.row];
        [cell showDataWithRewardInfoModel:self.awardsOverviewModel.rewardInfo];
        return cell;
    }
    if (indexPath.section == 1) {
        MineItemTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemTCell" forIndexPath:indexPath];
        NSDictionary *itemData = [[NSDictionary alloc] init];
        itemData = self.firstSectionArr[indexPath.row];
        [cell showDataWithDic:itemData];
        return cell;
    }
    return [[UITableViewCell alloc] init];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (section == 1) {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        footerView.backgroundColor = AppBgBlueGrayColor;
        
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame = CGRectMake(45, 150, SCREEN_WIDTH - 90, 45);
        [exitBtn setBackgroundColor:AppBtnDeepBlueColor];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        exitBtn.titleLabel.font = FontBinB(17);
        [exitBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(exitBtnAction) forControlEvents:UIControlEventTouchDown];
        
        [footerView addSubview:exitBtn];
    }
    return footerView;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"])
        {
            StoreStaffsVC *storeStaffsVC = [[StoreStaffsVC alloc] init];
            storeStaffsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeStaffsVC animated:YES];
        }
        else{
            StatisticsAwardsVC *statisticsAwardsVC = [[StatisticsAwardsVC alloc] init];
            statisticsAwardsVC.employeeId = [QZLUserConfig sharedInstance].employeeId;
            statisticsAwardsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:statisticsAwardsVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

            //修改密码
                LoginVC *loginVC = [[LoginVC alloc] init];
                loginVC.controllerType = LoginVCType_change;
                //        [QZLUserConfig sharedInstance].token = @"";
                //        [QZLUserConfig sharedInstance].isLoginIn = NO;
                [self presentViewController:loginVC animated:YES completion:nil];
                });
            
        }
        else if (indexPath.row == 1 )
        {
            if ([QZLUserConfig sharedInstance].isMultipleStores == YES) {
                [self httpPath_getUserConfig];
            }
        }
    }
    
}


- (void)clickSelfView
{
    
    
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = 0;
//    broser.sourceImagesContainerView = self.view;
    broser.imageCount = 1;
    broser.delegate = self;
    [broser show];
}

//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    return [NSURL URLWithString:self.qrCodeModel.shopQRCode];
//}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.portrait_Img.image;
}


#pragma mark- event response
- (void)exitBtnAction
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确定退出当前账号？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        //退出登录
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.controllerType = LoginVCType_login;
        [QZLUserConfig sharedInstance].token = @"";
        [QZLUserConfig sharedInstance].isLoginIn = NO;
        [QZLUserConfig sharedInstance].shopId = @"";
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_shopQRCode])
            {
                StoreQRCodeModel *model = (StoreQRCodeModel *)parserObject;
                self.qrCodeModel = model;
                [self.portrait_Img sd_setImageWithURL:[NSURL URLWithString:self.qrCodeModel.shopQRCode] placeholderImage:ImageNamed(@"defaultImage")];
            }
            if ([operation.urlTag isEqualToString:Path_GetTotalReward])
            {
                AwardsOverviewModel *model = (AwardsOverviewModel *)parserObject;
                self.awardsOverviewModel = model;
                [self.tableview reloadData];
//                self.qrCodeModel = model;
//                [self.portrait_Img sd_setImageWithURL:[NSURL URLWithString:self.qrCodeModel.shopQRCode] placeholderImage:ImageNamed(@"defaultImage")];
            }
            
            if ([operation.urlTag isEqualToString:Path_getUserConfig])
            {
                UserLoginInfoModelList *listModel = (UserLoginInfoModelList *)parserObject;
                if ([listModel.code isEqualToString:@"200"]) {
                    if(listModel.userConfigDataList.count >= 1)
                    {
                        dispatch_async(dispatch_get_main_queue(),^{
                        //选择门店
                            ChangeStoreVC *changeStoreVC = [[ChangeStoreVC alloc] init];
                            changeStoreVC.dataArr = [listModel.userConfigDataList mutableCopy];
                            changeStoreVC.modalPresentationStyle = 0;
                            changeStoreVC.controllerType = ChangeStoreVCTypeDefault;
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
        }
        
    }
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

/**奖励总览Api*/
- (void)httpPath_GetTotalReward
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_GetTotalReward;
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

#pragma mark - getter

- (PhotoDisplayView *)photoDisplayView{
    if (!_photoDisplayView) {
        _photoDisplayView = [[PhotoDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _photoDisplayView;
}

@end
