//
//  PackageRankVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageRankVC.h"
#import "CommonSaleasTCell.h"
#import "CommonTimeSelectView.h"
#import "PackageRankModel.h"
#import "KWConditionSelectView.h"

@interface PackageRankVC ()<UITableViewDelegate, UITableViewDataSource, CommonTimeSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_Top;

@property (nonatomic, strong) CommonTimeSelectView *timeSelectView;

@property (nonatomic, strong) KWConditionSelectView *conditionSelectView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *selectedDataArr;


@property (nonatomic, strong) UIButton *selectedTypeBtn;

/**筛选类型 0：销售数量  1：销售金额*/
@property (nonatomic, assign) NSInteger selectedType;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation PackageRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    if (self.isTheBest) {
        self.tableview_Top.constant = 0;
        self.title = NSLocalizedString(@"package_rank_Today", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"package_rank", nil);
        self.tableview_Top.constant = 50;
        [self.view addSubview:self.timeSelectView];
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
    if (self.isTheBest) {
        self.isToday = YES;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
        self.startTime = dateStr;
        self.endTime = dateStr;
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
    
    self.selectedDataArr = [[NSMutableArray alloc] init];
    KWCSVDataModel *f_model1 = [[KWCSVDataModel alloc] init];
    f_model1.title = @"销售数量";
    f_model1.isSelected = YES;
    [self.selectedDataArr addObject:f_model1];
    
    KWCSVDataModel *f_model2 = [[KWCSVDataModel alloc] init];
    f_model2.title = @"销售金额";
    [self.selectedDataArr addObject:f_model2];
    
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_setMealRanking];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_setMealRanking];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        //对应接口
        [weakSelf httpPath_setMealRanking];
    }];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_setMealRanking];
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
    cell.cellType = CommonSaleasTCellPackageRank;
    [cell showDataWithPackageRankModel:self.dataList[indexPath.row] WithSelectedType:self.selectedType];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel *name_Lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2, 45)];
    name_Lab.textColor = AppTitleBlackColor;
    name_Lab.textAlignment = NSTextAlignmentLeft;
    name_Lab.font = FONTLanTingR(14);
    name_Lab.text = NSLocalizedString(@"package_code", nil);
    [headerView addSubview:name_Lab];
    
    UIButton *selectedTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 45)];
    selectedTypeBtn.titleLabel.font = FONTSYS(14);
    [selectedTypeBtn setTitleColor:AppTitleBlackColor forState:UIControlStateNormal];
    
    [selectedTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
    [selectedTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    if (self.selectedType == 0) {
        [selectedTypeBtn setTitle:NSLocalizedString(@"sales_number", nil) forState:UIControlStateNormal];
    }
    else
    {
        [selectedTypeBtn setTitle:NSLocalizedString(@"sales_amount", nil) forState:UIControlStateNormal];
    }
    
    if (!self.isTheBest) {
        [selectedTypeBtn setImage:ImageNamed(@"c_detail_down_icon") forState:UIControlStateNormal];
        [selectedTypeBtn addTarget:self action:@selector(showConditionSelectView) forControlEvents:UIControlEventTouchDown];
    }
    else
    {
        [selectedTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    }
    
    
    
    
    self.selectedTypeBtn =selectedTypeBtn;
    [headerView addSubview:selectedTypeBtn];

    
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
    [self httpPath_setMealRanking];
}


- (void)showConditionSelectView
{
    WEAKSELF
    
    [self.conditionSelectView showWithArray:self.selectedDataArr WithActionBlock:^(KWCSVDataModel *model, NSInteger type) {
        if (type == 1) {
            [weakSelf handleRequestDataWith:model];
        }
    }];
}

- (void)handleRequestDataWith:(KWCSVDataModel *)model
{
    if ([model.title isEqualToString:@"销售数量"]) {
        self.selectedType = 0;
    }
    else
    {
        self.selectedType = 1;
    }
//    [self.selectedTypeBtn setTitle:model.title forState:UIControlStateNormal];
    [self handlePageSize];
    [[NSToastManager manager] showprogress];
    [self httpPath_setMealRanking];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_setMealRanking]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_setMealRanking]) {
                
                PackageRankListModel *listModel = (PackageRankListModel *)parserObject;
                
                if (listModel.setMealList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.setMealList];
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

/**套餐排名Api*/
- (void)httpPath_setMealRanking
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
    
    self.requestURL = Path_setMealRanking;
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

- (KWConditionSelectView *)conditionSelectView
{
    CGFloat marginTop = 0;
    if (self.isTheBest) {
        marginTop = 45;
    }
    else
    {
        marginTop = 90;
    }
    if (!_conditionSelectView) {
        _conditionSelectView = [[KWConditionSelectView alloc] initWithMarginTop:SCREEN_NavTop_Height + marginTop];
    }
    return _conditionSelectView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}




@end
