//
//  ReturnGoodsCounterVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsCounterVC.h"
#import "CommonSingleGoodsTCell.h"
#import "ReturnOrderCounterModel.h"
#import "ReturnGoodsCounterConfigTCell.h"
#import "ReturnGoodsCounterStatisticsTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "CommonCategoryModel.h"
#import "KWCommonPickView.h"
#import "OrderOperationSuccessVC.h"
#import "OrderInfoModel.h"
#import "ReturnGoodsAmountTCell.h"
#import "ReturnGoodsSelectVC.h"
#import "FDAlertView.h"
#import "GiftTitleTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
@interface ReturnGoodsCounterVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSDampButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *floorsAarr;


@property (nonatomic, strong) NSMutableArray *giftGoodsList;
@property (nonatomic, strong) ReturnOrderCounterModel *dataModel;

@property (nonatomic, strong) KWCommonPickView *kwPickView;

@property (nonatomic, strong) NSMutableArray *pickUpDataArr;
@property (nonatomic, strong) NSMutableArray *returnTypeDataArr;
@property (nonatomic, strong) NSMutableArray *returnReasonDataArr;


@end

@implementation ReturnGoodsCounterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}
 - (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    if (marr.count > 1) {
//        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
//        if ([vc isKindOfClass:[ReturnGoodsSelectVC class]]) {
//            [marr removeObject:vc];
//        }
//        self.navigationController.viewControllers = marr;
//    }
    [self httpPath_load];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"return_counter", nil);
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.confirmBtn];
}

- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_ReturnProduct];
}
- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_load];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_ReturnProduct];
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
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        ReturnOrderCounterGoodsModel *goodsModel = self.dataModel.productList[indexPath.section];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderCounterGoodsModel:goodsModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - self.dataModel.productList.count - 1];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModelForGift:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - self.dataModel.productList.count - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[indexPath.row - 1]];
        return cell;
    }
    //金额填写
    else if ([model.cellIdentify isEqualToString:KReturnGoodsAmountTCell])
    {
         ReturnOrderCounterGoodsModel *goodsModel = self.dataModel.productList[indexPath.section];
        ReturnGoodsAmountTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsAmountTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderCounterGoodsModel:goodsModel];
        cell.completeBlock = ^{
            [weakSelf updateActualRefundAmount];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnGoodsCounterConfigTCell])
    {
        ReturnGoodsCounterConfigTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsCounterConfigTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderCounterModel:self.dataModel];
        cell.configTCellSelectBlock = ^(ReturnGoodsSelectType selectType) {
            [weakSelf handleOrderConfigWithType:selectType];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnGoodsCounterStatisticsTCell])
    {
        ReturnGoodsCounterStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsCounterStatisticsTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderCounterModel:self.dataModel];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderCounterModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
    {
        WEAKSELF
        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    
    return footerView;
}

- (void)updateActualRefundAmount
{
    NSInteger totalAmount = 0;
    for (ReturnOrderCounterGoodsModel *goodsModel in self.dataModel.productList) {
        
        totalAmount += [goodsModel.actualRefundAmount integerValue];
    }
    
    self.dataModel.actualRefundAmount = totalAmount;
    //一个section刷新
    if ([self.dataModel.returnReason isEqualToString:@"其他"])
    {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.floorsAarr.count - 2];
        [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.floorsAarr.count - 1];
        [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.floorsAarr removeAllObjects];
    
    //订单单品
    for (ReturnOrderCounterGoodsModel *model in self.dataModel.productList) {
        model.actualRefundAmount = model.refundAmount;
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        
        //当前填写实退金额的Cell
        CommonTVDataModel *amountCellModel = [[CommonTVDataModel alloc] init];
        amountCellModel.cellIdentify = KReturnGoodsAmountTCell;
        amountCellModel.cellHeight = KReturnGoodsAmountTCellH;
        [sectionArr addObject:amountCellModel];
        
        [self.floorsAarr addObject:sectionArr];
    }
    
    //赠品数据配置
    if (self.dataModel.giftProductInfos.count + self.dataModel.giftOrderSetMealInfos.count > 0) {
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
    for (CommonProdutcModel *model in self.dataModel.giftProductInfos) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        
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
        goodsModel.isSpecial = model.isSpecial;
        goodsModel.isSetMeal = NO;
        [self.giftGoodsList addObject:goodsModel];
    }
    
    //订单套餐
    for (CommonMealProdutcModel *model in self.dataModel.giftOrderSetMealInfos) {
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
    
    
    
    //退货订单 配置
    NSMutableArray *configSectionArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *configCellModel = [[CommonTVDataModel alloc] init];
    configCellModel.cellIdentify = KReturnGoodsCounterConfigTCell;
    configCellModel.cellHeight = KReturnGoodsCounterConfigTCellH;
    configCellModel.cellHeaderHeight = 0.01;
    configCellModel.cellFooterHeight = 5;
    [configSectionArr addObject:configCellModel];
    [self.floorsAarr addObject:configSectionArr];
    
    
    //退货订单 统计
    NSMutableArray *statisticsSectionArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *statisticsCellModel = [[CommonTVDataModel alloc] init];
    statisticsCellModel.cellIdentify = KReturnGoodsCounterStatisticsTCell;
    statisticsCellModel.cellHeight = KReturnGoodsCounterStatisticsTCellH;
    statisticsCellModel.cellHeaderHeight = 0.01;
    statisticsCellModel.cellFooterHeight = 5;
    [statisticsSectionArr addObject:statisticsCellModel];
    [self.floorsAarr addObject:statisticsSectionArr];
    
    //备注
//    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
//    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
//    markCellModel.cellIdentify = KSellGoodsOrderMarkTCell;
//    markCellModel.cellHeight = KSellGoodsOrderMarkTCellH;
//    markCellModel.cellHeaderHeight = 0.01;
//    markCellModel.cellFooterHeight = 5;
//    [section6Arr addObject:markCellModel];
//    [self.floorsAarr addObject:section6Arr];
}

- (void)handleGiftGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonMealProdutcModel *goodsModel = self.giftGoodsList[atIndex - self.dataModel.productList.count - 1];
    if (isShow) {
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            [sectionArr addObject:cellModel];
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;
        [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.productList.count, goodsModel.productList.count)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}


    /**处理退货原因 控制页面显示*/
- (void)handleReturnReason
    {
        if ([self.dataModel.returnReason isEqualToString:@"其他"]) {
            NSMutableArray *sectionArr = self.floorsAarr.lastObject;
            CommonTVDataModel *markCellModel = sectionArr[0];
            if (markCellModel.cellIdentify != KSellGoodsOrderMarkTCell) {
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
        else
        {
            NSMutableArray *sectionArr = self.floorsAarr.lastObject;
            CommonTVDataModel *markCellModel = sectionArr[0];
            if (markCellModel.cellIdentify == KSellGoodsOrderMarkTCell) {
                [self.floorsAarr removeLastObject];
            }
            
        }
    }





- (void)ConfirmBtnAction:(UIButton *)sender
{
    if (self.dataModel.actualRefundAmount == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_refound_amount", nil)];
        return;
    }
    
    
    if (self.dataModel.pickUpStatus.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_pickup", nil)];
        return;
    }
    if (self.dataModel.returnMethod.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_refund_method", nil)];
        return;
    }
    if (self.dataModel.returnReason.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_return_reason", nil)];
        return;
    }
    if ([self.dataModel.returnReason isEqualToString:@"其他"] &&
        self.dataModel.markStr.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_return_reason", nil)];
        return;
    }
    
    //备注格式错误
    if ([Utils stringContainsEmoji:self.dataModel.markStr]) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"return_info_check", nil)];
        return;
    }
    
    [self isConfirmReturnGoods];
}

#pragma mark- event response

- (void)isConfirmReturnGoods
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确定提交退货信息吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        
        [self httpPath_saveReturnOrder];
    }
}


- (void)handleOrderConfigWithType:(ReturnGoodsSelectType)selectType
{
    if (selectType == ReturnGoodsSelectTypePickUp) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (CommonCategoryDataModel *model in self.pickUpDataArr) {
            KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
            model_1.titleName = model.des;
            model_1.ID = model.ID;
            [arr addObject:model_1];
        }
        if (arr.count == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
        }
        else
        {
            WEAKSELF
            [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
                weakSelf.dataModel.pickUpStatus = model.titleName;
                weakSelf.dataModel.pickUpStatusID = model.ID;
                [weakSelf.tableview reloadData];
                
            }];
        }
    }
    else if (selectType == ReturnGoodsSelectTypeReturnType)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (CommonCategoryDataModel *model in self.returnTypeDataArr) {
            KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
            model_1.titleName = model.des;
            model_1.ID = model.ID;
            [arr addObject:model_1];
        }
        if (arr.count == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
        }
        else
        {
            WEAKSELF
            [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
                weakSelf.dataModel.returnMethod = model.titleName;
                weakSelf.dataModel.returnMethodID = model.ID;
                [weakSelf.tableview reloadData];
            }];
        }
    }
    else if (selectType == ReturnGoodsSelectTypeReturnSeason)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (CommonCategoryDataModel *model in self.returnReasonDataArr) {
            KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
            model_1.titleName = model.des;
            model_1.ID = model.ID;
            [arr addObject:model_1];
        }
        if (arr.count == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
        }
        else
        {
            WEAKSELF
            [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
                weakSelf.dataModel.returnReason = model.titleName;
                weakSelf.dataModel.returnReasonID = model.ID;
                [weakSelf handleReturnReason];
                [weakSelf.tableview reloadData];
            }];
        }
    }
    
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_ReturnProduct]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_ReturnProduct]) {
                ReturnOrderCounterModel *model = (ReturnOrderCounterModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel = model;
                    [self handleTableViewFloorsData];
                    if (self.pickUpDataArr.count) {
                        for (CommonCategoryDataModel *model in self.pickUpDataArr) {
                            if ([model.des isEqualToString:@"已提"]) {
                                self.dataModel.pickUpStatus = model.des;
                                self.dataModel.pickUpStatusID = model.ID;
                                break;
                            }
                        }
                        if (self.dataModel.pickUpStatus.length == 0) {
                            CommonCategoryDataModel *model = self.pickUpDataArr[0];
                            self.dataModel.pickUpStatus = model.des;
                            self.dataModel.pickUpStatusID = model.ID;
                        }
                        
                        
                        
                    }
                    if (self.returnTypeDataArr.count) {
                        for (CommonCategoryDataModel *model in self.returnTypeDataArr) {
                            if ([model.des isEqualToString:@"原路返回"]) {
                                self.dataModel.returnMethod = model.des;
                                self.dataModel.returnMethodID = model.ID;
                                break;
                            }
                        }
                        
                        if (self.dataModel.pickUpStatus.length == 0) {
                            CommonCategoryDataModel *model = self.returnTypeDataArr[0];
                            self.dataModel.returnMethod = model.des;
                            self.dataModel.returnMethodID = model.ID;
                        }
                    }
                    [self.tableview reloadData];
                    [self updateActualRefundAmount];
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                
            }
            if ([operation.urlTag isEqualToString:Path_load]) {
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"ReturnPickUpStatus"]) {
                        [self.pickUpDataArr removeAllObjects];
                        [self.pickUpDataArr addObjectsFromArray:itemModel.datas];
                        
                        for (CommonCategoryDataModel *model in self.pickUpDataArr) {
                            if ([model.des isEqualToString:@"已提"]) {
                                self.dataModel.pickUpStatus = model.des;
                                self.dataModel.pickUpStatusID = model.ID;
                                break;
                            }
                        }
                        if (self.dataModel.pickUpStatus.length == 0) {
                            if (self.pickUpDataArr.count) {
                                CommonCategoryDataModel *model = self.pickUpDataArr[0];
                                self.dataModel.pickUpStatus = model.des;
                                self.dataModel.pickUpStatusID = model.ID;
                            }
                            
                        }
                    }
                    else if ([itemModel.className isEqualToString:@"RefundMethod"])
                    {
                        [self.returnTypeDataArr removeAllObjects];
                        [self.returnTypeDataArr addObjectsFromArray:itemModel.datas];
                        for (CommonCategoryDataModel *model in self.returnTypeDataArr) {
                            if ([model.des isEqualToString:@"原路返回"]) {
                                self.dataModel.returnMethod = model.des;
                                self.dataModel.returnMethodID = model.ID;
                                break;
                            }
                        }
                        if (self.dataModel.returnMethod.length == 0) {
                            if (self.returnTypeDataArr.count) {
                                CommonCategoryDataModel *model = self.returnTypeDataArr[0];
                                self.dataModel.returnMethod = model.des;
                                self.dataModel.returnMethodID = model.ID;
                            }
                        }
                    }
                    else if ([itemModel.className isEqualToString:@"ReturnReason"])
                    {
                        [self.returnReasonDataArr removeAllObjects];
                        [self.returnReasonDataArr addObjectsFromArray:itemModel.datas];
                    }
                }
                [self.tableview reloadData];
            }
            if ([operation.urlTag isEqualToString:Path_saveReturnOrder]) {
                OrderInfoModel *model = (OrderInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
//                    [[NSToastManager manager] showtoast:NSLocalizedString(@"return_order_success", nil)];
                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
                    orderOperationSuccessVC.orderID = model.ID;
                    orderOperationSuccessVC.controllerType = OrderOperationSuccessVCTypeReturn;
                    orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
        }
    }
}

/**退货柜台---部分 Api*/
- (void)httpPath_ReturnProduct
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"id"];
    [parameters setValue:self.paramArr forKey:@"orderProductList"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_ReturnProduct;
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


/**确认退货 Api*/
- (void)httpPath_saveReturnOrder
{
    NSMutableArray *paramArr = [[NSMutableArray alloc] init];
    for (ReturnOrderCounterGoodsModel *model in self.dataModel.productList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:model.orderItemProductId forKey:@"orderItemProductId"];
        [dic setValue:[NSString stringWithFormat:@"%ld", (long)model.count] forKey:@"count"];
        [dic setValue:model.refundAmount forKey:@"refundAmount"];
        [dic setValue:[NSString stringWithFormat:@"%@",model.actualRefundAmount] forKey:@"actualRefundAmount"];
        if ([model.actualRefundAmount isEqualToString:@"0"] ||
            model.actualRefundAmount.length == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_refound_amount", nil)];
            return;
        }
        [paramArr addObject:dic];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.dataModel.pickUpStatusID forKey:@"pickUpStatus"];
    [parameters setValue:self.dataModel.returnMethodID forKey:@"paymentMethod"];
    [parameters setValue:self.dataModel.returnReasonID forKey:@"reason"];
    if ([self.dataModel.returnReason isEqualToString:@"其他"]) {
        [parameters setValue:self.dataModel.markStr forKey:@"otherReson"];
    }
    [parameters setValue:self.dataModel.refundAmount forKey:@"refundAmount"];
    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.dataModel.actualRefundAmount] forKey:@"actualRefundAmount"];
    [parameters setValue:self.dataModel.ID forKey:@"id"];
    [parameters setValue:paramArr forKey:@"reshippedGoodsDataList"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_saveReturnOrder;
}


#pragma mark -- Getter&Setter
- (UITableView *)tableview
{
    if (!_tableview) {
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height - btnHeight) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsCounterConfigTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsCounterConfigTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsCounterStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsCounterStatisticsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsAmountTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsAmountTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        
        
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        
        
    }
    return _tableview;
}

- (NSDampButton *)confirmBtn
{
    if (!_confirmBtn) {
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        _confirmBtn = [NSDampButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_NavTop_Height - btnHeight, SCREEN_WIDTH, btnHeight)];
        [_confirmBtn setBackgroundColor:AppBtnDeepBlueColor];
        [_confirmBtn setTitle:NSLocalizedString(@"contirm_return", nil) forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONTLanTingB(17);
        [_confirmBtn addTarget:self action:@selector(ConfirmBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

- (NSMutableArray *)giftGoodsList
{
    if (!_giftGoodsList) {
        _giftGoodsList = [[NSMutableArray alloc] init];
    }
    return _giftGoodsList;
}

- (ReturnOrderCounterModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[ReturnOrderCounterModel alloc] init];
    }
    return _dataModel;
}

- (KWCommonPickView *)kwPickView
{
    if (!_kwPickView) {
        _kwPickView = [[KWCommonPickView alloc] initWithType:1];
    }
    return _kwPickView;
}

- (NSMutableArray *)pickUpDataArr
{
    if (!_pickUpDataArr) {
        _pickUpDataArr = [[NSMutableArray alloc] init];
    }
    return _pickUpDataArr;
}

- (NSMutableArray *)returnTypeDataArr
{
    if (!_returnTypeDataArr) {
        _returnTypeDataArr = [[NSMutableArray alloc] init];
    }
    return _returnTypeDataArr;
}


- (NSMutableArray *)returnReasonDataArr
{
    if (!_returnReasonDataArr) {
        _returnReasonDataArr = [[NSMutableArray alloc] init];
    }
    return _returnReasonDataArr;
}

@end
