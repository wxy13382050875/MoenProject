//
//  ReturnGoodsSelectVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsSelectVC.h"
#import "OrderHeaderTCell.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "ReturnOrderInfoModel.h"
#import "ReturnGoodsCounterVC.h"
#import "GiftTitleTCell.h"



@interface ReturnGoodsSelectVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSDampButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) ReturnOrderInfoModel *dataModel;


@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *giftGoodsList;


@end

@implementation ReturnGoodsSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"select_goods", nil);
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.confirmBtn];
}

- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_selectReturnProduct];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_selectReturnProduct];
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
        [cell showDataWithReturnOrderInfoModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        ReturnOrderMealGoodsModel *goodsModel = self.goodsList[indexPath.section - 1];
//        goodsModel.waitDeliverCount = @"3";
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderMealGoodsModel:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section -self.goodsList.count - 2];
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonMealProdutcModelForGift:goodsModel AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
        return cell;
    }

    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        ReturnOrderMealGoodsModel *goodsModel = self.goodsList[indexPath.section - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithReturnOrderSingleGoodsModelForReturnSelected:goodsModel.productList[indexPath.row - 1]];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        CommonMealProdutcModel *goodsModel = self.giftGoodsList[indexPath.section -self.goodsList.count - 2];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[indexPath.row - 1]];
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
    for (ReturnOrderSingleGoodsModel *model in self.dataModel.productList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
        
        ReturnOrderMealGoodsModel *goodsModel = [[ReturnOrderMealGoodsModel alloc] init];
        goodsModel.photo = model.photo;
        goodsModel.count = model.count;
        goodsModel.mealCode = model.sku;
        goodsModel.comboName = model.name;
        goodsModel.refundAmount = model.refundAmount;
        goodsModel.orderItemProductId = model.orderItemProductId;
        goodsModel.isSpecial = model.isSpecial;
        goodsModel.square = model.square;
        goodsModel.isSetMeal = NO;
        goodsModel.returnCount = 0;
        [self.goodsList addObject:goodsModel];
    }
    
    //订单套餐
    for (ReturnOrderMealGoodsModel *model in self.dataModel.setMealList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        [sectionArr addObject:cellModel];
        
        for (ReturnOrderSingleGoodsModel *singleModel in model.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
            singleModel.returnCount = 0;
            [sectionArr addObject:cellModel];
        }
        model.isShowDetail = YES;
        model.isSetMeal = YES;
        [self.floorsAarr addObject:sectionArr];
        [self.goodsList addObject:model];
    }
    
    
    //赠品数据处理
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
    
    //订单单品
    for (CommonProdutcModel *model in self.dataModel.giftProductInfos) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
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
        
//        for (ReturnOrderSingleGoodsModel *singleModel in model.productList) {
//            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
//            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
//            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
//            singleModel.returnCount = 0;
//            [sectionArr addObject:cellModel];
//        }
//        model.isShowDetail = YES;
        model.isSetMeal = YES;
        [self.floorsAarr addObject:sectionArr];
        [self.giftGoodsList addObject:model];
    }

}


- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    ReturnOrderMealGoodsModel *goodsModel = self.goodsList[atIndex - 1];
    if (isShow) {
        for (ReturnOrderSingleGoodsModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
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


- (void)handleGiftGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonMealProdutcModel *goodsModel = self.giftGoodsList[atIndex - self.goodsList.count - 2];
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


- (void)ConfirmBtnAction:(UIButton *)sender
{
    NSMutableArray *paramArr = [[NSMutableArray alloc] init];
    for (ReturnOrderMealGoodsModel *model in self.goodsList) {
        if (model.isSetMeal) {
            for (ReturnOrderSingleGoodsModel *singleModel in model.productList) {
                
                if (singleModel.returnCount > 0) {
                    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                    [paramDic setValue:[NSString stringWithFormat:@"%ld", singleModel.returnCount] forKey:@"count"];
                    [paramDic setValue:singleModel.orderItemProductId forKey:@"orderItemProductId"];
                    [paramArr addObject:paramDic];
                }
                
            }
        }
        else
        {
            if (model.returnCount > 0) {
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                [paramDic setValue:[NSString stringWithFormat:@"%ld", model.returnCount] forKey:@"count"];
                [paramDic setValue:model.orderItemProductId forKey:@"orderItemProductId"];
                [paramArr addObject:paramDic];
            }
        }
    }
    if (paramArr.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_return_number", nil)];
        return;
    }
    
    ReturnGoodsCounterVC *returnGoodsCounterVC = [[ReturnGoodsCounterVC alloc] init];
    returnGoodsCounterVC.orderID = self.orderID;
    returnGoodsCounterVC.paramArr = [paramArr copy];
    [self.navigationController pushViewController:returnGoodsCounterVC animated:YES];
}




#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_selectReturnProduct]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_selectReturnProduct]) {
                ReturnOrderInfoModel *model = (ReturnOrderInfoModel *)parserObject;
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
- (void)httpPath_selectReturnProduct
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"id"];
    if (self.controllerType == ReturnGoodsSelectVCTypeAll) {
        [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"isAll"];
    }
    else
    {
        [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isAll"];
    }
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_selectReturnProduct;
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
        [_tableview registerNib:[UINib nibWithNibName:@"OrderHeaderTCell" bundle:nil] forCellReuseIdentifier:@"OrderHeaderTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];

        
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
        [_confirmBtn setTitle:NSLocalizedString(@"c_confirm", nil) forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONTLanTingB(17);
        [_confirmBtn addTarget:self action:@selector(ConfirmBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}

- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList = [[NSMutableArray alloc] init];
    }
    return _goodsList;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

- (ReturnOrderInfoModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[ReturnOrderInfoModel alloc] init];
    }
    return _dataModel;
}
- (NSMutableArray *)giftGoodsList
{
    if (!_giftGoodsList) {
        _giftGoodsList = [[NSMutableArray alloc] init];
    }
    return _giftGoodsList;
}


@end
