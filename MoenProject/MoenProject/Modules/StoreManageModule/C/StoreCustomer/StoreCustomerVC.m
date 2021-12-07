//
//  StoreCustomerVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreCustomerVC.h"
#import "SamplingInputTCell.h"
#import "CStatisticsNumberTCell.h"
#import "StoreCustomerDetailVC.h"
#import "SCStatisticsModel.h"

@interface StoreCustomerVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) SCStatisticsListModel *dataModel;

@property (nonatomic, assign) NSInteger yearValue;


/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation StoreCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"store_customer", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无门店客户信息";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CStatisticsNumberTCell" bundle:nil] forCellReuseIdentifier:@"CStatisticsNumberTCell"];
    
}

- (void)configBaseData
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //设置时间格式
//    formatter.dateFormat = @"yyyy";
//    NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
//    self.yearValue = [dateStr integerValue];
    
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_coustomer];

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
        [weakSelf httpPath_coustomer];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
//        weakSelf.yearValue -= 1;
        //对应接口
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        [weakSelf httpPath_coustomer];
//        if (weakSelf.yearValue == 2019) {
//            [weakSelf.tableview hidenRefreshFooter];
//        }
    }];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_coustomer];
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
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 105;
    }
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CStatisticsNumberTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CStatisticsNumberTCell" forIndexPath:indexPath];
        [cell showDataWithSCStatisticsModel:self.dataModel];
        
        return cell;
    }
    SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
    [cell showDataWithSCStatisticsModel:self.dataList[indexPath.row]];
    cell.cellType = SamplingInputTCellForUsedRecord;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SCStatisticsModel *model = self.dataList[indexPath.row];
        StoreCustomerDetailVC *storeCustomerDetailVC = [[StoreCustomerDetailVC alloc] init];
        storeCustomerDetailVC.monthStr = model.month;
        [self.navigationController pushViewController:storeCustomerDetailVC animated:YES];
    }
}


#pragma mark -- HTTP
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    if (self.yearValue == 2019) {
        [self.tableview hidenRefreshFooter];
    }
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_coustomer]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_coustomer]) {
                SCStatisticsListModel *listModel = (SCStatisticsListModel *)parserObject;
                self.dataModel = listModel;
//                if (listModel.coustomerList.count) {
//                    self.isShowEmptyData = NO;
//                }
//                else
//                {
//                    self.isShowEmptyData = YES;
//                }
//                [self.tableview reloadData];
                
                if (listModel.coustomerList.count > 0) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.coustomerList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
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

/**门店扩展客户Api*/
- (void)httpPath_coustomer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_coustomer;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (SCStatisticsListModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[SCStatisticsListModel alloc] init];
    }
    return _dataModel;
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
