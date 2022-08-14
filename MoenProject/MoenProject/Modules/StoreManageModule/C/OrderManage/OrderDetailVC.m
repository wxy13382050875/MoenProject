//
//  OrderDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "OrderDetailVC.h"
#import "CommonSingleGoodsTCell.h"
#import "OrderDetailModel.h"
#import "OrderHeaderTCell.h"
#import "CounterAddressTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderPromotionTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "SellGoodsOrderStatisticsTCell.h"
#import "OrderConfigTCell.h"
#import "OrderReturnStatusTCell.h"
#import "CommonGoodsModel.h"
#import "OrderInstallationTCell.h"
#import "GiftTitleTCell.h"
#import "OrderOperationSuccessVC.h"
#import "XWOrderDetailDefaultCell.h"

#import "xw_DeliveryInfoVC.h"
#import "XwOrderDetailVC.h"
#import "xw_AttentionItemVC.h"
@interface OrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) OrderDetailModel *dataModel;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *giftGoodsList;

@end

@implementation OrderDetailVC

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
    self.title = NSLocalizedString(@"order_detail", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderHeaderTCell" bundle:nil] forCellReuseIdentifier:@"OrderHeaderTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CounterAddressTCell" bundle:nil] forCellReuseIdentifier:@"CounterAddressTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderConfigTCell" bundle:nil] forCellReuseIdentifier:@"OrderConfigTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderStatisticsTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderReturnStatusTCell" bundle:nil] forCellReuseIdentifier:@"OrderReturnStatusTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderInstallationTCell" bundle:nil] forCellReuseIdentifier:@"OrderInstallationTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];
    
    [self.tableview registerClass:[XWOrderDetailDefaultCell class] forCellReuseIdentifier:@"XWOrderDetailDefaultCell"];
    
}

- (void)configBaseData
{
    [self httpPath_orderDetail];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_orderDetail];
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
    NSInteger goodsIndex;
    if([self.dataModel.orderStatus isEqualToString:@"waitDeliver"]){
        goodsIndex = self.dataModel.shipAddress.length > 0 ? 4:3;
    } else {
        goodsIndex = self.dataModel.shipAddress.length > 0 ? 5:4;
    }
//    NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 5:4;
    if ([model.cellIdentify isEqualToString:KOrderHeaderTCell]) {
        OrderHeaderTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTCell" forIndexPath:indexPath];
        [cell showDataWithOrderDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCounterAddressTCell]) {
        CounterAddressTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CounterAddressTCell" forIndexPath:indexPath];
        [cell showDataWithOrderDetailModel:self.dataModel];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KOrderInstallationTCell])
    {
        OrderInstallationTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInstallationTCell" forIndexPath:indexPath];
        [cell showDataWithDescription:self.dataModel.installStatus];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModel:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex -self.goodsList.count - 1];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithOrderDetailForGift:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[model.dataIndex]];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[model.dataIndex]];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCell])
    {
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModel:goodsModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForPackageGift])
    {
        
//        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModel:model.Data];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForGift])
    {
        
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModel:goodsModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForSingle])
    {
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModel:goodsModel.productList[model.dataIndex]];
        return cell;
    }
    
    
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderPromotionTCell forIndexPath:indexPath];
        [cell showDataWithOrderAcitvitiesString:self.dataModel.maxAmount WithOrderDerate:@""];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderConfigTCell])
    {
        OrderConfigTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConfigTCell" forIndexPath:indexPath];

        [cell showDataWithOrderDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderStatisticsTCell])
    {
        SellGoodsOrderStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderStatisticsTCell" forIndexPath:indexPath];

        [cell showDataWithOrderDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithString:self.dataModel.comment];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithString:self.dataModel.comment];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
    {
        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XWOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWOrderDetailDefaultCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    NSMutableArray *dataArr = self.floorsAarr[section];
    CommonTVDataModel *model = dataArr[0];
    if ([model.cellIdentify isEqualToString:KOrderPromotionTCell]) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        headerView.backgroundColor = AppBgWhiteColor;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 35)];
        [titleLab setText:@"订单促销"];
        titleLab.font = FONTSYS(14);
        [titleLab setTextColor:AppTitleBlackColor];
        [headerView addSubview:titleLab];
    }
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];

    return footerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    XwSystemTCellModel* tm = model.Data;
    
    if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]&&
        ![tm.title isEqualToString:@"发货进度"]&&
        ![tm.title isEqualToString:@"发货信息"]){
        if([tm.title isEqualToString:@"活动重点关注项"]){
//            if(self.dataModel.activityIndexList.count > 0)
            {
                xw_AttentionItemVC *attentionVC = [xw_AttentionItemVC new];
                attentionVC.hidesBottomBarWhenPushed = YES;
                attentionVC.isDetail = YES;
                attentionVC.activityIndexIdList = self.dataModel.activityIndexList;
                [self.navigationController pushViewController:attentionVC animated:YES];
            }
            
        }else {
            XwSystemTCellModel* tm = model.Data;
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = tm.deliverID;
            orderDetailVC.isHide = YES;
            
            
            if([tm.type isEqualToString:@"stocker"]){
                
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeInventoryStocker;
            } else if([tm.type isEqualToString:@"shopSelf"]){
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeDeliveryShopSelf;
            }
                
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
        
    }
}
- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger intervalNumber = 4;
    
    if([self.dataModel.orderStatus isEqualToString:@"waitDeliver"]){
        intervalNumber = self.dataModel.shipAddress.length > 0 ? 4:3;
    } else {
        intervalNumber = self.dataModel.shipAddress.length > 0 ? 5:4;
    }
    
//    if (self.dataModel.shipAddress.length > 0) {
//        intervalNumber += 1;
//    }
    CommonMealProdutcModel *goodsModel = self.goodsList[atIndex - intervalNumber];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
            
            if (model.returnCount > 0||model.deliverCount.integerValue > 0) {
                CommonTVDataModel *returnGoodsCellModel = [[CommonTVDataModel alloc] init];
                returnGoodsCellModel.cellIdentify = KOrderReturnStatusTCellForSingle;
                returnGoodsCellModel.cellHeight = KOrderReturnStatusTCellHeight;
                returnGoodsCellModel.dataIndex = cellDataIndex;
                [sectionArr addObject:returnGoodsCellModel];
            }
            cellDataIndex += 1;
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;
//        [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.productList.count, goodsModel.productList.count)];
        [sectionArr removeObjectsInRange:NSMakeRange(1, sectionArr.count - 1)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

//控制赠品套餐展示
- (void)handleGiftGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger intervalNumber = 2;
//    if (self.dataModel.shipAddress.length > 0) {
//        intervalNumber += 1;
//    }
    if([self.dataModel.orderStatus isEqualToString:@"waitDeliver"]){
        intervalNumber = self.dataModel.shipAddress.length > 0 ? 4:3;
    } else {
        intervalNumber = self.dataModel.shipAddress.length > 0 ? 5:4;
    }
    
    CommonMealProdutcModel *goodsModel = self.giftGoodsList[atIndex - intervalNumber - self.goodsList.count - 1];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
            
            if (model.returnCount > 0||model.deliverCount.integerValue > 0) {
                CommonTVDataModel *returnGoodsCellModel = [[CommonTVDataModel alloc] init];
                returnGoodsCellModel.cellIdentify = KOrderReturnStatusTCellForPackageGift;
                returnGoodsCellModel.cellHeight = KOrderReturnStatusTCellHeight;
                returnGoodsCellModel.dataIndex = cellDataIndex;
                returnGoodsCellModel.Data = model;
                [sectionArr addObject:returnGoodsCellModel];
            }
            cellDataIndex += 1;
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;
//        [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.productList.count, goodsModel.productList.count)];
        [sectionArr removeObjectsInRange:NSMakeRange(1, sectionArr.count - 1)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_orderDetail]) {
                OrderDetailModel *dataModel = (OrderDetailModel *)parserObject;
                if ([dataModel.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel = dataModel;
                    [self handleTableViewOrderHeader];
                    [self handleTableViewAddress];
                    [self handleTableViewInstall];
                    [self handleTabProgressData];
                    [self handleTabSendInfoData];
                    [self handleTableViewFloorsData];
//                    [self handleTabAppointmentData];
                    [self.tableview reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:dataModel.message];
                }
            }
        }
    }
}


#pragma  mark -- 配置楼层信息
//订单总览
-(void)handleTableViewOrderHeader{
    //订单总览
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = KOrderHeaderTCell;
    orderHeaderCellModel.cellHeight = KOrderHeaderTCellHeight;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
////地址
-(void)handleTableViewAddress{
    if (self.dataModel.shipAddress.length > 0) {
        NSMutableArray *addressArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *addressCellModel = [[CommonTVDataModel alloc] init];
        addressCellModel.cellIdentify = KCounterAddressTCell;
        addressCellModel.cellHeight = KCounterAddressTCellH;
        addressCellModel.cellHeaderHeight = 0.01;
        addressCellModel.cellFooterHeight = 5;
        [addressArr addObject:addressCellModel];
        [self.floorsAarr addObject:addressArr];
    }
}
//安装进度
-(void)handleTableViewInstall{
    if (self.dataModel.installStatus.length) {
        NSMutableArray *installationArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *installationCellModel = [[CommonTVDataModel alloc] init];
        installationCellModel.cellIdentify = KOrderInstallationTCell;
        installationCellModel.cellHeight = kOrderInstallationTCellH;
        installationCellModel.cellHeaderHeight = 0.01;
        installationCellModel.cellFooterHeight = 0.01;
        [installationArr addObject:installationCellModel];
        [self.floorsAarr addObject:installationArr];
    }
}
//发货进度
-(void)handleTabProgressData{
//    if([self.dataModel.orderStatus isEqualToString:@"waitDeliver"]){
//        self.dataModel.orderStatusText = @"待发货";
//    } else if([self.dataModel.orderStatus isEqualToString:@"partDeliver"]){
//        self.dataModel.orderStatusText = @"部分发货";
//    }else if([self.dataModel.orderStatus isEqualToString:@"allDeliver"]){
//        self.dataModel.orderStatusText = @"全部发货";
//    }
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = @"发货进度";
    model.value = [self getOrderStatus:self.dataModel.orderStatus];
    model.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = model;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}

//发货信息
-(void)handleTabSendInfoData{
    if([self.dataModel.orderStatus isEqualToString:@"waitDeliver"]){
        return;
    }
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = @"发货信息";
    
    model.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = model;
    [section4Arr addObject:delivereModel];
    
    if (self.dataModel.sendOrderInfoList.count > 0) {
        for (NSDictionary* dict in self.dataModel.sendOrderInfoList) {
            
            XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
            tmModel.title = dict[@"sendOrderTime"];;
            tmModel.value = [NSString stringWithFormat:@"%@ %@",[self getOrderTypeName:dict[@"orderType"]],[self getOrderStatus:dict[@"orderStatus"]]];
            tmModel.deliverID =dict[@"sendOrderID"];
            tmModel.showArrow = YES;
            tmModel.type = dict[@"orderType"];
            CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
            delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
            delivereModel.cellHeight = 30;
            delivereModel.cellHeaderHeight = 0.01;
            delivereModel.cellFooterHeight =  0.01;
            delivereModel.Data = tmModel;
            [section4Arr addObject:delivereModel];
        }

    } else {
        XwSystemTCellModel* model = [XwSystemTCellModel new];
        model.title = @"暂无发货信息";
        model.showArrow = NO;
        CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
        delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
        delivereModel.cellHeight = 30;
        delivereModel.cellHeaderHeight = 0.01;
        delivereModel.cellFooterHeight =  0.01;
        delivereModel.Data = model;
        [section4Arr addObject:delivereModel];
    }
    
    [self.floorsAarr addObject:section4Arr];
}
//订单单品
- (void)handleTableViewFloorsData
{
//    [self.floorsAarr removeAllObjects];
    
    //订单单品
    for (CommonProdutcModel *model in self.dataModel.orderProductList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        
        if (model.codePu.length > 0 && model.addPrice.length > 0) {
            CommonTVDataModel *returnStatusCellModel = [[CommonTVDataModel alloc] init];
            returnStatusCellModel.cellIdentify = KOrderReturnStatusTCell;
            returnStatusCellModel.cellHeight = KOrderReturnStatusTCellDHeight;
            [sectionArr addObject:returnStatusCellModel];
        }
        else if (model.codePu.length > 0 || model.addPrice.length > 0 || model.returnCount > 0|| [model.deliverCount integerValue]> 0)
        {
            CommonTVDataModel *returnStatusCellModel = [[CommonTVDataModel alloc] init];
            returnStatusCellModel.cellIdentify = KOrderReturnStatusTCell;
            returnStatusCellModel.cellHeight = KOrderReturnStatusTCellHeight;
            [sectionArr addObject:returnStatusCellModel];
        }
        
        [self.floorsAarr addObject:sectionArr];
        
        CommonMealProdutcModel *goodsModel = [[CommonMealProdutcModel alloc] init];
        goodsModel.photo = model.photo;
        goodsModel.price = model.price;
        goodsModel.count = model.count;
        goodsModel.square = model.square;
        goodsModel.code = model.sku;
        goodsModel.comboName = model.name;
        goodsModel.codePu = model.codePu;
        goodsModel.addPrice = model.addPrice;
        goodsModel.returnCount = model.returnCount;
        goodsModel.deliverCount = model.deliverCount;
        goodsModel.isSpecial = model.isSpecial;
        goodsModel.isSetMeal = NO;
        [self.goodsList addObject:goodsModel];
    }
    
    //订单套餐
    for (CommonMealProdutcModel *model in self.dataModel.orderSetMealList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
        model.isSetMeal = YES;
        [self.goodsList addObject:model];
    }
    
    
    
    //赠品处理
    if (self.dataModel.orderGiftProductList.count + self.dataModel.orderGiftSetMealList.count > 0) {
        //添加赠品
        NSMutableArray *section8Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *giftTitleCellModel = [[CommonTVDataModel alloc] init];
        giftTitleCellModel.cellIdentify = KGiftTitleTCell;
        giftTitleCellModel.cellHeight = KGiftTitleTCellH;
        giftTitleCellModel.cellHeaderHeight = 0.01;
        giftTitleCellModel.cellFooterHeight = 0.01;
        [section8Arr addObject:giftTitleCellModel];
        [self.floorsAarr addObject:section8Arr];
    }
    
    //赠品处理
    //订单单品
    for (CommonProdutcModel *model in self.dataModel.orderGiftProductList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        
        if (model.codePu.length > 0 && model.addPrice.length > 0) {
            CommonTVDataModel *returnStatusCellModel = [[CommonTVDataModel alloc] init];
            returnStatusCellModel.cellIdentify = KOrderReturnStatusTCellForGift;
            returnStatusCellModel.cellHeight = KOrderReturnStatusTCellDHeight;
            [sectionArr addObject:returnStatusCellModel];
        }
        else if (model.codePu.length > 0 || model.addPrice.length > 0 || model.returnCount > 0|| [model.deliverCount integerValue]> 0)
        {
            CommonTVDataModel *returnStatusCellModel = [[CommonTVDataModel alloc] init];
            returnStatusCellModel.cellIdentify = KOrderReturnStatusTCellForGift;
            returnStatusCellModel.cellHeight = KOrderReturnStatusTCellHeight;
            [sectionArr addObject:returnStatusCellModel];
        }
        
        [self.floorsAarr addObject:sectionArr];
        
        CommonMealProdutcModel *goodsModel = [[CommonMealProdutcModel alloc] init];
        goodsModel.photo = model.photo;
        goodsModel.price = model.price;
        goodsModel.count = model.count;
        goodsModel.square = model.square;
        goodsModel.code = model.sku;
        goodsModel.comboName = model.name;
        goodsModel.codePu = model.codePu;
        goodsModel.addPrice = model.addPrice;
        goodsModel.returnCount = model.returnCount;
        goodsModel.deliverCount = model.deliverCount;
        goodsModel.isSpecial = model.isSpecial;
        goodsModel.isSetMeal = NO;
        [self.giftGoodsList addObject:goodsModel];
    }
    
    //订单套餐
    for (CommonMealProdutcModel *model in self.dataModel.orderGiftSetMealList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
        model.isSetMeal = YES;
        [self.giftGoodsList addObject:model];
    }
    
    
    
    //订单活动
    if (self.dataModel.orderDerate.length > 0 && ![self.dataModel.orderDerate isEqualToString:@"0"]) {
        NSMutableArray *section3Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *orderActivitiesCellModel = [[CommonTVDataModel alloc] init];
        orderActivitiesCellModel.cellIdentify = KOrderPromotionTCell;
        orderActivitiesCellModel.cellHeight = KOrderPromotionTCellH;
        orderActivitiesCellModel.cellHeaderHeight = 35;
        orderActivitiesCellModel.cellFooterHeight = 5;
        [section3Arr addObject:orderActivitiesCellModel];
        [self.floorsAarr addObject:section3Arr];
    }
    //活动重点关注项
//    if ([QZLUserConfig sharedInstance].useInventory)
    {
    
        //库存参考信息
        NSMutableArray *section7Arr = [[NSMutableArray alloc] init];
        XwSystemTCellModel* model = [XwSystemTCellModel new];
        model.title = @"活动重点关注项";
        model.showArrow = YES;

        CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
        delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
        delivereModel.cellHeight = 40;
        delivereModel.cellHeaderHeight = 0.01;
        delivereModel.cellFooterHeight =  5;
        delivereModel.Data = model;
        [section7Arr addObject:delivereModel];
        [self.floorsAarr addObject:section7Arr];
    }
    
    
    //配置
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *configCellModel = [[CommonTVDataModel alloc] init];
    configCellModel.cellIdentify = KOrderConfigTCell;
    if ([self.dataModel.pickUpStatus isEqualToString:@"全部已提"]) {
        configCellModel.cellHeight = KOrderConfigTCellHeight - 41;
    }
    else
    {
        configCellModel.cellHeight = KOrderConfigTCellHeight;
    }
    configCellModel.cellHeaderHeight = 0.01;
    configCellModel.cellFooterHeight = 5;
    [section4Arr addObject:configCellModel];
    [self.floorsAarr addObject:section4Arr];
    
    //统计
    NSMutableArray *section5Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *statisticsCellModel = [[CommonTVDataModel alloc] init];
    statisticsCellModel.cellIdentify = KSellGoodsOrderStatisticsTCell;
    statisticsCellModel.cellHeight = KSellGoodsOrderStatisticsTCellH;
    if ([self.dataModel.couponDerate isEqualToString:@"0"]) {
        statisticsCellModel.cellHeight -= 30;
    }
    if ([self.dataModel.orderDerate isEqualToString:@"0"]) {
        statisticsCellModel.cellHeight -= 30;
    }
    if ([self.dataModel.shopDerate isEqualToString:@"0"]) {
        statisticsCellModel.cellHeight -= 30;
    }
    
    statisticsCellModel.cellHeaderHeight = 0.01;
    statisticsCellModel.cellFooterHeight = 5;
    [section5Arr addObject:statisticsCellModel];
    [self.floorsAarr addObject:section5Arr];
    
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
//
//自提预约时间
-(void)handleTabAppointmentData{
    
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = @"自提预约时间：";
    model.value = self.dataModel.appointmentDate;
    model.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 40;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = model;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}


/**订单详情Api*/
- (void)httpPath_orderDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_orderDetail;
}


#pragma mark -- Getter&Setter
- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList = [[NSMutableArray alloc] init];
    }
    return _goodsList;
}

- (NSMutableArray *)giftGoodsList
{
    if (!_giftGoodsList) {
        _giftGoodsList = [[NSMutableArray alloc] init];
    }
    return _giftGoodsList;
}


-(NSString*)getOrderTypeName:(NSString*)type {
    NSString* name = @"";
    if([type isEqualToString:@"shopSelf"]){
        name = @"门店自提";
    }else if([type isEqualToString:@"stocker"]){
        name = @"总仓发货";
    }
    return name;
    
}

-(NSString*)getOrderStatus:(NSString*)status{
    NSString* orderStatus= @"";
    if([status isEqualToString:@"all"]){
        orderStatus = @"全部";
    }
    else if([status isEqualToString:@"waitSub"]){
        orderStatus = @"待提交";
    }
    else if([status isEqualToString:@"wait"]){
        orderStatus = @"待审核";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"待门店审核";
        }
    } else if([status isEqualToString:@"waitDeliver"]){
        orderStatus = @"待发货";
    } else if([status isEqualToString:@"waitAllocate"]){
        orderStatus = @"待配货";
    } else if([status isEqualToString:@"allocate"]){
        orderStatus = @"配货中";
    } else if([status isEqualToString:@"partAllocate"]){
        orderStatus = @"部分配货";
    } else if([status isEqualToString:@"allAllocate"]){
        orderStatus = @"全部配货";
    } else if([status isEqualToString:@"partDeliver"]){
        orderStatus = @"部分发货";
    }else if([status isEqualToString:@"allDeliver"]){
        orderStatus = @"全部发货";
    }else if([status isEqualToString:@"finish"]){
        orderStatus = @"已完成";
        if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker||
           self.controllerType == PurchaseOrderManageVCTypeReturn){
            orderStatus = @"已收货";
        }
    }else if([status isEqualToString:@"refuse"]){
        orderStatus = @"已拒绝";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"门店已拒绝";
        }
    }else if([status isEqualToString:@"waitGoods"]){
        orderStatus = @"待收货";
    }else if([status isEqualToString:@"refuseAD"]){
        orderStatus = @"AD已拒绝";
    } else if([status isEqualToString:@"waitAD"]){
        orderStatus = @"待AD审核";
    } else if([status isEqualToString:@"stop"]){
        orderStatus = @"已终止";
    } else if([status isEqualToString:@"completed"]){
        orderStatus = @"已完成";
    } else if([status isEqualToString:@"alrea"]){
        orderStatus = @"已发货";
    }
    
    
   
    
    return orderStatus;
}
@end
