//
//  OrderDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailVC.h"
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
#import "XwOrderDetailModel.h"
#import "ReturnOrderDetailReasonTCell.h"
@interface XwOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;


@property (nonatomic, strong) XwOrderDetailModel *dataModel;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *giftGoodsList;

@end

@implementation XwOrderDetailVC

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
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0)) ;
    
//    审核（同意/拒绝/发货） approve/refuse/deliver
    self.btn = [UIButton buttonWithTitie:@"同意" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor blueColor] WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"同意");
        [self httpPath_refund_returnOperate:@"approve"];
    }];
    [self.view addSubview:self.btn];
    self.btn1 = [UIButton buttonWithTitie:@"拒绝" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor] WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"拒绝");
        [self httpPath_refund_returnOperate:@"refuse"];
    }];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithTitie:@"确认发货" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor] WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"确认发货");
        [self httpPath_refund_returnOperate:@"deliver"];
    }];
    [self.view addSubview:self.btn2];
    
    self.btn.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    self.btn1.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
 
    self.btn2.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    
    self.btn.hidden = YES;
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    
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
    
    if ([model.cellIdentify isEqualToString:KOrderHeaderTCell]) {
        OrderHeaderTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderDetailModel:self.dataModel];
        cell.model = self.dataModel;
        return cell;
    }
//    else if ([model.cellIdentify isEqualToString:KCounterAddressTCell]) {
//        CounterAddressTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CounterAddressTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderDetailModel:self.dataModel];
//        return cell;
//    }
//
    else if ([model.cellIdentify isEqualToString:KOrderInstallationTCell])
    {
        OrderInstallationTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInstallationTCell" forIndexPath:indexPath];
        [cell showDataWithDescription:self.dataModel.orderApplyProgress];
        
        NSString* orderStatus;
        
        if([self.dataModel.orderApplyProgress isEqualToString:@"waitSub"]||[self.dataModel.generalOrderProgress isEqualToString:@"waitSub"]){
            orderStatus = @"待提交";
        } else if([self.dataModel.orderApplyProgress isEqualToString:@"wait"]||[self.dataModel.generalOrderProgress isEqualToString:@"wait"]){
            orderStatus = @"待审核";
        } else if([self.dataModel.orderApplyProgress isEqualToString:@"waitDeliver"]||[self.dataModel.generalOrderProgress isEqualToString:@"waitDeliver"]){
            orderStatus = @"待发货";
        } else if([self.dataModel.orderApplyProgress isEqualToString:@"allocate"]||[self.dataModel.generalOrderProgress isEqualToString:@"allocate"]){
            orderStatus = @"配货中";
        } else if([self.dataModel.orderApplyProgress isEqualToString:@"partDeliver"]||[self.dataModel.generalOrderProgress isEqualToString:@"partDeliver"]){
            orderStatus = @"部分发货";
        }else if([self.dataModel.orderApplyProgress isEqualToString:@"allDeliver"]||[self.dataModel.generalOrderProgress isEqualToString:@"allDeliver"]){
            orderStatus = @"全部发货";
        }else if([self.dataModel.orderApplyProgress isEqualToString:@"finish"]||[self.dataModel.generalOrderProgress isEqualToString:@"finish"]){
            orderStatus = @"已完成";
        }else if([self.dataModel.orderApplyProgress isEqualToString:@"refuse"]||[self.dataModel.generalOrderProgress isEqualToString:@"refuse"]){
            orderStatus = @"已拒绝";
        }
        NSString* TitleAndDsc = @"";
        if(self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
           self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
               TitleAndDsc = @"调拨申请进度";
           } else if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
               TitleAndDsc = @"退仓进度";
           } else if(self.controllerType ==PurchaseOrderManageVCTypeSTOCK){
               TitleAndDsc = @"进货申请进度";
           } else if(self.controllerType ==PurchaseOrderManageVCTypeInventoryStocker){
               TitleAndDsc = @"总仓任务进度";
           }
        [cell showDataWithTitleAndDsc:TitleAndDsc rightLab:orderStatus];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        NSInteger goodsIndex;

        if(self.controllerType ==PurchaseOrderManageVCTypeReturn||
           self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
           self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
            goodsIndex = 2;
        } else {
            goodsIndex = self.dataModel.sendOrderInfo.count > 0 ? 2:1;
        }
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        Goodslist* goodslist =self.dataModel.goodsList[indexPath.section - goodsIndex];
        goodslist.indexPath = indexPath ;
        cell.model = goodslist;
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnOrderDetailReasonTCell])
    {
        ReturnOrderDetailReasonTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderDetailReasonTCell" forIndexPath:indexPath];
        [cell showDataWithString:self.dataModel.returnReason];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        NSInteger goodsIndex;

        if(self.controllerType ==PurchaseOrderManageVCTypeReturn||
           self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
           self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
            goodsIndex = 2;
        } else {
            goodsIndex = self.dataModel.sendOrderInfo.count > 0 ? 2:1;
        }
        Goodslist *goodsModel = self.dataModel.goodsList[indexPath.section - goodsIndex];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        cell.model = goodsModel.goodsPackage.goodsList[model.dataIndex];
//        [cell showDataWithCommonProdutcModelForSearch:;
        return cell;
    }
//    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
//    {
//        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
//        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
//        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[model.dataIndex]];
//        return cell;
//    }
//
//    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCell])
//    {
//        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
//        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
//        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonMealProdutcModel:goodsModel];
//        return cell;
//    }
//    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForGift])
//    {
//        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
//        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
//        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonMealProdutcModel:goodsModel];
//        return cell;
//    }
//
//    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForSingle])
//    {
//        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
//        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
//        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonProdutcModel:goodsModel.productList[model.dataIndex]];
//        return cell;
//    }
//
//
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderPromotionTCell forIndexPath:indexPath];
//        [cell showDataWithOrderAcitvitiesString:self.dataModel.maxAmount WithOrderDerate:@""];
        return cell;
    }
//    else if ([model.cellIdentify isEqualToString:KOrderConfigTCell])
//    {
//        OrderConfigTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConfigTCell" forIndexPath:indexPath];
//
//        [cell showDataWithOrderDetailModel:self.dataModel];
//        return cell;
//    }
//    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderStatisticsTCell])
//    {
//        SellGoodsOrderStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderStatisticsTCell" forIndexPath:indexPath];
//
//        [cell showDataWithOrderDetailModel:self.dataModel];
//        return cell;
//    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithString:self.dataModel.orderRemarks];
        return cell;
    }
//
//    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
//    {
//        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
//        [cell showDataWithString:self.dataModel.comment];
//        return cell;
//    }
//
//    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
//    {
//        WEAKSELF
//        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
//        return cell;
//    }
    
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
//    NSMutableArray *dataArr = self.floorsAarr[section];
//    CommonTVDataModel *model = dataArr[0];
//    if ([model.cellIdentify isEqualToString:KCounterAddressTCell]) {
//        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
//        footerView.backgroundColor = AppBgWhiteColor;
//
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//        lineView.backgroundColor = AppBgBlueGrayColor;
//        [footerView addSubview:lineView];
//
//        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 40)];
//        [titleLab setText:@"安装进度"];
//        titleLab.font = FONTSYS(14);
//        [titleLab setTextColor:AppTitleBlackColor];
//        [footerView addSubview:titleLab];
//
//        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 85, 40)];
//        [statusLab setText:self.dataModel.installStatus];
//        statusLab.textAlignment = NSTextAlignmentRight;
//        statusLab.font = FONTSYS(14);
//        [statusLab setTextColor:AppTitleBlackColor];
//        [footerView addSubview:statusLab];
//
//        UIView *blineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
//        blineView.backgroundColor = AppBgBlueGrayColor;
//        [footerView addSubview:blineView];
//    }
    return footerView;
}

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
//    NSInteger intervalNumber = 2;
//    if (self.dataModel.shipAddress.length > 0) {
//        intervalNumber += 1;
//    }
    NSInteger goodsIndex;

    if(self.controllerType ==PurchaseOrderManageVCTypeReturn||
       self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
       self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
        goodsIndex = 2;
    } else {
        goodsIndex = self.dataModel.sendOrderInfo.count > 0 ? 2:1;
    }
    Goodslist *goodsModel = self.dataModel.goodsList[indexPath.section - goodsIndex];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (Goodslist *model in goodsModel.goodsPackage.goodsList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
//            [sectionArr insertObject:cellModel atIndex:indexPath.row];
 
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
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
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
    CommonMealProdutcModel *goodsModel = self.giftGoodsList[atIndex - intervalNumber - self.goodsList.count - 1];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
            
//            if (model.returnCount > 0) {
//                CommonTVDataModel *returnGoodsCellModel = [[CommonTVDataModel alloc] init];
//                returnGoodsCellModel.cellIdentify = KOrderReturnStatusTCellForSingle;
//                returnGoodsCellModel.cellHeight = KOrderReturnStatusTCellHeight;
//                returnGoodsCellModel.dataIndex = cellDataIndex;
//                [sectionArr addObject:returnGoodsCellModel];
//            }
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
        [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
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
            if ([operation.urlTag isEqualToString:Path_stock_orderDetail]||
                [operation.urlTag isEqualToString:Path_refund_returnOrderDetail]||
                [operation.urlTag isEqualToString:Path_dallot_transferOrderDetail]||
                [operation.urlTag isEqualToString:Path_delivery_sendOrderDetail]||
                [operation.urlTag isEqualToString:Path_inventory_generalOrderDetail]||
                [operation.urlTag isEqualToString:Path_inventory_inventoryCheckOrderDetail]||
                [operation.urlTag isEqualToString:Path_inventory_callInventoryOrderDetail]
                
                
                ) {
                XwOrderDetailModel *dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel = dataModel;
                    if(self.controllerType==PurchaseOrderManageVCTypeReturn){
                        if([self.dataModel.orderApplyProgress isEqualToString:@"wait"]){
                            self.btn.hidden = NO;
                            self.btn1.hidden = NO;
                        } else if([self.dataModel.orderApplyProgress isEqualToString:@"waitDeliver"]){
                            self.btn2.hidden = NO;
                        }
                        
                    }
                    [self handleTableViewFloorsData];
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if([operation.urlTag isEqualToString:Path_stock_orderDetail]) {
                [self httpPath_orderDetail];;
                
            }
        }
    }
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
    
    if(self.controllerType ==PurchaseOrderManageVCTypeReturn||
       self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
       self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
        NSMutableArray *installationArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *installationCellModel = [[CommonTVDataModel alloc] init];
        installationCellModel.cellIdentify = KOrderInstallationTCell;
        installationCellModel.cellHeight = kOrderInstallationTCellH;
        installationCellModel.cellHeaderHeight = 0.01;
        installationCellModel.cellFooterHeight = 0.01;
        [installationArr addObject:installationCellModel];
        [self.floorsAarr addObject:installationArr];
    } else {
        if (self.dataModel.sendOrderInfo.count > 0) {
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
    
    
    
//    for (CommonGoodsModel *model in data) {
//        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
//
//        //当前商品的Cell
//        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
//        if (!model.isSetMeal) {
//            cellModel.cellIdentify = KCommonSingleGoodsTCell;
////            cellModel.isShow = YES;
//            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
//        }
//        else
//        {
//            cellModel.cellIdentify = KCommonSingleGoodsTCell;
////            cellModel.isShow = YES;
//            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
//        }
//        [sectionArr addObject:cellModel];
//
//        if (model.isSetMeal) {
//            CommonTVDataModel *activityCellModel = [[CommonTVDataModel alloc] init];
//            activityCellModel.cellIdentify = KOrderPromotionTCell;
//            activityCellModel.cellHeight = KOrderPromotionTCellH;
////            activityCellModel.isShow = YES;
//            [sectionArr addObject:activityCellModel];
//        }
//
//        [self.floorsAarr addObject:sectionArr];
//    }
    //订单单品
    
    for (Goodslist *model in self.dataModel.goodsList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];

        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 0.01;
        
        
        if ( model.goodsPackage !=nil) {
            
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        }
        else
        {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        }
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
    }
   
    if(self.controllerType ==PurchaseOrderManageVCTypeReturn){

    
        
        
        //退货原因
        NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
        markCellModel.cellIdentify = KReturnOrderDetailReasonTCell;
        markCellModel.cellHeight = KReturnOrderDetailReasonTCellH;
        markCellModel.cellHeaderHeight = 0.01;
        markCellModel.cellFooterHeight = 5;
        [section6Arr addObject:markCellModel];
        [self.floorsAarr addObject:section6Arr];
    }
    
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



/**订单详情Api*/
- (void)httpPath_orderDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    if( self.controllerType == PurchaseOrderManageVCTypePlateStorage){
        [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
    } else {
        [parameters setValue:self.orderID forKey:@"sendOrderID"];
    }
    
    if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){
        [parameters setValue:@"order" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
        [parameters setValue:@"apply" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){
        [parameters setValue:@"shopSelf" forKey:@"orderType"];
    }else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        [parameters setValue:@"stocker" forKey:@"orderType"];
    }
   
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
        self.requestURL = Path_refund_returnOrderDetail;
    } else if(self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
              self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
        self.requestURL = Path_dallot_transferOrderDetail;
    }  else if( self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
         self.requestURL = Path_delivery_sendOrderDetail;
     } else if( self.controllerType == PurchaseOrderManageVCTypeInventoryStocker){
         self.requestURL = Path_inventory_generalOrderDetail;
     } else if( self.controllerType == PurchaseOrderManageVCTypePlateStorage){
         self.requestURL = Path_inventory_inventoryCheckOrderDetail;
     }  else if( self.controllerType == PurchaseOrderManageVCTypeLibrary){
         self.requestURL = Path_inventory_callInventoryOrderDetail;
     } else {
        self.requestURL = Path_stock_orderDetail;
    }
          
}
/**订单详情Api*/
- (void)httpPath_refund_returnOperate:(NSString*)operate
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue:operate forKey:@"operate"];
    [parameters setValue:@"" forKey:@"checkRemarks"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_refund_returnOperate;
    
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




-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = AppBgBlueGrayColor;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
//        self.comScrollerView = self.tableview;
        
        [_tableView registerNib:[UINib nibWithNibName:@"OrderHeaderTCell" bundle:nil] forCellReuseIdentifier:@"OrderHeaderTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CounterAddressTCell" bundle:nil] forCellReuseIdentifier:@"CounterAddressTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderConfigTCell" bundle:nil] forCellReuseIdentifier:@"OrderConfigTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SellGoodsOrderStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderStatisticsTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderReturnStatusTCell" bundle:nil] forCellReuseIdentifier:@"OrderReturnStatusTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderInstallationTCell" bundle:nil] forCellReuseIdentifier:@"OrderInstallationTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ReturnOrderDetailReasonTCell" bundle:nil] forCellReuseIdentifier:@"ReturnOrderDetailReasonTCell"];
        
        
    }
    return _tableView;
}


@end
