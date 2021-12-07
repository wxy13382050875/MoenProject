//
//  StoreSalesVolumeVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreSalesVolumeVC.h"
#import "CommonStoreSalesVolumeTCell.h"
#import "CommonTimeSelectView.h"
#import "StoreSalesVolumeModel.h"
#import "StoreSalesPersonalVC.h"

@interface StoreSalesVolumeVC ()<UITableViewDelegate, UITableViewDataSource, CommonTimeSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_Top;


@property (weak, nonatomic) IBOutlet UILabel *order_count_Lab;

@property (weak, nonatomic) IBOutlet UILabel *order_amount_Lab;

@property (weak, nonatomic) IBOutlet UILabel *single_price_Lab;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;


@property (nonatomic, strong) CommonTimeSelectView *timeSelectView;

@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, copy) NSString *orderAmountCount;

@property (nonatomic, copy) NSString *customerTransaction;

@end

@implementation StoreSalesVolumeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    if (self.isTheBest) {
        self.title = NSLocalizedString(@"store_sales_volume_Today", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"store_sales_volume", nil);
    }
    if (self.isTheBest) {
        self.tableview_Top.constant = 0;
    }
    else
    {
        self.tableview_Top.constant = 55;
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
    if (self.isTheBest) {
        self.isToday = YES;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
        self.startTime = [date getMonthFirstAndLastDayWith].firstObject;
        self.endTime = dateStr;
    }
    
    [[NSToastManager manager] showprogress];
    [self httpPath_shopSale];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_shopSale];
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
    [cell showDataWithStoreSalesVolumeModel:self.dataList[indexPath.row] WithIsToday:self.isTheBest];
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
    name_Lab.font = FONTLanTingR(14);
    name_Lab.text = NSLocalizedString(@"clerk", nil);
    [headerView addSubview:name_Lab];
    
    UILabel *order_count_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 45)];
    order_count_Lab.textColor = AppTitleBlackColor;
    order_count_Lab.textAlignment = NSTextAlignmentCenter;
    order_count_Lab.font = FONTLanTingR(14);
    order_count_Lab.text = NSLocalizedString(@"total_number_orders", nil);
    [headerView addSubview:order_count_Lab];
    
    UILabel *order_price_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 45)];
    order_price_Lab.textColor = AppTitleBlackColor;
    order_price_Lab.font = FONTLanTingR(14);
    order_price_Lab.textAlignment = NSTextAlignmentCenter;
    order_price_Lab.text = NSLocalizedString(@"order_amount", nil);
    [headerView addSubview:order_price_Lab];
    
    UILabel *single_price_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, 45)];
    single_price_Lab.textColor = AppTitleBlackColor;
    single_price_Lab.font = FONTLanTingR(14);
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
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isTheBest) {
        return;
    }
    StoreSalesVolumeModel *model = self.dataList[indexPath.row];
    StoreSalesPersonalVC *storeSalesPersonalVC = [[StoreSalesPersonalVC alloc] init];
    storeSalesPersonalVC.shopPersonalId = model.shopPersonalId;
    storeSalesPersonalVC.startTime = self.startTime;
    storeSalesPersonalVC.endTime = self.endTime;
    [self.navigationController pushViewController:storeSalesPersonalVC animated:YES];
}

#pragma mark -- CommonTimeSelectViewDelegate
- (void)SearchClickDelegate:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    self.startTime = startTime;
    self.endTime = endTime;
    [[NSToastManager manager] showprogress];
    [self httpPath_shopSale];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_shopSale]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_shopSale]) {
                
                StoreSalesVolumeListModel *listModel = (StoreSalesVolumeListModel *)parserObject;
                self.order_count_Lab.text = listModel.orderCount;
                self.order_amount_Lab.text = listModel.orderAmountCount;
                self.single_price_Lab.text = listModel.customerTransaction;
                
                self.orderCount = listModel.orderCount;
                self.orderAmountCount = listModel.orderAmountCount;
                self.customerTransaction = listModel.customerTransaction;
                
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:listModel.shopData];
                [self.tableview reloadData];
                if (listModel.shopData.count > 0) {
                    self.isShowEmptyData = NO;
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                
            }
        }
    }
}

/**门店销量Api*/
- (void)httpPath_shopSale
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.isToday) {
        [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"isDay"];
    }
    else
    {
        [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isDay"];
        [parameters setValue:self.startTime forKey:@"startDate"];
        [parameters setValue:self.endTime forKey:@"endDate"];
    }
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_shopSale;
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
