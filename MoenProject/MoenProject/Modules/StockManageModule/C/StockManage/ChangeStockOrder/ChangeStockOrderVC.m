//
//  ChangeStockOrderVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ChangeStockOrderVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderManageModel.h"
#import "OrderListTCell.h"
#import "XwOrderDetailVC.h"
#import "CommonCategoryModel.h"
#import "OrderScreenSideslipView.h"
#import "ChangeStockAdjustVC.h"
#import "StartCountStockVC.h"
@interface ChangeStockOrderVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource>

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

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *dataStart;

@property (nonatomic, copy) NSString *dataEnd;

@property (nonatomic, copy) NSString *orderStatus;


@end

@implementation ChangeStockOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"调库单管理";
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
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
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    Orderlist *model =self.dataList[section];
    if ([model.orderStatus isEqualToString:@"ing"]||[model.orderStatus isEqualToString:@"problem"]||[model.orderStatus isEqualToString:@"wait"]) {
        return 85;
    }
    else {
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Orderlist *model =self.dataList[indexPath.section];
        
    
    
    if (model.goodsList.count != 1) {
        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
        cell.model = model;
       
        return cell;
    }
    else
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        cell.model = model.goodsList[0];
        
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Orderlist *model = self.dataList[section];
    NSString* orderStatus;
//    调库单状态（盘库中/待审核等） all/ing/wait/pass/finish
    if([model.orderStatus isEqualToString:@"all"]){
        orderStatus = @"待提交";
    } else if([model.orderStatus isEqualToString:@"ing"]){
        orderStatus = @"调库中";
    } else if([model.orderStatus isEqualToString:@"wait"]){
        orderStatus = @"待审核";
    } else if([model.orderStatus isEqualToString:@"pass"]){
        orderStatus = @"审核不通过";
    } else if([model.orderStatus isEqualToString:@"finish"]){
        orderStatus = @"已完成";
    } else if([model.orderStatus isEqualToString:@"stop"]){
        orderStatus = @"已终止";
    } else if([model.orderStatus isEqualToString:@"problem"]){
        orderStatus = @"问题商品修正";
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.orderTime;
    [headerView addSubview:timeLab];
    
    UILabel *orderStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 15, 20)];
    orderStatusLab.font = FontBinB(14);
    orderStatusLab.textColor = AppTitleBlackColor;
    orderStatusLab.text = orderStatus;
    orderStatusLab.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:orderStatusLab];
    
    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 20)];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"调库单编号: %@",model.orderID]];
    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6, str.length - 6)];
    orderLab.attributedText = str;
    [headerView addSubview:orderLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    Orderlist *model = self.dataList[section];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = AppBgWhiteColor;
    
    UILabel *infoLab = [UILabel labelWithText:[NSString stringWithFormat:@"调库商品数量：%@件",model.goodsCount] WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentRight WithFont:14];
    [footerView addSubview:infoLab];
    infoLab.sd_layout.topEqualToView(footerView).leftSpaceToView(footerView, 15).rightSpaceToView(footerView, 15).heightIs(40);
    
    UIButton *againBtn = [UIButton buttonWithTitie:@"" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
        
        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
        orderDetailVC.orderID = model.orderID;
        orderDetailVC.controllerType = PurchaseOrderManageVCTypeLibrary;
        orderDetailVC.refreshBlock = ^{
            [self httpPath_orderList];
        };
        [self.navigationController pushViewController:orderDetailVC animated:YES];
//        if([model.orderStatus isEqualToString:@"ing"]){
//
//            StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
//            startCountStockVC.hidesBottomBarWhenPushed = YES;
//            startCountStockVC.controllerType = PurchaseOrderManageVCTypeStockAdjust;
//            startCountStockVC.goodsType = model.goodsType;
//            [self.navigationController pushViewController:startCountStockVC animated:YES];
//        } else if([model.orderStatus isEqualToString:@"wait"]){
//            NSLog(@"终止调库");
//
//            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
//            orderDetailVC.orderID = model.orderID;
//            orderDetailVC.controllerType = PurchaseOrderManageVCTypeLibrary;
//            orderDetailVC.refreshBlock = ^{
//                [self httpPath_orderList];
//            };
//            [self.navigationController pushViewController:orderDetailVC animated:YES];
//        } else if([model.orderStatus isEqualToString:@"problem"]){
//            NSLog(@"修正");
//            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
//            orderDetailVC.orderID = model.orderID;
//            orderDetailVC.controllerType = PurchaseOrderManageVCTypeLibrary;
//            orderDetailVC.refreshBlock = ^{
//                [self httpPath_orderList];
//            };
//            [self.navigationController pushViewController:orderDetailVC animated:YES];
//        }
                    
    }];
    ViewRadius(againBtn, 5)
    
    [footerView addSubview:againBtn];
    againBtn.sd_layout.topSpaceToView(infoLab, 5).rightSpaceToView(footerView, 15).heightIs(30).widthIs(90);

    NSInteger height = 85;
    if([model.orderStatus isEqualToString:@"ing"]){
        [againBtn setTitle:@"继续调库" forState:UIControlStateNormal];
    } else if([model.orderStatus isEqualToString:@"wait"]){
        [againBtn setTitle:@"终止调库" forState:UIControlStateNormal];
    } else if([model.orderStatus isEqualToString:@"problem"]){
        [againBtn setTitle:@"修正" forState:UIControlStateNormal];
    } else {
        againBtn.hidden = YES;
        height = 45;
    }
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);

    UIView *lineView = [UIView new];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    lineView.sd_layout.bottomEqualToView(footerView).leftEqualToView(footerView).rightEqualToView(footerView).heightIs(5);
    
    

    
    
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Orderlist *model = self.dataList[indexPath.section];
    
    
    XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
    orderDetailVC.orderID = model.orderID;
    orderDetailVC.controllerType = PurchaseOrderManageVCTypeLibrary;
    orderDetailVC.refreshBlock = ^{
        [self httpPath_orderList];
    };
    [self.navigationController pushViewController:orderDetailVC animated:YES];
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
                    if([tm.module isEqualToString:@"State"]){
                        weakSelf.orderStatus = tm.selectID;
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
            if ([operation.urlTag isEqualToString:Path_inventory_callInventoryOrderList]) {
                xWStockOrderModel *listModel = [xWStockOrderModel mj_objectWithKeyValues:parserObject.datas];
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
                if ([parserObject.code isEqualToString:@"200"]) {
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
                    [self.selectDataArr addObject:[self getFiltrState]];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                
            } else if([operation.urlTag isEqualToString:Path_inventory_stopCallInventory]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"调库终止成功"];
                    [self httpPath_orderList];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
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
    [parameters setValue:self.dataStart forKey:@"dateStart"];
    [parameters setValue:self.dataEnd forKey:@"dateEnd"];
    [parameters setValue:self.orderStatus forKey:@"orderStatus"];
    [parameters setValue:self.orderCode forKey:@"orderKey"];
    [parameters setValue:self.selectedTimeType forKey:@"timeQuantum"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_inventory_callInventoryOrderList;
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
-(void)httpPath_inventory_stopCallInventory:(Orderlist*)model{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: model.orderID forKey:@"inventoryNo"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_inventory_stopCallInventory;
}


#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeChangeStockOrder;
        
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
-(void)confirmAction{
    Orderlist *model = self.dataList[self.currentIndex];
    ChangeStockAdjustVC *orderDetailVC = [[ChangeStockAdjustVC alloc] init];
    orderDetailVC.model = model;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
- (void)dealloc
{
    NSLog(@"d订单列表页面释放");
}
-(XwScreenModel* )getFiltrState{
    XwScreenModel* tmModel = [XwScreenModel new];
    tmModel.className = @"State";
    NSArray* array;
    NSString* title;
    
//    else {
    title = @"盘库单状态";
    array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"调库中",@"itemId":@"ing"},
                           @{@"isSelected":@(NO),@"title":@"待审核",@"itemId":@"wait"},
                           @{@"isSelected":@(NO),@"title":@"已终止",@"itemId":@"stop"},
                           @{@"isSelected":@(NO),@"title":@"已完成",@"itemId":@"finish"},
                           @{@"isSelected":@(NO),@"title":@"问题商品修正",@"itemId":@"problem"}];
//    }
    tmModel.title = title;
    tmModel.list = [KWOSSVDataModel mj_objectArrayWithKeyValuesArray:array];
    return tmModel;
}
@end
