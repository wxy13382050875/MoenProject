//
//  StoreCustomerDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreCustomerDetailVC.h"
#import "CommonSaleasTCell.h"
#import "SCExpandModel.h"

@interface StoreCustomerDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation StoreCustomerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    if (self.isTheBest) {
        self.title = NSLocalizedString(@"today_regist_number", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"store_customer", nil);
    }
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无数据";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSaleasTCell" bundle:nil] forCellReuseIdentifier:@"CommonSaleasTCell"];
}

- (void)configBaseData
{
    if (self.isTheBest) {
        [self configPagingData];
        [self httpPath_customer];
    }
    else
    {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_monthCoustomer];
        WEAKSELF
        [self.tableview addDropDownRefreshWithActionHandler:^{
            [weakSelf handlePageNumber];
            weakSelf.pageNumber = 1;
            
            //对应接口
            [weakSelf httpPath_monthCoustomer];
        }];
        [self.tableview addPullUpRefreshWithActionHandler:^{
            [weakSelf handlePageNumber];
            weakSelf.pageNumber += 1;

            //对应接口
            [weakSelf httpPath_monthCoustomer];
        }];
    }
}

- (void)reconnectNetworkRefresh
{
     WEAKSELF
    if (self.isTheBest) {
        [weakSelf httpPath_customer];
    }
    else
    {
        [weakSelf handlePageSize];
        [[NSToastManager manager] showprogress];
        [weakSelf httpPath_monthCoustomer];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataList.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSaleasTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSaleasTCell" forIndexPath:indexPath];
    cell.cellType = CommonSaleasTCellCustomerInfo;
    if (self.isTheBest) {
        [cell showDataWithSCExpandCustomerModel:self.dataList[indexPath.row]];
    }
    else
    {
        [cell showDataWithSCExpandModel:self.dataList[indexPath.row]];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_monthCoustomer]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_monthCoustomer] ) {
                
                SCExpandListModel *listModel = (SCExpandListModel *)parserObject;
                if (listModel.monthCoustomerDetail.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.monthCoustomerDetail];
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
            if ([operation.urlTag isEqualToString:Path_customer]) {
                SCExpandListModel *listModel = (SCExpandListModel *)parserObject;
                if (listModel.customerList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.customerList];
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
        }
    }
}

/**门店客户扩展每月详情Api*/
- (void)httpPath_monthCoustomer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.monthStr forKey:@"registerDate"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_monthCoustomer;
}

/**今日客户注册数Api*/
- (void)httpPath_customer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_customer;
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
