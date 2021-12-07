//
//  ReturnOrderDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnOrderDetailVC.h"
#import "OrderHeaderTCell.h"
#import "CommonSingleGoodsTCell.h"
#import "ReturnOrderInfoModel.h"
#import "ReturnOrderDetailModel.h"
#import "ReturnGoodsCounterStatisticsTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "ReturnOrderDetailReasonTCell.h"

#import "OrderOperationSuccessVC.h"


@interface ReturnOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) ReturnOrderDetailModel *dataModel;



@end

@implementation ReturnOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
        if ([vc isKindOfClass:[OrderOperationSuccessVC class]]) {
            [marr removeObject:vc];
        }
        self.navigationController.viewControllers = marr;
    }
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"return_order_detail", nil);
    
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_returnOrderDetail];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_returnOrderDetail];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.floorsAarr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataArr = self.floorsAarr[section];
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *dataArr = self.floorsAarr[section];
    CommonTVDataModel *model = dataArr[0];
    return model.cellHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableArray *dataArr = self.floorsAarr[section];
    CommonTVDataModel *model = dataArr[0];
    return model.cellFooterHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    
    if ([model.cellIdentify isEqualToString:KOrderHeaderTCell]) {
        OrderHeaderTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        ReturnOrderDetailGoodsModel *goodsModel = self.dataModel.productList[indexPath.section - 1];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWitReturnOrderDetailGoodsModel:goodsModel];
        
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnGoodsCounterStatisticsTCell])
    {
        ReturnGoodsCounterStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsCounterStatisticsTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderDetailModel:self.dataModel];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnOrderDetailReasonTCell])
    {
        ReturnOrderDetailReasonTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderDetailReasonTCell" forIndexPath:indexPath];
        [cell showDataWithString:self.dataModel.reason];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnOrderDetailReasonTCellForPickup])
    {
        ReturnOrderDetailReasonTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderDetailReasonTCell" forIndexPath:indexPath];
        [cell showPickupWithString:self.dataModel.pickUpStatus];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnOrderDetailReasonTCellForRefund])
    {
        ReturnOrderDetailReasonTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderDetailReasonTCell" forIndexPath:indexPath];
        [cell showRefundWithString:self.dataModel.paymentMethod];
        return cell;
    }
    
    
    
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
//    NSMutableArray *dataArr = self.floorsAarr[section];
//    CommonTVDataModel *model = dataArr[0];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
//    NSMutableArray *dataArr = self.floorsAarr[section];
//    CommonTVDataModel *model = dataArr[0];
    
    return footerView;
}

#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.floorsAarr removeAllObjects];
    
    //订单总览
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = KOrderHeaderTCell;
    orderHeaderCellModel.cellHeight = KOrderHeaderTCellHeight;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
    
    //订单单品
    for (ReturnOrderDetailGoodsModel *model in self.dataModel.productList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
    }
    //提货
    NSMutableArray *pickupArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *pickupCellModel = [[CommonTVDataModel alloc] init];
    pickupCellModel.cellIdentify = KReturnOrderDetailReasonTCellForPickup;
    pickupCellModel.cellHeight = KReturnOrderDetailReasonTCellH;
    pickupCellModel.cellHeaderHeight = 0.01;
    pickupCellModel.cellFooterHeight = 1;
    [pickupArr addObject:pickupCellModel];
    [self.floorsAarr addObject:pickupArr];
    //退款方式
    NSMutableArray *refundArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *refundCellModel = [[CommonTVDataModel alloc] init];
    refundCellModel.cellIdentify = KReturnOrderDetailReasonTCellForRefund;
    refundCellModel.cellHeight = KReturnOrderDetailReasonTCellH;
    refundCellModel.cellHeaderHeight = 0.01;
    refundCellModel.cellFooterHeight = 5;
    [refundArr addObject:refundCellModel];
    [self.floorsAarr addObject:refundArr];
    
    //退货订单 统计
    NSMutableArray *statisticsSectionArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *statisticsCellModel = [[CommonTVDataModel alloc] init];
    statisticsCellModel.cellIdentify = KReturnGoodsCounterStatisticsTCell;
    statisticsCellModel.cellHeight = KReturnGoodsCounterStatisticsTCellH;
    statisticsCellModel.cellHeaderHeight = 0.01;
    statisticsCellModel.cellFooterHeight = 5;
    [statisticsSectionArr addObject:statisticsCellModel];
    [self.floorsAarr addObject:statisticsSectionArr];
    
    
    //退货原因
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = KReturnOrderDetailReasonTCell;
    markCellModel.cellHeight = KReturnOrderDetailReasonTCellH;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
    
    if ([self.dataModel.reason isEqualToString:@"其他"]) {
        //备注
        NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
        markCellModel.cellIdentify = KSellGoodsOrderMarkTCell;
        markCellModel.cellHeight = KSellGoodsOrderMarkTCellH;
        markCellModel.cellHeaderHeight = 0.01;
        markCellModel.cellFooterHeight = 5;
        [section6Arr addObject:markCellModel];
        [self.floorsAarr addObject:section6Arr];
    }

    
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_returnOrderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_returnOrderDetail]) {
                ReturnOrderDetailModel *model = (ReturnOrderDetailModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel = model;
                    [self handleTableViewFloorsData];
                    [self.tableview reloadData];
                }
                else
                {
                   self.isShowEmptyData = YES;
                }
                
            }
        }
    }
}

/**选择退货商品（整单退货接口共用） Api*/
- (void)httpPath_returnOrderDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_returnOrderDetail;
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
        [_tableview registerNib:[UINib nibWithNibName:@"OrderHeaderTCell" bundle:nil] forCellReuseIdentifier:@"OrderHeaderTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsCounterStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsCounterStatisticsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnOrderDetailReasonTCell" bundle:nil] forCellReuseIdentifier:@"ReturnOrderDetailReasonTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        
    }
    return _tableview;
}

- (ReturnOrderDetailModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[ReturnOrderDetailModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}



@end
