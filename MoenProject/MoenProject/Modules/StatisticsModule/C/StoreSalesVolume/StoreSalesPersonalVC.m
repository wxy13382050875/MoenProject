//
//  StoreSalesPersonalVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreSalesPersonalVC.h"
#import "CommonStoreSalesVolumeTCell.h"
#import "CommonTimeSelectView.h"
#import "StoreSalesPersonalModel.h"

@interface StoreSalesPersonalVC ()<UITableViewDelegate, UITableViewDataSource, CommonTimeSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_MarginTop;
@property (weak, nonatomic) IBOutlet UILabel *order_count_Lab;
@property (weak, nonatomic) IBOutlet UILabel *order_price_Lab;
@property (weak, nonatomic) IBOutlet UILabel *single_price_Lab;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) CommonTimeSelectView *timeSelectView;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, copy) NSString *orderAmountCount;

@property (nonatomic, copy) NSString *customerTransaction;

@end

@implementation StoreSalesPersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"store_sales_volume", nil);
    
    if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
        self.tableview_MarginTop.constant = 0;
    }else
    {
        self.tableview_MarginTop.constant = 50;
        [self.view addSubview:self.timeSelectView];
    }
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonStoreSalesVolumeTCell" bundle:nil] forCellReuseIdentifier:@"CommonStoreSalesVolumeTCell"];
}

- (void)configBaseData
{
    
    if (self.shopPersonalId.length == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
        self.startTime = [date getMonthFirstAndLastDayWith].firstObject;
        self.endTime = dateStr;
    }
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_findOne];
    WEAKSELF
//    [self.tableview addDropDownRefreshWithActionHandler:^{
//        [weakSelf handlePageNumber];
//        weakSelf.pageNumber = 1;
//        //对应接口
//        [weakSelf httpPath_findOne];
//    }];
//    [self.tableview addPullUpRefreshWithActionHandler:^{
//        [weakSelf handlePageNumber];
//        weakSelf.pageNumber += 1;
//
//        //对应接口
//        [weakSelf httpPath_findOne];
//    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_findOne];
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
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonStoreSalesVolumeTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonStoreSalesVolumeTCell" forIndexPath:indexPath];
    [cell showDataWithStoreSalesPersonalModel:self.dataList[indexPath.row]];

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel *name_Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 45)];
    name_Lab.textColor = AppTitleBlackColor;
    name_Lab.textAlignment = NSTextAlignmentCenter;
    name_Lab.font = FONTSYS(14);
    name_Lab.text = NSLocalizedString(@"date_str", nil);
    [headerView addSubview:name_Lab];
    
    UILabel *order_count_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 45)];
    order_count_Lab.textColor = AppTitleBlackColor;
    order_count_Lab.textAlignment = NSTextAlignmentCenter;
    order_count_Lab.font = FONTSYS(14);
    order_count_Lab.text = NSLocalizedString(@"total_number_orders", nil);
    [headerView addSubview:order_count_Lab];
    
    UILabel *order_price_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 45)];
    order_price_Lab.textColor = AppTitleBlackColor;
    order_price_Lab.font = FONTSYS(14);
    order_price_Lab.textAlignment = NSTextAlignmentCenter;
    order_price_Lab.text = NSLocalizedString(@"order_amount", nil);
    [headerView addSubview:order_price_Lab];
    
    UILabel *single_price_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, 45)];
    single_price_Lab.textColor = AppTitleBlackColor;
    single_price_Lab.font = FONTSYS(14);
    single_price_Lab.textAlignment = NSTextAlignmentCenter;
    single_price_Lab.text = NSLocalizedString(@"customer_price", nil);
    [headerView addSubview:single_price_Lab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = AppLineBlueGrayColor;
    [headerView addSubview:lineView];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

#pragma mark -- CommonTimeSelectViewDelegate
- (void)SearchClickDelegate:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    self.startTime = startTime;
    self.endTime = endTime;
    [[NSToastManager manager] showprogress];
    [self httpPath_findOne];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_findOne]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_findOne]) {
                StoreSalesPersonalListModel *listModel = (StoreSalesPersonalListModel *)parserObject;
                
                self.order_count_Lab.text = listModel.orderCount;
                self.order_price_Lab.text = listModel.orderAmountCount;
                self.single_price_Lab.text = listModel.customerTransaction;
                
                self.orderCount = listModel.orderCount;
                self.orderAmountCount = listModel.orderAmountCount;
                self.customerTransaction = listModel.customerTransaction;
                
                
                if (listModel.shopData.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.shopData];
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

/**门店销量Api*/
- (void)httpPath_findOne
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
//    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    if (self.shopPersonalId.length) {
        [parameters setValue:self.shopPersonalId forKey:@"shopPersonalId"];
    }
    [parameters setValue:self.startTime forKey:@"startDate"];
    [parameters setValue:self.endTime forKey:@"endDate"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_findOne;
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


#pragma mark -- Getter&Setter

- (CommonTimeSelectView *)timeSelectView
{
    if (!_timeSelectView) {
        _timeSelectView = [[CommonTimeSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) WithTitleArray:@[]];
        _timeSelectView.delegate = self;
    }
    return _timeSelectView;
}


- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
