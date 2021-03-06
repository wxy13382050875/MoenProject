//
//  PurchaseOrderManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "InOrOutWaterVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderManageModel.h"
#import "OrderListTCell.h"
#import "OrderDetailVC.h"
#import "CommonCategoryModel.h"
#import "OrderScreenSideslipView.h"
#import "XwInOrOutWaterModel.h"
@interface InOrOutWaterVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) OrderScreenSideslipView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, strong) NSMutableArray *selectDataArr;

@property (nonatomic, copy) NSString *selectedTimeType;

@property (nonatomic, copy) NSString *dataStart;

@property (nonatomic, copy) NSString *dataEnd;

@property (nonatomic, copy) NSString *operateType;

@property (nonatomic, copy) NSString *businessType;

@end

@implementation InOrOutWaterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"出入库流水";
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    self.orderCode=@"";
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
    [self httpPath_load];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_orderList];
    [weakSelf httpPath_load];
}



#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderlistModel *model = self.dataList[indexPath.section];
    CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
//    [cell showDataWithOrderManageModel:model];
    cell.orderModel =model;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderlistModel *model = self.dataList[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.businessTime;
    [headerView addSubview:timeLab];
    
    UILabel *orderStatus = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 10, 185, 20)];
    orderStatus.font = FontBinB(14);
    orderStatus.textColor = AppTitleBlackColor;
    orderStatus.text = model.operateType;
    orderStatus.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:orderStatus];
    
    
    UILabel *serviceTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 20)];
    serviceTypeLab.font = FONTLanTingR(14);
    serviceTypeLab.textColor = AppTitleBlackColor;
    serviceTypeLab.text =[NSString stringWithFormat: @"业务类型：%@",model.businessType];
    serviceTypeLab.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:serviceTypeLab];
    
    
    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 54, SCREEN_WIDTH - 30, 20)];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    
  
    orderLab.text = model.businessID;
    [headerView addSubview:orderLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] init];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderManageModel *model = self.dataList[indexPath.section];
//    OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
//    orderDetailVC.orderID = model.ID;
//    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.orderCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
}

- (void)selectedTimeAction
{
    [self showConditionSelectView];
}


- (void)showConditionSelectView
{
    WEAKSELF
    [self.conditionSelectView showWithArray:self.selectDataArr WithActionBlock:^(XwScreenModel *model, NSInteger type) {
        //
        weakSelf.selectedTimeType= @"";
                weakSelf.dataStart = model.dateStart;
                weakSelf.dataEnd = model.dateEnd;
                for (XWSelectModel* tm in model.selectList) {
                    if([tm.module isEqualToString:@"TimeQuantum"]){
                        weakSelf.selectedTimeType = tm.selectID;
                    }
                    if([tm.module isEqualToString:@"operateType"]){
                        weakSelf.operateType = tm.selectID;
                    }
                    if([tm.module isEqualToString:@"businessType"]){
                        weakSelf.businessType = tm.selectID;
                    }
                }
        [[NSToastManager manager] showprogress];
        [weakSelf httpPath_orderList];
    }];
}
#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [weakSelf.tableview cancelRefreshAction];
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_inventory_inventoryReceipt]) {
                XwInOrOutWaterModel *listModel = [XwInOrOutWaterModel mj_objectWithKeyValues:parserObject.datas];
                if (listModel.orderList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.orderList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
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
            if ([operation.urlTag isEqualToString:Path_load]) {
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
               
                [self.selectDataArr removeAllObjects];
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"TimeQuantum"]) {
                        XwScreenModel* tmModel = [XwScreenModel new];
                        tmModel.title = @"下单时间";
                        tmModel.className = itemModel.className;
                        tmModel.showFooter =YES;
                        NSMutableArray* array = [NSMutableArray array];
                        
                        for (CommonCategoryDataModel *model in itemModel.datas) {
                            KWOSSVDataModel *itemModel = [[KWOSSVDataModel alloc] init];
                            if ([model.ID isEqualToString:@"ALL"]) {
                                itemModel.isSelected = YES;
                            }
                            itemModel.title = model.des;
                            itemModel.itemId = model.ID;
                            [array addObject:itemModel];
                        }
                        tmModel.list = array;
                        [self.selectDataArr addObject:tmModel];
                    
                    }
                }
                [self.selectDataArr addObject:[self getFiltrFlagState]];
                [self.selectDataArr addObject:[self getBusinessTypesState]];
            }
        }
    }
}

/**订单列表Api*/
- (void)httpPath_orderList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"page"];
    [parameters setValue:@(self.pageSize) forKey:@"size"];
    [parameters setValue:self.orderCode forKey:@"goodsKey"];
    [parameters setValue:self.dataStart forKey:@"dateStart"];
    [parameters setValue:self.dataEnd forKey:@"dateEnd"];
//    操作类型（出库/入库） out/in
    [parameters setValue:self.operateType forKey:@"operateType"];
//    业务类型（卖货/退货等）all/全部 卖货/sell returnGoods/退货 adAdd/ad进货 inventory/盘库 allot/调拨 withdrawal/退仓 inventoryAdjustment/库存调整
    [parameters setValue:self.businessType forKey:@"businessType"];
    [parameters setValue:self.selectedTimeType forKey:@"timeQuantum"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_inventory_inventoryReceipt;
}

/**获取下拉数据Api*/
- (void)httpPath_load
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_load;
}



#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeOutOrIn;
        
    }
    return _searchView;
}



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH, SCREEN_HEIGHT - 125) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderListTCell" bundle:nil] forCellReuseIdentifier:@"OrderListTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无订单信息";
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
- (NSMutableArray *)selectDataArr
{
    if (!_selectDataArr) {
        _selectDataArr = [[NSMutableArray alloc] init];
    }
    return _selectDataArr;
}


- (OrderScreenSideslipView *)conditionSelectView
{
    if (!_conditionSelectView) {
        _conditionSelectView = [[OrderScreenSideslipView alloc] initWithMarginTop:SCREEN_NavTop_Height];
    }
    return _conditionSelectView;
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

- (void)dealloc
{
    NSLog(@"d订单列表页面释放");
}
-(XwScreenModel* )getFiltrFlagState{
    XwScreenModel* tmModel = [XwScreenModel new];
    tmModel.className = @"operateType";
    NSArray* array;
    NSString* title;
    
//    else {
    title = @"出入库标识";
//    操作类型（出库/入库） out/in
    array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"出库",@"itemId":@"out"},
                           @{@"isSelected":@(NO),@"title":@"入库",@"itemId":@"in"}];
//    }
    tmModel.title = title;
    tmModel.list = [KWOSSVDataModel mj_objectArrayWithKeyValuesArray:array];
    
    
    return tmModel;
}
-(XwScreenModel* )getBusinessTypesState{
    
    
    
    XwScreenModel* tmModel = [XwScreenModel new];
    tmModel.className = @"businessType";
    NSArray* array;
    NSString* title;
    
//    else {
    title = @"业务类型";
//    业务类型（卖货/退货等）all/全部 卖货/sell returnGoods/退货 adAdd/ad进货 inventory/盘库 allot/调拨 withdrawal/退仓 inventoryAdjustment/库存调整
    array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"卖货",@"itemId":@"sell"},
                           @{@"isSelected":@(NO),@"title":@"退货",@"itemId":@"returnGoods"},
                           @{@"isSelected":@(NO),@"title":@"AD进货",@"itemId":@"adAdd"},
                           @{@"isSelected":@(NO),@"title":@"盘库",@"itemId":@"inventory"},
                           @{@"isSelected":@(NO),@"title":@"调拨",@"itemId":@"allot"},
                           @{@"isSelected":@(NO),@"title":@"退仓",@"itemId":@"withdrawal"},
                            @{@"isSelected":@(NO),@"title":@"库存调整",@"itemId":@"inventoryAdjustment"}];
//    }
    tmModel.title = title;
    tmModel.list = [KWOSSVDataModel mj_objectArrayWithKeyValuesArray:array];
    return tmModel;
}
@end
