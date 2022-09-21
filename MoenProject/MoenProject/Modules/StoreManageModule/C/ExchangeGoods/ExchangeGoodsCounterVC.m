//
//  ExchangeGoodsCounterVC.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "ExchangeGoodsCounterVC.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "ExchangProductInfoModel.h"
#import "OrderOperationSuccessVC.h"
#import "GiftTitleTCell.h"
#import "ExchangeGoodsSelectVC.h"
#import "ExchangeCounterVC.h"
@interface ExchangeGoodsCounterVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>


@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSDampButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *giftGoodsList;

@property (nonatomic, strong) ExchangProductInfoModel *dataModel;

@property (nonatomic, strong) NSMutableArray *pickUpDataArr;
@property (nonatomic, strong) NSMutableArray *returnTypeDataArr;
@property (nonatomic, strong) NSMutableArray *returnReasonDataArr;

@property (nonatomic, strong) NSString *returnAddress;
@property (nonatomic, strong) NSString *stockeId;
@end

@implementation ExchangeGoodsCounterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"选择换货商品";
    
    [self.view addSubview:self.tableview];
    self.tableview.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, isIphoneX?55:40, 0)) ;
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(isIphoneX?55:40);
}

- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_SelectProductInfo];
//    [self httpPath_load];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
//    [weakSelf httpPath_load];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_SelectProductInfo];
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
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        if([model.Data isKindOfClass:[SetmealinfosModel class]]){
           
            [cell showDataWithExchange:model.Data AtIndex:indexPath.section];
            
        } else {
            cell.exchangeModel = model.Data;
            cell.exchangeBlock = ^(ProductlistModel *model) {
                [self skipExchangeGoodsSelectVC:model.goodsID indexPath:indexPath];
            };
        }
        
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        if([model.Data isKindOfClass:[SetmealinfosModel class]]){
           
            [cell showDataWithExchangeGift:model.Data AtIndex:indexPath.section];
            
        } else {
            cell.exchangeModel = model.Data;
            cell.exchangeBlock = ^(ProductlistModel *model) {
                [self skipExchangeGoodsSelectVC:model.goodsID indexPath:indexPath];
            };
        }
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        return cell;
    }

    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        cell.exchangeCounterModel = model.Data;
        
        NSLog(@"KCommonSingleGiftGoodsDarkTCell  section = %d row = %d",indexPath.section,indexPath.row);
        cell.exchangeBlock = ^(ProductlistModel *model) {
//            NSLog(@"section = %d row = %d",indexPath.section,indexPath.row);
            [self skipExchangeGoodsSelectVC:model.goodsID indexPath:indexPath];
            
        };
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        cell.exchangeCounterModel = model.Data;
        
        NSLog(@"KCommonSingleGiftGoodsDarkTCell  section = %d row = %d",indexPath.section,indexPath.row);
        cell.exchangeBlock = ^(ProductlistModel *model) {
//            NSLog(@"section = %d row = %d",indexPath.section,indexPath.row);
            [self skipExchangeGoodsSelectVC:model.goodsID indexPath:indexPath];
            
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
    {
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

-(void)skipExchangeGoodsSelectVC:(NSString*)goodsID indexPath:(NSIndexPath *)indexPath{
    ExchangeGoodsSelectVC* vc = [ExchangeGoodsSelectVC new];
    vc.goodsID = goodsID;
    
    vc.selectBlock = ^(GoodslistModel * _Nonnull model) {
        CommonTVDataModel* tModel = self.floorsAarr[indexPath.section][indexPath.row];
        ProductlistModel* pmodel = tModel.Data;
        pmodel.nGoodsID = model.goodsID;
        pmodel.nGoodsSKU = model.goodsSKU;
        pmodel.nGoodsIMG = model.goodsIMG;
        pmodel.nGoodsName = model.goodsName;
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
            [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.floorsAarr removeAllObjects];
    
    //订单单品
    for (ProductlistModel *model in self.dataModel.productInfo.productList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        
//        if(model.isCan){
//
//        } else {
//            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
//        }
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        
        cellModel.Data = model;
        
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        
        [sectionArr addObject:cellModel];
     
        
        [self.floorsAarr addObject:sectionArr];
        
       
    }
    
    //订单套餐
    for (SetmealinfosModel *model in self.dataModel.productInfo.setMealInfos) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        cellModel.Data = model;
        [sectionArr addObject:cellModel];
        
        
//        for (ProductlistModel *itemModel in model.productList) {
//            //            model.actualRefundAmount = model.refundAmount;
//            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
//            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
//            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
////            if(itemModel.isCan)
////            {
////
////            } else {
////                cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
////            }
//
////            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
//            cellModel.Data = itemModel;
//            [sectionArr addObject:cellModel];
//
//        }
        model.isShowDetail = NO;
        model.isSetMeal = YES;
        [self.floorsAarr addObject:sectionArr];
        
//        for (ReturnOrderSingleGoodsModel *itemModel in model.productList) {
//
//        }
//        [self.goodsList addObject:model];
    }
    //赠品处理
    if (self.dataModel.giftInfo.productList.count + self.dataModel.giftInfo.setMealInfos.count > 0) {
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

    //赠品单品
        for (ProductlistModel *model in self.dataModel.giftInfo.productList) {
            NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
            //当前商品的Cell
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            if(model.isCan){
                cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
            } else {
                cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            }
            cellModel.Data = model;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 5;
            [sectionArr addObject:cellModel];
            
            [self.floorsAarr addObject:sectionArr];
            
            
        }
        
        //赠品套餐
        for (SetmealinfosModel *model in self.dataModel.giftInfo.setMealInfos) {
            NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
            //当前商品的Cell
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 5;
            cellModel.Data = model;
            [sectionArr addObject:cellModel];
       
            [self.floorsAarr addObject:sectionArr];
            model.isSetMeal = YES;
        }
    
    
    
    
    
}

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel* tModel =  sectionArr[indexPath.row];
    SetmealinfosModel *goodsModel = tModel.Data;
    if (isShow) {
        for (ProductlistModel *model in goodsModel.productList) {
//            model.actualRefundAmount = model.refundAmount;
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 0.01;
            cellModel.Data = model;
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
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleGiftGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel* tModel = sectionArr[indexPath.row];
    SetmealinfosModel *goodsModel = tModel.Data;
    if (isShow) {
        for (CommonProdutcModel *model in goodsModel.productList) {
//            model.actualRefundAmount = model.refundAmount;
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 0.01;
            cellModel.Data = model;
//            if([model.waitDeliverCount integerValue] != 0 && model.waitDeliverCount != nil){
//                            cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
//                        } else {
//                            if([model.deliverCount integerValue] != 0 && model.deliverCount != nil){
//                                cellModel.cellHeight = KCommonSingleGoodsDarkSelectedTCellH;
//                            } else {
//                                cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
//                                }
//                            }
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
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}


- (void)ConfirmBtnAction:(UIButton *)sender
{

    NSMutableArray *paramArr = [[NSMutableArray alloc] init];
//    CommonTVDataModel* tModel = self.floorsAarr[indexPath.section][indexPath.row];‘
    
    for (int i = 0; i < self.floorsAarr.count; i ++) {
        for (CommonTVDataModel* model in self.floorsAarr[i]) {
            
            if(model.Data != nil){
                if([model.Data isKindOfClass:[ProductlistModel class]]){
                   
                    ProductlistModel* tmodel = model.Data;
                    if(tmodel.nGoodsID != nil){
//                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                        [dic setValue:tmodel.nGoodsID forKey:@"goodsId"];
//                        [dic setValue:tmodel.goodsID forKey:@"oldGoodsId"];
//                        [dic setValue:tmodel.targetId forKey:@"targetId"];
//                        [dic setValue:tmodel.type.id forKey:@"type"];
                        [paramArr addObject:tmodel];
                    }
                }
            }
        }
    }

    if(paramArr.count > 0){
        ExchangeCounterVC* vc = [ExchangeCounterVC new];
        vc.goodlist = paramArr;
        vc.orderID =self.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[NSToastManager manager] showtoast:@"请添加换货商品"];
    }
}

#pragma mark- event response

//- (void)isConfirmReturnGoods
//{
//    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确定提换货信息吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
//    [alert show];
//}
//
//- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
//    NSLog(@"%ld", (long)buttonIndex);
//    if (buttonIndex == 1) {
//        [self httpPath_ConfirmExchange];
//    }
//}




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
            if ([operation.urlTag isEqualToString:Path_SelectProductInfo]) {
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel = [ExchangProductInfoModel mj_objectWithKeyValues:parserObject.datas[@"orderInfo"]];;
                    [self handleTableViewFloorsData];
                    
                    [self.tableview reloadData];
//                    [self updateActualRefundAmount];
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                
            }
            
            if ([operation.urlTag isEqualToString:Path_ConfirmExchange]) {
//                OrderInfoModel *model = (OrderInfoModel *)parserObject;
//                if ([model.code isEqualToString:@"200"]) {
////                    [[NSToastManager manager] showtoast:NSLocalizedString(@"return_order_success", nil)];
//                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
//                    orderOperationSuccessVC.orderID = model.ID;
//                    orderOperationSuccessVC.controllerType = OrderOperationSuccessVCTypeReturn;
//                    orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
//                }
//                else
//                {
//                    [[NSToastManager manager] showtoast:model.message];
//                }
            }
        }
    }
}

/**选择退货商品（整单退货接口共用） Api*/
- (void)httpPath_SelectProductInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_SelectProductInfo;
}


/**确认退货 Api*/
- (void)httpPath_ConfirmExchange
{
    
    
    
    
//    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    [[NSToastManager manager] showmodalityprogress];
//    self.requestURL = Path_ConfirmExchange;
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
        
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsAmountTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsAmountTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsCounterConfigTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsCounterConfigTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ReturnGoodsCounterStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"ReturnGoodsCounterStatisticsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [self.tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];

        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        
    }
    return _tableview;
}

- (NSDampButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [NSDampButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认换货" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:AppBtnDeepBlueColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:AppLineDeepGrayColor] forState:UIControlStateDisabled];
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

