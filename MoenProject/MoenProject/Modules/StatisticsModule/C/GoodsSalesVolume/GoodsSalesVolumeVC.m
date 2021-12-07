//
//  GoodsSalesVolumeVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsSalesVolumeVC.h"
#import "CommonSaleasTCell.h"
#import "CommonTimeSelectView.h"
#import "GoodsSalesVolumeModel.h"

@interface GoodsSalesVolumeVC ()<UITableViewDelegate, UITableViewDataSource, CommonTimeSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_MarginTop;

@property (nonatomic, strong) CommonTimeSelectView *timeSelectView;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL isToday;


@end

@implementation GoodsSalesVolumeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}


- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"good_sales_number", nil);

    if (self.controllerType == GoodsSalesVolumeVCTypeWithSearch ||
        self.controllerType == GoodsSalesVolumeVCTypeSeller ||
        self.controllerType == GoodsSalesVolumeVCTypeLeader) {
        [self.view addSubview:self.timeSelectView];
        self.tableview_MarginTop.constant = 50;
    }
    else if (self.controllerType == GoodsSalesVolumeVCTypeItemList)
    {
        self.tableview_MarginTop.constant = 0;
    }
    else
    {
        self.title = NSLocalizedString(@"good_sales_number_Today", nil);
        self.isToday = YES;
        self.tableview_MarginTop.constant = 0;
    }
    
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSaleasTCell" bundle:nil] forCellReuseIdentifier:@"CommonSaleasTCell"];
}

- (void)configBaseData
{

    if (self.controllerType == GoodsSalesVolumeVCTypeSeller ||
        self.controllerType == GoodsSalesVolumeVCTypeLeader) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
        self.startTime = [date getMonthFirstAndLastDayWith].firstObject;
        self.endTime = dateStr;
    }
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    if (self.controllerType == GoodsSalesVolumeVCTypeItemList) {
        [self httpPath_categoryProduct];
    }
    else
    {
        [self httpPath_productSale];
    }
    
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        if (weakSelf.controllerType == GoodsSalesVolumeVCTypeItemList) {
            [weakSelf httpPath_categoryProduct];
        }
        else
        {
            [weakSelf httpPath_productSale];
        }
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        //对应接口
        if (weakSelf.controllerType == GoodsSalesVolumeVCTypeItemList) {
            [weakSelf httpPath_categoryProduct];
        }
        else
        {
            [weakSelf httpPath_productSale];
        }
    }];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    if (self.controllerType == GoodsSalesVolumeVCTypeItemList) {
        [weakSelf httpPath_categoryProduct];
    }
    else
    {
        [weakSelf httpPath_productSale];
    }
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
    GoodsSalesVolumeModel *model = self.dataList[indexPath.row];
    if ([NSTool getHeightWithContent:model.name
                                         width:SCREEN_WIDTH - 120 font:FontBinB(14) lineOffset:3] > 18) {
        return 90;
    }
    else
    {
        return 70;
    }
    return 70;
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
    CommonSaleasTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSaleasTCell" forIndexPath:indexPath];
    cell.cellType = CommonSaleasTCellGoodsNumberInfo;
    [cell showDataWithGoodsSalesVolumeModel:self.dataList[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel *name_Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/4, 45)];
    name_Lab.textColor = AppTitleBlackColor;
    name_Lab.textAlignment = NSTextAlignmentLeft;
    name_Lab.font = FONTLanTingR(14);
    name_Lab.text = NSLocalizedString(@"goods_code", nil);
    [headerView addSubview:name_Lab];
    
    UILabel *order_count_Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3 - 10, 0, SCREEN_WIDTH/4, 45)];
    order_count_Lab.textColor = AppTitleBlackColor;
    order_count_Lab.textAlignment = NSTextAlignmentCenter;
    order_count_Lab.font = FONTLanTingR(14);
    if (self.selectedType == 0) {
        order_count_Lab.text = NSLocalizedString(@"sales_number", nil);
    }
    else
    {
        order_count_Lab.text = NSLocalizedString(@"sales_amount", nil);
    }
    
    [headerView addSubview:order_count_Lab];
    
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
//    NSDictionary *itemData = [[NSDictionary alloc] init];
//    itemData = self.sectionArr[indexPath.row];
//    HelpDetailVC *helpDetailVC = [[HelpDetailVC alloc] init];
//    helpDetailVC.title = itemData[@"title"];
//    helpDetailVC.infoDic = itemData;
//    [self.navigationController pushViewController:helpDetailVC animated:YES];
}

#pragma mark -- CommonTimeSelectViewDelegate
- (void)SearchClickDelegate:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    self.startTime = startTime;
    self.endTime = endTime;
    
    self.isToday = NO;
    [self handlePageSize];
    [[NSToastManager manager] showprogress];
    [self httpPath_productSale];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_productSale]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_productSale] ||
                [operation.urlTag isEqualToString:Path_categoryProduct]) {
                
                GoodsSalesVolumeListModel *listModel = (GoodsSalesVolumeListModel *)parserObject;
                if (listModel.productList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.productList];
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

/**商品销量Api*/
- (void)httpPath_productSale
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
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
    
    self.requestURL = Path_productSale;
}

/**商品品类排名下的商品信息Api*/
- (void)httpPath_categoryProduct
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
//    [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isDay"];
    [parameters setValue:self.startTime forKey:@"startDate"];
    [parameters setValue:self.endTime forKey:@"endDate"];
    [parameters setValue:self.categoryId forKey:@"categoryId"];
    if (self.selectedType == 0) {
        [parameters setValue:@"COUNT" forKey:@"rule"];
    }
    else
    {
        [parameters setValue:@"PRICE" forKey:@"rule"];
    }
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_categoryProduct;
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
