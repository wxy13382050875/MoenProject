//
//  StoreStaffsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "StoreStaffsVC.h"
#import "SamplingInputTCell.h"
#import "ShopStaffModel.h"
#import "StatisticsAwardsVC.h"

@interface StoreStaffsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation StoreStaffsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    self.title = @"门店员工";
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    //    self.title = NSLocalizedString(@"select_order", nil);
    
    [self.view addSubview:self.tableview];
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
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        //对应接口
        [weakSelf httpPath_personal];
    }];
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
    return 56;
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
    
    SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
    cell.cellType = SamplingInputTCellForStoreStaff;
    [cell showDataShopStaffModel:self.dataList[indexPath.row]];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopStaffModel *model = self.dataList[indexPath.row];
    StatisticsAwardsVC *statisticsAwardsVC = [[StatisticsAwardsVC alloc] init];
    statisticsAwardsVC.employeeId = [NSString stringWithFormat:@"%ld",model.ID];
    statisticsAwardsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:statisticsAwardsVC animated:YES];
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
        }
    }
}

/**门店人员 Api*/
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


#pragma mark -- Getter&Setter
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无门店员工";
    }
    return _tableview;
}

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
