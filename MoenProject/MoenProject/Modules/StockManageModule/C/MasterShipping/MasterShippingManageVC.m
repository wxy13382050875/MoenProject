//
//  MasterShippingManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "MasterShippingManageVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderManageModel.h"
#import "OrderListTCell.h"
#import "XwOrderDetailVC.h"
#import "CommonCategoryModel.h"
#import "OrderScreenSideslipView.h"
#import "xWStockOrderModel.h"
@interface MasterShippingManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource>

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


@end

@implementation MasterShippingManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"总仓发货管理";
    
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
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Orderlist *model =self.dataList[indexPath.section];
        
    
    
    if (model.goodsList.count > 1) {
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
    if([model.orderStatus isEqualToString:@"waitSub"]){
        orderStatus = @"待提交";
    } else if([model.orderStatus isEqualToString:@"wait"]){
        orderStatus = @"待审核";
    } else if([model.orderStatus isEqualToString:@"waitDeliver"]){
        orderStatus = @"待发货";
    } else if([model.orderStatus isEqualToString:@"allocate"]){
        orderStatus = @"配货中";
    } else if([model.orderStatus isEqualToString:@"partDeliver"]){
        orderStatus = @"部分发货";
    }else if([model.orderStatus isEqualToString:@"allDeliver"]){
        orderStatus = @"全部发货";
    }else if([model.orderStatus isEqualToString:@"finish"]){
        orderStatus = @"已完成";
    }else if([model.orderStatus isEqualToString:@"refuse"]){
        orderStatus = @"已拒绝";
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
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@",model.orderID]];
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
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)];
    infoLab.font = FONTLanTingR(14);
    infoLab.textColor = AppTitleBlackColor;
    infoLab.textAlignment = NSTextAlignmentRight;
    
    
 //   NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%ld",(long)model.giftNum];
    //NSString *productNumCountStr = [NSString stringWithFormat:@"%ld",(long)model.productNum];
//    if (model.giftNum > 0) {
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品, %@件赠品  实付款:￥%@",(long)model.productNum,giftGoodsCountStr, model.payAmount]];
//
//        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productNum].length)];
//        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productNum].length)];
//
//        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
//        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
//
//        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
//        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
//
//
//        infoLab.attributedText = str;
//    }
//    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品",model.goodsCount]];
        
//        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productNum].length)];
//        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%ld",(long)model.productNum].length)];
//
//           [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
//           [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
           infoLab.attributedText = str;
    }

    
    [footerView addSubview:infoLab];
    
    
    UIButton *againBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90 - 16, 45, 90, 30)];
    //UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //againBtn.frame = CGRectMake(0, 40, 60, 20);
    //againBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    againBtn.titleLabel.font = FONTSYS(14);
    //againBtn.clipsToBounds = YES;
    againBtn.layer.cornerRadius = 5;
    [againBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
    [againBtn setBackgroundColor:AppTitleBlueColor];
    [againBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    //[againBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:againBtn];
    
    
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 5)];
//    lineView2.backgroundColor = AppBgBlueGrayColor;
//    [footerView addSubview:lineView2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 5)];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Orderlist *model = self.dataList[indexPath.section];
//    OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
//    orderDetailVC.orderID = model.orderID;
//    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
    Orderlist *model = self.dataList[indexPath.section];
    XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
    orderDetailVC.orderID = model.orderID;
    orderDetailVC.controllerType = PurchaseOrderManageVCTypeInventoryStocker;
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
    [self.conditionSelectView showWithArray:self.selectDataArr WithActionBlock:^(KWOSSVDataModel *model, NSInteger type) {
        weakSelf.selectedTimeType = model.itemId;
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
            if ([operation.urlTag isEqualToString:Path_inventory_generalOrderList]) {
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
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"TimeQuantum"]) {
                        [self.selectDataArr removeAllObjects];
                        
                        for (CommonCategoryDataModel *model in itemModel.datas) {
                            KWOSSVDataModel *itemModel = [[KWOSSVDataModel alloc] init];
                            if ([model.ID isEqualToString:@"ALL"]) {
                                itemModel.isSelected = YES;
                            }
                            itemModel.title = model.des;
                            itemModel.itemId = model.ID;
                            [self.selectDataArr addObject:itemModel];
                        }
                    }
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
    [parameters setValue:@"" forKey:@"orderKey"];
    [parameters setValue:@"" forKey:@"orderDateStart"];
    [parameters setValue:@"" forKey:@"orderDateEnd"];
    [parameters setValue:@"" forKey:@"orderStatus"];
//    if (self.isIdentifion) {
//        [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"identifion"];
//    }
//    [parameters setValue:self.customerId forKey:@"customerId"];
//    if (self.orderCode.length) {
//         [parameters setValue:self.orderCode forKey:@"orderCode"];
//    }
//
//    if (self.selectedTimeType.length) {
//        [parameters setValue:self.selectedTimeType forKey:@"timeQuantum"];
//    }
//    else
//    {
//        [parameters setValue:@"ALL" forKey:@"timeQuantum"];
//    }
//
//
//    [parameters setValue:@"ALL" forKey:@"type"];
   
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
//    [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isReturn"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_inventory_generalOrderList;
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
        _searchView.viewType = CommonSearchViewTypeOrder;
        
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

@end
