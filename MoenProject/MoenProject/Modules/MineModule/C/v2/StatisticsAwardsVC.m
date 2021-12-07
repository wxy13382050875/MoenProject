//
//  StatisticsAwardsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "StatisticsAwardsVC.h"
#import "MineAwardsTCell.h"
#import "SamplingInputTCell.h"
#import "AwardsStatisticsModel.h"
#import "AwardsOverviewModel.h"
#import "AwardsDetailVC.h"
@interface StatisticsAwardsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) AwardsStatisticsModel *awardsStatisticsModel;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

/**翻年*/
@property (nonatomic, assign) NSInteger yearValue;

@end

@implementation StatisticsAwardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    self.title = @"奖励统计";
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
//    self.title = NSLocalizedString(@"select_order", nil);
    
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
//    formatter.dateFormat = @"yyyy";
//    NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
//    self.yearValue = [dateStr integerValue];
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_GetRewardStatistics];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //设置时间格式
//        formatter.dateFormat = @"yyyy";
//        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
//        weakSelf.yearValue = [dateStr integerValue];
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        //对应接口
        [weakSelf httpPath_GetRewardStatistics];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
//        weakSelf.yearValue -= 1;
//        if (weakSelf.yearValue <= 2018) {
//            weakSelf.yearValue = 2019;
//            [weakSelf.tableview cancelRefreshAction];
//            [[NSToastManager manager] showtoast:@"暂无更多数据"];
//            return ;
//        }
        
        //对应接口
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        [weakSelf httpPath_GetRewardStatistics];
//        if (weakSelf.yearValue == 2019) {
//            [weakSelf.tableview hidenRefreshFooter];
//        }
        
    }];
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
        return self.dataList.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    if (indexPath.section == 1) {
        return 56;
    }
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MineAwardsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineAwardsTCell" forIndexPath:indexPath];
//        RewardInfoModel *model = [[RewardInfoModel alloc] init];
//        model.monthReward = self.awardsStatisticsModel.moenReward;
//        model.monthReward = self.awardsStatisticsModel.moenReward;
        [cell showDataWithAwardsStatisticsModel:self.awardsStatisticsModel];
        return cell;
    }
    if (indexPath.section == 1) {
        
        SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
        cell.cellType = SamplingInputTCellForUsedRecord;
        [cell showDataWithAwardsMonthDataModel:self.dataList[indexPath.row]];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
    
//    OrderManageModel *model = self.dataList[indexPath.section];
//    if (model.orderItemInfos.count > 1) {
//        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderManageModel:model];
//        return cell;
//    }
//    else
//    {
//        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderManageModel:model];
//        return cell;
//    }
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    footerView.backgroundColor = AppBgBlueGrayColor;
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AwardsDetailVC *awardsDetailVC = [[AwardsDetailVC alloc] init];
        awardsDetailVC.month =  self.awardsStatisticsModel.currentYearMonth;
        awardsDetailVC.employeeId = self.employeeId;
        [self.navigationController pushViewController:awardsDetailVC animated:YES];
    }
    else
    {
        AwardsMonthDataModel * model = self.dataList[indexPath.row];
        AwardsDetailVC *awardsDetailVC = [[AwardsDetailVC alloc] init];
        awardsDetailVC.month = model.month;
        awardsDetailVC.employeeId = self.employeeId;
        [self.navigationController pushViewController:awardsDetailVC animated:YES];
    }
    
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_GetRewardStatistics]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_GetRewardStatistics]) {
                AwardsStatisticsModel *listModel = (AwardsStatisticsModel *)parserObject;
                self.awardsStatisticsModel = listModel;
                if (listModel.monthData.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.monthData];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            }
        }
    }
}

/**奖励统计 Api*/
- (void)httpPath_GetRewardStatistics
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.employeeId forKey:@"employeeId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_GetRewardStatistics;
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
        [_tableview registerNib:[UINib nibWithNibName:@"MineAwardsTCell" bundle:nil] forCellReuseIdentifier:@"MineAwardsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
//        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无可退订单";
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
    self.pageSize = 12;
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
    if (self.pageSize > 12) {
        self.pageNumber = self.pageSize / 12;
        self.pageSize = 12;
    }
}


@end
