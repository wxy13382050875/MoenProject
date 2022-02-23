//
//  ChangeStoreVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/12/30.
//  Copyright © 2019 Kevin Jin. All rights reserved.
//

#import "ChangeStoreVC.h"
#import "ChangeStoreTCell.h"
#import "CommonSkipHelper.h"
#import "LoginInfoModel.h"
#import "HomeDataModel.h"
@interface ChangeStoreVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UserLoginInfoModel *selectedModel;

@end

@implementation ChangeStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    self.title = @"门店选择";
    self.view.backgroundColor = AppTitleBlueColor;
//    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
//    self.title = NSLocalizedString(@"select_order", nil);
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 60)];
    [leftBtn setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:leftBtn];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH - 160, 60)];
    titleLab.textColor = AppTitleWhiteColor;
    titleLab.font = FontBinB(18);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"门店选择";
    [self.view addSubview:titleLab];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 140, SCREEN_WIDTH - 160, 40)];
    imageView.image = ImageNamed(@"l_application_name_icon");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.confirmBtn];
    
}



- (void)configBaseData
{
    
}

- (void)returnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (self.dataArr.count - 1)) {
        return 80;
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeStoreTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeStoreTCell" forIndexPath:indexPath];
    UserLoginInfoModel *model = (UserLoginInfoModel *)self.dataArr[indexPath.section];
    [cell showDataWithUserLoginInfoModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == (self.dataArr.count - 1)) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        footerView.backgroundColor = AppBgWhiteColor;
        return footerView;
    }
    return [[UIView alloc] init];
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UserLoginInfoModel *model in self.dataArr) {
        model.isSelected = NO;
    }
    UserLoginInfoModel *selectedModel = (UserLoginInfoModel *)self.dataArr[indexPath.section];
    selectedModel.isSelected = YES;
    self.selectedModel = selectedModel;
    [self.tableView reloadData];
}



- (void)confirmAction:(UIButton *)sender
{
    if (self.selectedModel.shopId.length == 0) {
        [[NSToastManager manager] showtoast:@"请选择门店"];
        return;
    }
    
//    UserLoginInfoModel *model = self.selectedModel.userConfigDataList[0];
//    [QZLUserConfig sharedInstance].loginPhone = self.phone_Txt.text;
    [QZLUserConfig sharedInstance].userRole = self.selectedModel.userRole;
    [QZLUserConfig sharedInstance].dealerId = self.selectedModel.dealerId;
    [QZLUserConfig sharedInstance].dealerName = self.selectedModel.dealerName;
    [QZLUserConfig sharedInstance].shopId = self.selectedModel.shopId;
    [QZLUserConfig sharedInstance].shopName = self.selectedModel.shopName;
    [QZLUserConfig sharedInstance].employeeId = self.selectedModel.employeeId;
    [QZLUserConfig sharedInstance].userName = self.selectedModel.userName;
    [self httpPath_getHomePage];
    
}
-(void)httpPath_inventory_storeCheck{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: [QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_inventory_storeCheck;
}
/**首页信息 Api */
- (void)httpPath_getHomePage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[QZLUserConfig sharedInstance].token.length > 0 ? [QZLUserConfig sharedInstance].token:@"" forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getHomePage;
}

#pragma mark -- Getter&Setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 250, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 300) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = AppBgWhiteColor;
        _tableView.layer.cornerRadius = 3;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"ChangeStoreTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStoreTCell"];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
//        self.comScrollerView = _tableView;
//        self.noDataDes = @"暂无可退订单";
    }
    return _tableView;
}

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
            if ([operation.urlTag isEqualToString:Path_inventory_storeCheck])
            {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    
                    [QZLUserConfig sharedInstance].storeTypeKey = model.datas[@"datas"][@"storeTypeKey"];
                    NSLog(@"storeTypeKey = %@ ",[QZLUserConfig sharedInstance].storeTypeKey);
                    if (self.controllerType == ChangeStoreVCTypeDefault) {
                        [self dismissViewControllerAnimated:NO completion:^{
                            [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
                        }];
                    }
                    else
                    {
                        [CommonSkipHelper skipToHomeViewContrillerWithLoginSuccess];
                    }

                }
            } else if ([operation.urlTag isEqualToString:Path_getHomePage]) {
                HomeDataModel *model = (HomeDataModel *)parserObject;
                [QZLUserConfig sharedInstance].useInventory = model.useInventory;
                [self httpPath_inventory_storeCheck];
            }
        }
    }
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(25, SCREEN_HEIGHT - 110, SCREEN_WIDTH - 50, 40);
        _confirmBtn.titleLabel.font = FONTSYS(14);
        _confirmBtn.clipsToBounds = YES;
        _confirmBtn.layer.cornerRadius = 20;
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:AppTitleBlueColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}


- (void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    if ([QZLUserConfig sharedInstance].shopId.length > 0) {
        for (UserLoginInfoModel *model in self.dataArr) {
            model.isSelected = NO;
            if ([model.shopId isEqualToString:[QZLUserConfig sharedInstance].shopId]) {
                model.isSelected = YES;
                self.selectedModel = model;
                break;
            }
        }
    }
    
}

@end
