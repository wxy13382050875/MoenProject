//
//  CouponRecordVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponRecordVC.h"
#import "CStatisticsNumberTCell.h"
#import "SamplingInputTCell.h"
#import "CouponRecordDetailVC.h"
#import "CouponRecordModel.h"

@interface CouponRecordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, strong) CouponRecordListModel *dataModel;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger yearValue;

@end

@implementation CouponRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"ccoupon_reocrd", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.comScrollerView = self.tableview;
    self.tableview.emptyDataSetSource =self;
    self.tableview.emptyDataSetDelegate = self;
    self.noDataDes = @"暂无优惠券使用信息";
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    
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
    [self httpPath_couponUsageList];
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
        [weakSelf httpPath_couponUsageList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
//        weakSelf.yearValue -= 1;
//        if (weakSelf.yearValue <= 2018) {
//            weakSelf.yearValue = 2019;
//            [weakSelf.tableview cancelRefreshAction];
//            [[NSToastManager manager] showtoast:@"暂无更多数据"];
//            return ;
//        }
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        //对应接口
        [weakSelf httpPath_couponUsageList];
//        if (self.yearValue == 2019) {
//            [self.tableview hidenRefreshFooter];
//        }
    }];
    
}




#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataList.count) {
        return 2;
    }
    return 0;
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
        [cell showDataWithCouponRecordCountStr:self.totalAmount];
        return cell;
    }
    
    SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
    cell.cellType = SamplingInputTCellForUsedRecord;
    [cell showDataWithCouponRecordModel:self.dataList[indexPath.row]];
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
    if (indexPath.section == 0) {
        return;
    }
    CouponRecordModel *model = self.dataList[indexPath.row];
    CouponRecordDetailVC *couponRecordDetailVC = [[CouponRecordDetailVC alloc] init];
    couponRecordDetailVC.registerDate = model.month;
    [self.navigationController pushViewController:couponRecordDetailVC animated:YES];
}



#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
//    if (self.yearValue == 2019) {
//        [self.tableview hidenRefreshFooter];
//    }
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_couponUsageList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_couponUsageList]) {
                
                CouponRecordListModel *dataModel = (CouponRecordListModel *)parserObject;
                self.totalAmount = dataModel.totalAmount;
//                self.dataModel = dataModel;
//                [self.tableview reloadData];
                if (dataModel.orderMonthDataList.count > 0) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:dataModel.orderMonthDataList];
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

/**优惠券使用记录（按月）Api*/
- (void)httpPath_couponUsageList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
   
    self.requestURL = Path_couponUsageList;
}


- (void)reconnectNetworkRefresh
{
    WEAKSELF
     [[NSToastManager manager] showprogress];
    [weakSelf httpPath_couponUsageList];
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


- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (CouponRecordListModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[CouponRecordListModel alloc] init];
    }
    return _dataModel;
}
@end
