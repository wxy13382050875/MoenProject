//
//  StaffManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StaffManageVC.h"
#import "StaffManageVCTCell.h"
#import "ShopStaffModel.h"
#import "AddSellerVC.h"
#import "FDAlertView.h"

@interface StaffManageVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnHeight;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, assign) NSInteger deleteUserID;

@property (nonatomic, assign) BOOL isAgainEnter;

@end

@implementation StaffManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAgainEnter) {
        [self handlePageSize];
        [[NSToastManager manager] showprogress];
        [self httpPath_personal];
    }
    self.isAgainEnter = YES;
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"store_manage", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
    self.addBtnHeight.constant = btnHeight;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"StaffManageVCTCell" bundle:nil] forCellReuseIdentifier:@"StaffManageVCTCell"];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_personal];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        //对应接口
        [weakSelf httpPath_personal];
    }];
//    [self.tableview addPullUpRefreshWithActionHandler:^{
//        [weakSelf handlePageNumber];
//        weakSelf.pageNumber += 1;
//        
//        //对应接口
//        [weakSelf httpPath_personal];
//    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_personal];
}



#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    StaffManageVCTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaffManageVCTCell" forIndexPath:indexPath];
    [cell showDataWithShopStaffModel:self.dataList[indexPath.row] WithStopBlock:^(NSInteger userID) {
        [weakSelf handleTipsActionWithUserID:userID];
    }];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
    headerView.backgroundColor = AppBgWhiteColor;
    
    UIImageView *storeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 26, 26)];
    storeImg.image = ImageNamed(@"s_store_logo_icon");
    [headerView addSubview:storeImg];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 36)];
    titleLab.font = FONTSYS(14);
    titleLab.textColor = AppTitleBlackColor;
    titleLab.text = self.shopName;
    [headerView addSubview:titleLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}


- (void)handleTipsActionWithUserID:(NSInteger)userID
{
    self.deleteUserID = userID;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"停用后，该账户将无法登录系统" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

#pragma mark -- FDAlertViewDelegate
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        //退出登录
        [self httpPath_disablePersonalWithID:self.deleteUserID];
    }
}


- (IBAction)addShoppingGuideAction:(UIButton *)sender {
    
    AddSellerVC *addSellerVC = [[AddSellerVC alloc] init];
    [self.navigationController pushViewController:addSellerVC animated:YES];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_personal]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_personal]) {
                ShopStaffListModel *listModel = (ShopStaffListModel *)parserObject;
                self.shopName = listModel.shopName;
                if (listModel.shopPersonalList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.shopPersonalList];
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [self.dataList removeAllObjects];
                        [self.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        self.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [self.tableview hidenRefreshFooter];
                }
            }
            if ([operation.urlTag isEqualToString:Path_disablePersonal]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"stop_success", nil)];
                    [self handlePageSize];
                    [[NSToastManager manager] showprogress];
                    [self httpPath_personal];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            
        }
    }
}

/**门店人员Api*/
- (void)httpPath_personal
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_personal;
}

/**门店人员Api*/
- (void)httpPath_disablePersonalWithID:(NSInteger)employeeId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(employeeId) forKey:@"employeeId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_disablePersonal;
}


#pragma mark -- Getter&Setter
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark -- 刷新重置等设置
- (void)configPagingData
{
    self.pageNumber = 1;
    self.pageSize = 10;
}
- (void)handlePageSize
{
    if (self.pageNumber > 1) {
        self.pageSize = self.pageSize * self.pageNumber;
        self.pageNumber = 1;
    }
}
- (void)handlePageNumber
{
    if (self.pageSize > 10) {
        self.pageNumber = self.pageSize / 10;
        self.pageSize = 10;
    }
}


@end
