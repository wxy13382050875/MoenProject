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
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
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
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex -self.goodsList.count - 1];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModelForGift:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[model.dataIndex]];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[model.dataIndex]];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCell])
    {
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
        CommonMealProdutcModel *goodsModel = self.goodsList[indexPath.section - goodsIndex];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModel:goodsModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForGift])
    {
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section - goodsIndex - self.goodsList.count - 1];
        OrderReturnStatusTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReturnStatusTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModel:goodsModel];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KOrderReturnStatusTCellForSingle])
    {
        NSInteger goodsIndex = self.dataModel.shipAddress.length > 0 ? 3:2;
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
        WEAKSELF
        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
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

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger intervalNumber = 2;
    if (self.dataModel.shipAddress.length > 0) {
        intervalNumber += 1;
    }
    CommonMealProdutcModel *goodsModel = self.goodsList[atIndex - intervalNumber];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
            
            if (model.returnCount > 0) {
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
    if (self.dataModel.shipAddress.length > 0) {
        intervalNumber += 1;
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
                    [self handleTableViewFloorsData];
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
    
    
    //地址
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
    
    //安装进度
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
        else if (model.codePu.length > 0 || model.addPrice.length > 0 || model.returnCount > 0)
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
        else if (model.codePu.length > 0 || model.addPrice.length > 0 || model.returnCount > 0)
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





@end
