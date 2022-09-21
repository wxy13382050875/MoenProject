//
//  SalesCounterVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SalesCounterVC.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "CounterAddressTCell.h"
#import "AddressListVC.h"
#import "SellGoodsOrderConfigTCell.h"
#import "SellGoodsOrderStatisticsTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "OrderPromotionTCell.h"
#import "KWCommonPickView.h"
#import "CommonCategoryModel.h"

#import "CommonGoodsModel.h"
#import "SalesCounterDataModel.h"
#import "SalesCounterConfigModel.h"
#import "OrderInfoModel.h"
#import "OrderOperationSuccessVC.h"
#import "CommonCouponPopView.h"
#import "FDAlertView.h"
#import "AddressAddVC.h"
#import "GiftAddTCell.h"
#import "SearchGoodsVC.h"
#import "GiftTitleTCell.h"
#import "XWOrderDetailDefaultCell.h"
#import "XwSystemTCellModel.h"
#import "xw_StockInfoVC.h"
#import "xw_AttentionItemVC.h"
@interface SalesCounterVC ()<UITableViewDelegate, UITableViewDataSource, AddressListVCDelegate, CommonCouponPopViewDelegate, FDAlertViewDelegate, AddressAddVCDelegate, SearchGoodsVCDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIButton *reserveBtn;//提交预定订单

@property (nonatomic, strong) UIButton *formalBtn;//提交正式订单
//@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *pickUpDataArr;
@property (nonatomic, strong) NSMutableArray *deliveryDataArr;
@property (nonatomic, strong) NSMutableArray *receivablesDataArr;


/**用户资产id*/
@property (nonatomic, copy) NSString *assetId;
/**门店优惠金额*/
@property (nonatomic, copy) NSString *shopDerate;
/**地址id*/
@property (nonatomic, copy) NSString *addressId;


@property (nonatomic, strong) KWCommonPickView *kwPickView;



@property (nonatomic, strong) SalesCounterConfigModel *configModel;


/**当前操作的位置*/
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger giftGoodsCount;

@property (nonatomic, assign) BOOL isCanOperation;

@property (nonatomic, assign) BOOL isUseAddress;
//是否添写
@property (nonatomic, strong) NSArray* attentionArry;

@property (nonatomic, strong) NSMutableArray *giftDataArr;
//判断是否提示重点关注项
@property (nonatomic, assign) BOOL isShowAlert;


//判断是否提交订金
@property (nonatomic, assign) BOOL isReserveAmount;

//判断是否提交尾款
@property (nonatomic, assign) BOOL isRemainAmount;

//是否预定 默认false（新增）
@property (nonatomic, assign) BOOL isReserve;


@end

@implementation SalesCounterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.kwPickView releasePickView];
    self.kwPickView = nil;
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    self.title = NSLocalizedString(@"sales_Counter", nil);
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.confirmBtn];
//    [self.view addSubview:self.reserveBtn];
//    [self.view addSubview:self.formalBtn];
    CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
    self.tableview.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, btnHeight, 0)) ;
    
    self.confirmBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(btnHeight);
    
//    self.reserveBtn.sd_layout.leftEqualToView(self.view).bottomEqualToView(self.view).heightIs(btnHeight).widthIs(SCREEN_WIDTH/2);
//
//    self.formalBtn.sd_layout.rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(btnHeight).widthIs(SCREEN_WIDTH/2);
//
//    self.confirmBtn.hidden = YES;
//    self.reserveBtn.hidden = YES;
//    self.formalBtn.hidden = YES;
}

- (void)configBaseData
{
    self.isShowAlert = NO;
    self.isCanOperation = YES;
    self.isUseAddress = YES;
    if(self.type == SalesCounterTypeNone){
        [self httpPath_sale];
    } else {
        
        [self.dataArr removeAllObjects];
        //处理预定商品单品和套餐
        if(self.counterDataModel.orderProductList.count > 0){
            for (CommonGoodsModel* model in self.counterDataModel.orderProductList) {
                model.isSetMeal = NO;
                model.gcode = model.sku;
                [self.dataArr addObject:model];
            }
        }
        if(self.counterDataModel.orderSetMealList.count > 0){
            for (CommonGoodsModel* model in self.counterDataModel.orderSetMealList) {
                model.isSetMeal = YES;
                model.name = model.comboName;
                model.gcode = model.code;
                
                [self.dataArr addObject:model];
            }
        }
        //处理预定商品赠品单品和套餐
        if(self.counterDataModel.orderGiftProductList.count > 0){
            for (CommonGoodsModel* model in self.counterDataModel.orderGiftProductList) {
                model.isSetMeal = NO;
                model.gcode = model.sku;
                [self.giftDataArr addObject:model];
            }
        }
        if(self.counterDataModel.orderGiftSetMealList.count > 0){
            for (CommonGoodsModel* model in self.counterDataModel.orderGiftSetMealList) {
                model.isSetMeal = YES;
                model.name = model.comboName;
                model.gcode = model.code;
                [self.giftDataArr addObject:model];
            }
        }
        for (CommonGoodsModel *model in self.dataArr) {
            
            model.kGoodsCount = model.count;
            model.kGoodsCode = model.codePu;
            model.kGoodsArea = model.square;
        }
        for (CommonGoodsModel *model in self.giftDataArr) {
            
            model.kGoodsCount = model.count;
            model.kGoodsCode = model.codePu;
            model.kGoodsArea = model.square;
        }
        [self handleTableViewFloorsData];
        [self handelConfigTCellAndStatisticsTCellHeight];
        [self.tableview reloadData];
    }
    
    [self httpPath_load];
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
    
    if ([model.cellIdentify isEqualToString:KCounterAddressTCell]) {
        CounterAddressTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CounterAddressTCell" forIndexPath:indexPath];
        [cell showDataWithSalesCounterDataModel:self.counterDataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForSalesCounter:model.Data AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
//            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        cell.goodsNumberChangeBlock = ^{
            [weakSelf httpPath_sale];
        };
        return cell;
    }
    
    //赠品展示
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
//        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForGift:model.Data AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        cell.goodsNumberChangeBlock = ^{
            [weakSelf httpPath_sale];
        };
        return cell;
    }
    
    
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
//        CommonGoodsModel *goodsModel = self.dataArr[indexPath.section - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:model.Data];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
//        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
//        CommonGoodsModel *goodsModel = self.giftDataArr[indexPath.section - beginIndex - self.dataArr.count];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:model.Data];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderPromotionTCell forIndexPath:indexPath];
        [cell showDataWithOrderAcitvitiesString:self.counterDataModel.rules WithOrderDerate:@""];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderConfigTCell])
    {
        SellGoodsOrderConfigTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderConfigTCell" forIndexPath:indexPath];
        [cell showDataWithSalesCounterConfigModel:self.configModel WithUsableCount:self.counterDataModel.useCouponList.count WithUnUsableCount:self.counterDataModel.notUseCouponList.count WithCouponAmount:self.counterDataModel.couponDerate];
        cell.orderConfigTCellSelectBlock = ^(SelectType selectType) {
            [weakSelf handleOrderConfigWithType:selectType];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderStatisticsTCell])
    {
        SellGoodsOrderStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderStatisticsTCell" forIndexPath:indexPath];
        [cell showDataWithSalesCounterDataModel:self.counterDataModel WithGoodsCount:self.goodsCount WithGiftGoodsCount:self.giftGoodsCount];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showDataWithSalesCounterConfigModel:self.configModel];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KGiftAddTCell])
    {
        WEAKSELF
        GiftAddTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftAddTCell" forIndexPath:indexPath];
        cell.cellSelectedActionBlock = ^{
            [weakSelf addGiftButtonClick];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
    {
        WEAKSELF
        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
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
        [titleLab setText:NSLocalizedString(@"order_promotion", nil)];
        titleLab.font = FONTLanTingR(14);
        [titleLab setTextColor:AppTitleBlackColor];
        [headerView addSubview:titleLab];
    }
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    NSMutableArray *dataArr = self.floorsAarr[section];
    CommonTVDataModel *cellModel = dataArr[0];
    if ([cellModel.cellIdentify isEqualToString:KCommonSingleGoodsTCell]) {
        CommonGoodsModel *model =  cellModel.Data;
        if (model.isSpecial) {
            CGFloat marginTop = 0;
            CGFloat marginLeft = SCREEN_WIDTH - 95;
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, cellModel.cellFooterHeight);
            footerView.backgroundColor = AppBgWhiteColor;
            if (model.kAddPrice > 0) {
                UILabel *addPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                addPriceLab.font = FONTSYS(13);
                addPriceLab.textColor = AppTitleBlueColor;
                addPriceLab.tag = 5000 + section;
                addPriceLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改增项加价");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Reserve_code", nil) alterType:FDAltertViewTypeEditInputPrice message:[NSString stringWithFormat:@"%.2f",model.kAddPrice] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                    
                }];
                [addPriceLab addGestureRecognizer:tap];
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"增项加价：¥%.2f",model.kAddPrice] attributes:attribtDic];
                addPriceLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:addPriceLab];
            }
            if (model.kGoodsCode.length > 0) {
                UILabel *goodsCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                goodsCodeLab.font = FONTSYS(13);
                goodsCodeLab.textColor = AppTitleBlueColor;
                goodsCodeLab.tag = 6000 + section;
                goodsCodeLab.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改PO单号");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeEditInputCode message:model.kGoodsCode delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                    
                }];
                [goodsCodeLab addGestureRecognizer:tap];
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"PO单号：%@",model.kGoodsCode] attributes:attribtDic];
                goodsCodeLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:goodsCodeLab];
            }
            if (model.reserveAmount > 0) {
                UILabel *reserveAmountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                reserveAmountLab.font = FONTSYS(13);
                reserveAmountLab.textColor = AppTitleBlueColor;
                reserveAmountLab.tag = 100 + section;
                reserveAmountLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改订金");
                    if(self.type == SalesCounterTypeReserve){
                        
                    } else {
                        self.currentIndex = section;
                        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Reserve_code", nil) alterType:FDAltertViewTypeEditInputDepositPrice message:[NSString stringWithFormat:@"%.2f",model.reserveAmount] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                           [alert show];
                    }
                    
                    
                }];
                [reserveAmountLab addGestureRecognizer:tap];
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"交定金：¥%.2f",model.reserveAmount] attributes:attribtDic];
                reserveAmountLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:reserveAmountLab];
            }
            if (model.remainAmount > 0) {
                UILabel *remainAmountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                remainAmountLab.font = FONTSYS(13);
                remainAmountLab.textColor = AppTitleBlueColor;
                remainAmountLab.tag = 100 + section;
                remainAmountLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改订金");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Remain_code", nil) alterType:FDAltertViewTypeEditInputRemainPrice message:[NSString stringWithFormat:@"%.2f",model.remainAmount] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                       [alert show];
                    
                }];
                [remainAmountLab addGestureRecognizer:tap];
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"尾款：¥%.2f",model.remainAmount] attributes:attribtDic];
                remainAmountLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:remainAmountLab];
            }
            CGFloat footerHeight = 90;
            if(model.remainAmount > 0&&
               self.type == SalesCounterTypeReserve){
                footerHeight = 120;
            }
            if (marginTop < footerHeight) {
                UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, 1)];
                lineTopView.backgroundColor = AppBgBlueGrayColor;
                [footerView addSubview:lineTopView];
            }
            if (model.kGoodsCode.length == 0) {
                UIButton *codeBtn = [UIButton buttonWithTitie:@"PO单号" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                    NSLog(@"新增PO单号");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeInputCode message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }];
                ViewBorderRadius(codeBtn, 15, 1, AppTitleBlueColor);
                codeBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                [footerView addSubview:codeBtn];
                marginLeft -= 90;
            }
            if (model.kAddPrice == 0) {
                UIButton *priceBtn = [UIButton buttonWithTitie:@"增项加价" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                    NSLog(@"增项加价");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Reserve_code", nil) alterType:FDAltertViewTypeInputPrice message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }];
                ViewBorderRadius(priceBtn, 15, 1, AppTitleBlueColor);
                priceBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                [footerView addSubview:priceBtn];
                marginLeft -= 90;
            }
            if (model.reserveAmount == 0) {
                
                UIButton *reserveBtn = [UIButton buttonWithTitie:@"交定金" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                    NSLog(@"交定金");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Reserve_code", nil) alterType:FDAltertViewTypeInputDepositPrice message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }];
                ViewBorderRadius(reserveBtn, 15, 1, AppTitleBlueColor);
                reserveBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                [footerView addSubview:reserveBtn];
                marginLeft -= 90;
            } else {
                
                if (model.remainAmount == 0&&
                    self.type == SalesCounterTypeReserve) {
                    
                    UIButton *remainBtn = [UIButton buttonWithTitie:@"交尾款" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                        NSLog(@"交尾款");
                        self.currentIndex = section;
                        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_Remain_code", nil) alterType:FDAltertViewTypeInputRemainPrice message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                        [alert show];
                    }];
                    ViewBorderRadius(remainBtn, 15, 1, AppTitleBlueColor);
                    remainBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                    [footerView addSubview:remainBtn];
                }
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellModel.cellFooterHeight - 5, SCREEN_WIDTH, 5)];
            lineView.backgroundColor = AppBgBlueGrayColor;
            [footerView addSubview:lineView];
        }
    }
    
    if ([cellModel.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift]) {
//        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
        CommonGoodsModel *model =  cellModel.Data;
        if (model.isSpecial) {
            CGFloat marginTop = 0;
            CGFloat marginLeft = SCREEN_WIDTH - 95;
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, cellModel.cellFooterHeight);
            footerView.backgroundColor = AppBgWhiteColor;
            if (model.kAddPrice > 0) {
                UILabel *addPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                addPriceLab.font = FONTSYS(13);
                addPriceLab.textColor = AppTitleBlueColor;
                addPriceLab.tag = 5000 + section;
                addPriceLab.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改赠品增项加价");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeEditInputPriceForGift message:[NSString stringWithFormat:@"%.2f",model.kAddPrice] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                    
                }];
                [addPriceLab addGestureRecognizer:tap];
                
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"增项加价：¥%.2f",model.kAddPrice] attributes:attribtDic];
                addPriceLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:addPriceLab];
            }
            if (model.kGoodsCode.length > 0) {
                UILabel *goodsCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, marginTop, 200, 20)];
                goodsCodeLab.font = FONTSYS(13);
                goodsCodeLab.textColor = AppTitleBlueColor;
                goodsCodeLab.tag = 6000 + section;
                goodsCodeLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                         
                    NSLog(@"修改赠品增项加价");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeEditInputCodeForGift message:model.kGoodsCode delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                    
                }];
                // 下划线
                NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"PO单号：%@",model.kGoodsCode] attributes:attribtDic];
                goodsCodeLab.attributedText = attribtStr;
                marginTop += 30;
                [footerView addSubview:goodsCodeLab];
            }
            
            if (marginTop < 60) {
                UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, 1)];
                lineTopView.backgroundColor = AppBgBlueGrayColor;
                [footerView addSubview:lineTopView];
            }
            if (model.kGoodsCode.length == 0) {
              
                
                
                UIButton *codeBtn = [UIButton buttonWithTitie:@"PO单号" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                    NSLog(@"新增PO单号");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeInputCodeForGift message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }];
                ViewBorderRadius(codeBtn, 15, 1, AppTitleBlueColor);
                codeBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                [footerView addSubview:codeBtn];
                marginLeft -= 90;
            }
            if (model.kAddPrice == 0) {
                
                UIButton *priceBtn = [UIButton buttonWithTitie:@"增项加价" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:13 EventBlock:^(id  _Nonnull params) {
                    NSLog(@"增项加价");
                    self.currentIndex = section;
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeInputPriceForGift message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }];
                ViewBorderRadius(priceBtn, 15, 1, AppTitleBlueColor);
                priceBtn.frame = CGRectMake(marginLeft, marginTop + 10, 80, 30);
                [footerView addSubview:priceBtn];
                marginLeft -= 90;
            }

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellModel.cellFooterHeight - 5, SCREEN_WIDTH, 5)];
            lineView.backgroundColor = AppBgBlueGrayColor;
            [footerView addSubview:lineView];
        }
    }
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    if ([model.cellIdentify isEqualToString:KCounterAddressTCell]) {
        [self skipToAddressListVC];
    } else if([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        NSLog(@"库存参考信息");
        XwSystemTCellModel* tm = model.Data;
        if([tm.title isEqualToString:@"库存参考信息"]){
            xw_StockInfoVC *storeInfoVC = [xw_StockInfoVC new];
            storeInfoVC.array = [self.dataArr copy];
            storeInfoVC.giftArray = [self.giftDataArr copy];
            storeInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeInfoVC animated:YES];
        }else {
            if(self.counterDataModel.isActivity)
            {
                xw_AttentionItemVC *attentionVC = [xw_AttentionItemVC new];
                attentionVC.hidesBottomBarWhenPushed = YES;
                attentionVC.isDetail = NO;
                if(self.attentionArry.count > 0){
                    attentionVC.activityIndexIdList = self.attentionArry;
                }
                attentionVC.refreshBlock = ^(NSArray * _Nonnull array) {
                    self.attentionArry = array;
                    [self httpPath_sale];
                };
                
                [self.navigationController pushViewController:attentionVC animated:YES];
            }
            
        }
        
    }
}
#pragma mark -- AddressListVCDelegate
- (void)AddressListVCSelectedDelegate:(NSString *)addressID
{
    self.counterDataModel.addressId = addressID;
    if ([addressID isEqualToString:@"0"]) {
        self.isUseAddress = NO;
    }
    else
    {
        self.isUseAddress = YES;
    }
    [self httpPath_sale];
}

- (void)AddressAddVCSelectedDelegate:(NSString *)addressID
{
//    self.counterDataModel.addressId = addressID;
    [self httpPath_sale];
}



- (void)ConfirmBtnAction
{
    
    if (self.isDamping) {
        return;
    }
    
    if(self.counterDataModel.isActivity&&
           self.attentionArry.count == 0 &&
           !self.isShowAlert){
            [[NSToastManager manager] showtoast:@"请确认是否填写重点关注项"];
            self.isShowAlert = YES;
            return;
        }
    
    self.isDamping = YES;
    self.isReserveAmount = NO;
    self.isRemainAmount = NO;
    //判断淋浴房单品是有填写PO单号
    BOOL isAllAdd = YES;//判断订金是否全部填写
    for (CommonGoodsModel *model in self.dataArr) {
        if (!model.isSetMeal && model.isSpecial)
        {
            if (model.kGoodsCode.length == 0) {
                [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_pocode", nil)];
                self.isDamping = NO;
                return;
            }
            if(model.reserveAmount != 0){//卖货柜台，只要填写一个订金，生成预定订单，未填写生成正式订单
                self.isReserveAmount = YES;
            } else {
                isAllAdd = NO;
            }
        
        }
    }
    if (!isAllAdd) {
        [[NSToastManager manager] showtoast:@"订金必须全部填写完成才可提交"];
        self.isDamping = NO;
        return;
    }
    BOOL isSame = NO;//用于判断尾款是否全部填写，如果部分未填写生成预定订单，全部填写生成正式订单
    for (CommonGoodsModel *model in self.dataArr) {
        if (!model.isSetMeal && model.isSpecial)
        {
            if(model.remainAmount == 0){
                isSame = YES;
                
            }
        }
    }
    if(isSame){
        self.isRemainAmount = YES;
    } else {
        self.isRemainAmount = NO;
    }
    //判断淋浴房单品是有填写PO单号
    for (CommonGoodsModel *model in self.giftDataArr) {
        if (!model.isSetMeal && model.isSpecial)
        {
            if (model.kGoodsCode.length == 0) {
                [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_pocode", nil)];
                self.isDamping = NO;
                return;
            }
           
        }
    }
    
    
    
    if (self.configModel.pickUpStatusID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_pickup", nil)];
        self.isDamping = NO;
        return;
    }
    if (self.configModel.shoppingMethodID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_delivery", nil)];
        self.isDamping = NO;
        return;
    }
    if (self.configModel.paymentMethodID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_payment", nil)];
        self.isDamping = NO;
        return;
    }
    //备注格式错误
    if ([Utils stringContainsEmoji:self.configModel.info]) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"mark_info_check", nil)];
        self.isDamping = NO;
        return;
    }
    
    if (!self.isCanOperation) {
        return;
    }
    
    self.isCanOperation = NO;
    [self isConfirmSubmitOrder];
}

#pragma mark- event response

- (void)isConfirmSubmitOrder
{
    NSString* message = @"";
    if(self.type == SalesCounterTypeNone){
        if (self.isReserveAmount) {
            self.isReserve = YES;
        } else {
            self.isReserve = NO;
        }
    } else {
        if (self.isRemainAmount) {
            self.isReserve = YES;
        } else {
            self.isReserve = NO;
        }
    }
    if (self.isReserve) {
        message = @"商品中存在定金信息，确认生成预定订单吗？";
    } else {
        message = @"商品中不存在定金信息，确认生成正式订单吗，生成后不支持进行信息修改？";
        
    }
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:message delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)addGiftButtonClick
{
    SearchGoodsVC *searchGoodsVC = [[SearchGoodsVC alloc] init];
    searchGoodsVC.delegate = self;
    if (self.giftDataArr.count) {
        searchGoodsVC.selectedDataArr = [self.giftDataArr mutableCopy];
    }
    searchGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchGoodsVC animated:YES];
}


#pragma mark -- SearchGoodsVCDelegate
- (void)SearchGoodsVCSelectedDelegate:(id)goodsModel
{
    self.giftDataArr = (NSMutableArray *)goodsModel;
//    for (id model in goodsModel) {
//        [self handleGoodsNumberWithGoodsModel:model];
//    }
//
//    [self.tableview reloadData];
    [self handleTableViewFloorsData];
    [self handelConfigTCellAndStatisticsTCellHeight];
    [self.tableview reloadData];
}


#pragma mark -- FDAlertViewDelegate
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr
{
    
    if (alertView.alterType == FDAltertViewTypeInputPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsAddPrice:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    if (alertView.alterType == FDAltertViewTypeInputPriceForGift) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsAddPriceForgift:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
    }
    if (alertView.alterType == FDAltertViewTypeEditInputPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsAddPrice:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
        else
        {
            [self handleSpecialGoodsAddPrice:0 WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    
    if (alertView.alterType == FDAltertViewTypeEditInputPriceForGift) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsAddPriceForgift:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
        else
        {
            [self handleSpecialGoodsAddPriceForgift:0 WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
    }
    ///交订金
    if (alertView.alterType == FDAltertViewTypeInputDepositPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsReserveAmount:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    if (alertView.alterType == FDAltertViewTypeEditInputDepositPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsReserveAmount:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
        else
        {
            [self handleSpecialGoodsReserveAmount:0 WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    
    //交尾款
    if (alertView.alterType == FDAltertViewTypeInputRemainPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsRemainAmount:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    if (alertView.alterType == FDAltertViewTypeEditInputRemainPrice) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsRemainAmount:[inputStr doubleValue] WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
        else
        {
            [self handleSpecialGoodsRemainAmount:0 WithAtIndex:self.currentIndex];
            self.configModel.shopDerate = @"";
            [self httpPath_sale];
        }
    }
    
    
    if (alertView.alterType == FDAltertViewTypeInputCode) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsGoodsCode:inputStr WithAtIndex:self.currentIndex];
            [self httpPath_sale];
        }
        
    }
    if (alertView.alterType == FDAltertViewTypeInputCodeForGift) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsGoodsCodeForgift:inputStr WithAtIndex:self.currentIndex];
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
        
    }
    
    
    
    
    if (alertView.alterType == FDAltertViewTypeEditInputCode) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsGoodsCode:inputStr WithAtIndex:self.currentIndex];
            [self httpPath_sale];
        }
        else
        {
            [self handleSpecialGoodsGoodsCode:@"" WithAtIndex:self.currentIndex];
            [self httpPath_sale];
        }
    }
    if (alertView.alterType == FDAltertViewTypeEditInputCodeForGift) {
        if (buttonIndex == 1) {
            [self handleSpecialGoodsGoodsCodeForgift:inputStr WithAtIndex:self.currentIndex];
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
        else
        {
            [self handleSpecialGoodsGoodsCodeForgift:@"" WithAtIndex:self.currentIndex];
//            [self httpPath_sale];
            [self handleTableViewFloorsData];
            [self handelConfigTCellAndStatisticsTCellHeight];
            [self.tableview reloadData];
        }
    }
    
    
    
    
    if (alertView.alterType == FDAltertViewTypeTips) {
        if (buttonIndex == 1) {
            [self httpPath_saveOrder];
        }
        else
        {
            self.isCanOperation = YES;
            self.isDamping = NO;
        }
    }
}




- (void)skipToAddressListVC
{
    if (self.counterDataModel.addressId.length ||
        !self.isUseAddress) {
        AddressListVC *addressListVC = [[AddressListVC alloc] init];
        addressListVC.delegate = self;
        addressListVC.customerId = self.customerId;
        addressListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressListVC animated:YES];
    }
    else
    {
        AddressAddVC *addressAddVC = [[AddressAddVC alloc] init];
        addressAddVC.customerId = self.customerId;
        addressAddVC.delegate = self;
        addressAddVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressAddVC animated:YES];
        
    }
}


- (void)handleOrderConfigWithType:(SelectType)selectType
{
    if (selectType == SelectTypePickUp) {
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
                weakSelf.configModel.pickUpStatus = model.titleName;
                weakSelf.configModel.pickUpStatusID = model.ID;
                [weakSelf handelConfigTCellAndStatisticsTCellHeight];
                [weakSelf.tableview reloadData];
               
            }];
        }
    }
    else if (selectType == SelectTypeDelivery)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (CommonCategoryDataModel *model in self.deliveryDataArr) {
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
                weakSelf.configModel.shoppingMethod = model.titleName;
                weakSelf.configModel.shoppingMethodID = model.ID;
                [weakSelf handelConfigTCellAndStatisticsTCellHeight];
                [weakSelf.tableview reloadData];
                //                [weakSelf updateDataModelWithKWCPDataModel:model];
            }];
        }
    }
    else if (selectType == SelectTypeReceivables)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (CommonCategoryDataModel *model in self.receivablesDataArr) {
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
                weakSelf.configModel.paymentMethod = model.titleName;
                weakSelf.configModel.paymentMethodID = model.ID;
                [weakSelf handelConfigTCellAndStatisticsTCellHeight];
                [weakSelf.tableview reloadData];
                //                [weakSelf updateDataModelWithKWCPDataModel:model];
            }];
        }
    }
    else if (selectType == SelectTypeCoupon)
    {
        if (self.counterDataModel.useCouponList.count ||
            self.counterDataModel.notUseCouponList.count) {
            CommonCouponPopView *commonCouponPopView = [[CommonCouponPopView alloc] init];
            commonCouponPopView.delegate = self;
            commonCouponPopView.currentSelectId = self.assetId;
            commonCouponPopView.usableArr = [self.counterDataModel.useCouponList mutableCopy];
            commonCouponPopView.unavailableArr = [self.counterDataModel.notUseCouponList mutableCopy];
            [commonCouponPopView showShareViewWithDXShareModel];
        }
    }
    else if (selectType == SelectTypeStoreDiscount)
    {
        
        [self httpPath_sale];
    }
    else if (selectType == SelectTypeOtherDiscount)//其他优惠
    {
        
        [self httpPath_sale];
    }
}

#pragma mark -- CommonCouponPopViewDelegate
- (void)selectedCouponDelegate:(NSString *)assetID
{
    self.assetId = assetID;
    self.configModel.shopDerate = @"";
    self.configModel.otherDerate = @"";
    [self httpPath_sale];
}

- (void)handleSpecialGoodsAddPrice:(double)addPrice WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    
    CommonTVDataModel *cellModel = sectionArr[0];
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.kAddPrice = addPrice;
    
    
   

    cellModel.cellHeaderHeight = 0.01;
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0&&
        goodsModel.reserveAmount == 0 ) {
        cellModel.cellFooterHeight = 55;
        
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0&&
             goodsModel.reserveAmount != 0 )
    {
        cellModel.cellFooterHeight = 95;
        if(self.type == SalesCounterTypeReserve){
            if(goodsModel.remainAmount !=0){
                cellModel.cellFooterHeight = 125;
            } else {
                cellModel.cellFooterHeight =95 + 55;
            }
            
        }
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
        cellModel.cellFooterHeight += goodsModel.reserveAmount != 0?30:0;
        if(self.type == SalesCounterTypeReserve){
            cellModel.cellFooterHeight += goodsModel.remainAmount != 0?30:0;
        }
        
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)handleSpecialGoodsReserveAmount:(double)reserveAmount WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    
    CommonTVDataModel *cellModel = sectionArr[0];
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.reserveAmount = reserveAmount;
    
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0&&
        goodsModel.reserveAmount == 0 ) {
        cellModel.cellFooterHeight = 55;
        
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0&&
             goodsModel.reserveAmount != 0 )
    {
        cellModel.cellFooterHeight = 95;
        if(self.type == SalesCounterTypeReserve){
            if(goodsModel.remainAmount !=0){
                cellModel.cellFooterHeight = 125;
            } else {
                cellModel.cellFooterHeight =95 + 55;
            }
            
        }
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
        cellModel.cellFooterHeight += goodsModel.reserveAmount != 0?30:0;
        if(self.type == SalesCounterTypeReserve){
            cellModel.cellFooterHeight += goodsModel.remainAmount != 0?30:0;
        }
        
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)handleSpecialGoodsRemainAmount:(double)remainAmount WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    
    CommonTVDataModel *cellModel = sectionArr[0];
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.remainAmount = remainAmount;
    
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0&&
        goodsModel.reserveAmount == 0 ) {
        cellModel.cellFooterHeight = 55;
        
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0&&
             goodsModel.reserveAmount != 0 )
    {
        cellModel.cellFooterHeight = 95;
        if(self.type == SalesCounterTypeReserve){
            if(goodsModel.remainAmount !=0){
                cellModel.cellFooterHeight = 125;
            } else {
                cellModel.cellFooterHeight =95 + 55;
            }
            
        }
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
        cellModel.cellFooterHeight += goodsModel.reserveAmount != 0?30:0;
        if(self.type == SalesCounterTypeReserve){
            cellModel.cellFooterHeight += goodsModel.remainAmount != 0?30:0;
        }
        
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)handleSpecialGoodsAddPriceForgift:(double)addPrice WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonTVDataModel *cellModel = sectionArr[0];
//    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.kAddPrice = addPrice;
    
    
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0&&
        goodsModel.reserveAmount == 0 ) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
    }
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleSpecialGoodsGoodsCode:(NSString *)goodsCode WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonTVDataModel *cellModel = sectionArr[0];
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.kGoodsCode = goodsCode;
    
    
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0&&
        goodsModel.reserveAmount == 0 ) {
        cellModel.cellFooterHeight = 55;
        
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0&&
             goodsModel.reserveAmount != 0 )
    {
        cellModel.cellFooterHeight = 95;
        if(self.type == SalesCounterTypeReserve){
            if(goodsModel.remainAmount !=0){
                cellModel.cellFooterHeight = 125;
            } else {
                cellModel.cellFooterHeight =95 + 55;
            }
            
        }
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
        cellModel.cellFooterHeight += goodsModel.reserveAmount != 0?30:0;
        if(self.type == SalesCounterTypeReserve){
            cellModel.cellFooterHeight += goodsModel.remainAmount != 0?30:0;
        }
        
    }
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleSpecialGoodsGoodsCodeForgift:(NSString *)goodsCode WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonTVDataModel *cellModel = sectionArr[0];
    CommonGoodsModel *goodsModel = cellModel.Data;
    goodsModel.kGoodsCode = goodsCode;
    
//    CommonTVDataModel *cellModel = sectionArr[0];
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0 ) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 55;
        cellModel.cellFooterHeight += goodsModel.kAddPrice != 0?30:0;
        cellModel.cellFooterHeight += goodsModel.kGoodsCode.length > 0?30:0 ;
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
        if ([operation.urlTag isEqualToString:Path_sale]) {
            
        }
        if ([operation.urlTag isEqualToString:Path_saveOrder]) {
            self.isDamping = NO;
            self.isCanOperation = YES;
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_sale]) {
                SalesCounterDataModel *model = (SalesCounterDataModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    self.counterDataModel = model;
                    [self handleTableViewFloorsData];
                    [self handelConfigTCellAndStatisticsTCellHeight];
                    [self.tableview reloadData];
                }
                else
                {
                 
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            if ([operation.urlTag isEqualToString:Path_load]) {
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"PickUpStatus"]) {
                        [self.pickUpDataArr removeAllObjects];
                        [self.pickUpDataArr addObjectsFromArray:itemModel.datas];
                        for (CommonCategoryDataModel *model in self.pickUpDataArr) {
                            if ([model.des isEqualToString:@"全部已提"]) {
                                self.configModel.pickUpStatus = model.des;
                                self.configModel.pickUpStatusID = model.ID;
                                break;
                            }
                        }
                        if (self.configModel.pickUpStatus.length == 0) {
                            if (self.pickUpDataArr.count) {
                                CommonCategoryDataModel *model = self.pickUpDataArr[0];
                                self.configModel.pickUpStatus = model.des;
                                self.configModel.pickUpStatusID = model.ID;
                            }
                            
                        }
                    }
                    else if ([itemModel.className isEqualToString:@"PaymentMethod"])
                    {
                        [self.receivablesDataArr removeAllObjects];
                        [self.receivablesDataArr addObjectsFromArray:itemModel.datas];
                        
                        for (CommonCategoryDataModel *model in self.receivablesDataArr) {
                            if ([model.des isEqualToString:@"银行卡"]) {
                                self.configModel.paymentMethod = model.des;
                                self.configModel.paymentMethodID = model.ID;
                                break;
                            }
                        }
                        if (self.configModel.paymentMethod.length == 0) {
                            if (self.receivablesDataArr.count) {
                                CommonCategoryDataModel *model = self.receivablesDataArr[0];
                                self.configModel.paymentMethod = model.des;
                                self.configModel.paymentMethodID = model.ID;
                            }
                            
                        }
                        
//                        if (self.receivablesDataArr.count) {
//                            CommonCategoryDataModel *model = self.receivablesDataArr[0];
//                            self.configModel.paymentMethod = model.des;
//                            self.configModel.paymentMethodID = model.ID;
//                        }
                    }
                    else if ([itemModel.className isEqualToString:@"ShoppingMethod"])
                    {
                        [self.deliveryDataArr removeAllObjects];
                        [self.deliveryDataArr addObjectsFromArray:itemModel.datas];
                        
                        for (CommonCategoryDataModel *model in self.deliveryDataArr) {
                            if ([model.des isEqualToString:@"顾客自提"]) {
                                self.configModel.shoppingMethod = model.des;
                                self.configModel.shoppingMethodID = model.ID;
                                break;
                            }
                        }
                        if (self.configModel.shoppingMethod.length == 0) {
                            if (self.deliveryDataArr.count) {
                                CommonCategoryDataModel *model = self.deliveryDataArr[0];
                                self.configModel.shoppingMethod = model.des;
                                self.configModel.shoppingMethodID = model.ID;
                            }
                            
                        }
                        
//                        if (self.deliveryDataArr.count) {
//                            CommonCategoryDataModel *model = self.deliveryDataArr[0];
//                            self.configModel.shoppingMethod = model.des;
//                            self.configModel.shoppingMethodID = model.ID;
//                        }
                    }
                }
                [self handelConfigTCellAndStatisticsTCellHeight];
                [self.tableview reloadData];
                
            }
            if ([operation.urlTag isEqualToString:Path_saveOrder]) {
                OrderInfoModel *model = (OrderInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"order_success", nil)];
                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
                    orderOperationSuccessVC.orderID = model.ID;
                    orderOperationSuccessVC.customerId = self.customerId;
                    orderOperationSuccessVC.controllerType = OrderOperationSuccessVCTypePlacing;
                    orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                self.isDamping = NO;
                self.isCanOperation = YES;
            }
        }
    }
}


#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.floorsAarr removeAllObjects];
    self.goodsCount = 0;
    self.giftGoodsCount = 0;
    //地址
    NSMutableArray *section1Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *addressCellModel = [[CommonTVDataModel alloc] init];
    addressCellModel.cellIdentify = KCounterAddressTCell;
    addressCellModel.cellHeight = KCounterAddressTCellH;
    addressCellModel.cellHeaderHeight = 0.01;
    addressCellModel.cellFooterHeight = 5;
    [section1Arr addObject:addressCellModel];
    [self.floorsAarr addObject:section1Arr];
    
    if ([QZLUserConfig sharedInstance].useInventory){
    
        //库存参考信息
        NSMutableArray *section2Arr = [[NSMutableArray alloc] init];
        XwSystemTCellModel* model = [XwSystemTCellModel new];
        model.title = @"库存参考信息";
        model.showArrow = YES;

        
        CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
        delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
        delivereModel.cellHeight = 40;
        delivereModel.cellHeaderHeight = 0.01;
        delivereModel.cellFooterHeight =  5;
        delivereModel.Data = model;
        [section2Arr addObject:delivereModel];
        [self.floorsAarr addObject:section2Arr];
    }
    //商品
    
    for (CommonGoodsModel *model in self.dataArr) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        model.isShowDetail = NO;
        
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.Data = model;
        
        if (!model.isSetMeal) {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            
            if (model.isSpecial) {
                cellModel.cellHeaderHeight = 0.01;
                if (model.kAddPrice == 0 &&
                    model.kGoodsCode.length == 0&&
                    model.reserveAmount == 0 ) {
                    cellModel.cellFooterHeight = 55;
                    
                }
                else if (model.kAddPrice != 0 &&
                         model.kGoodsCode.length > 0&&
                         model.reserveAmount != 0 )
                {
                    cellModel.cellFooterHeight = 95;
                    if(self.type == SalesCounterTypeReserve){
                        if(model.remainAmount !=0){
                            cellModel.cellFooterHeight = 125;
                        } else {
                            cellModel.cellFooterHeight =95 + 55;
                        }
                        
                    }
                }
                else
                {
                    cellModel.cellFooterHeight = 55;
                    cellModel.cellFooterHeight += model.kAddPrice != 0?30:0;
                    cellModel.cellFooterHeight += model.kGoodsCode.length > 0?30:0 ;
                    cellModel.cellFooterHeight += model.reserveAmount != 0?30:0;
                    if(self.type == SalesCounterTypeReserve){
                        cellModel.cellFooterHeight += model.remainAmount != 0?30:0;
                    }
                    
                }
                
                
                
            }
            else
            {
                cellModel.cellHeaderHeight = 0.01;
                cellModel.cellFooterHeight = 5;
            }
            self.goodsCount += model.kGoodsCount;
        }
        else
        {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 5;
            cellModel.Data = model;
            self.goodsCount += model.kGoodsCount;
        }
        
        [sectionArr addObject:cellModel];
        
        [self.floorsAarr addObject:sectionArr];
    }
    
    //订单活动
    if (self.counterDataModel.rules.length > 0) {
        NSMutableArray *section3Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *orderActivitiesCellModel = [[CommonTVDataModel alloc] init];
        orderActivitiesCellModel.cellIdentify = KOrderPromotionTCell;
        orderActivitiesCellModel.cellHeight = KOrderPromotionTCellH;
        orderActivitiesCellModel.cellHeaderHeight = 35;
        orderActivitiesCellModel.cellFooterHeight = 5;
        orderActivitiesCellModel.Data = self.counterDataModel.rules;
        [section3Arr addObject:orderActivitiesCellModel];
        [self.floorsAarr addObject:section3Arr];
    }
    
    if (self.giftDataArr.count > 0) {
        
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
    
    
    //赠品
    
    for (CommonGoodsModel *model in self.giftDataArr) {
        model.isShowDetail = NO;
        //当前商品的Cell
        NSMutableArray *giftArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
       
        if (!model.isSetMeal) {
            cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            cellModel.Data = model;
            if (model.isSpecial) {
                cellModel.cellHeaderHeight = 0.01;
                if (model.kAddPrice == 0 &&
                    model.kGoodsCode.length == 0) {
                    cellModel.cellFooterHeight = 55;
                }
                else if (model.kAddPrice != 0 &&
                         model.kGoodsCode.length > 0)
                {
                    cellModel.cellFooterHeight = 60;
                }
                else
                {
                    cellModel.cellFooterHeight = 55;
                    cellModel.cellFooterHeight += model.kAddPrice != 0?30:0;
                    cellModel.cellFooterHeight += model.kGoodsCode.length > 0?30:0 ;
                }
            }
            else
            {
                cellModel.cellHeaderHeight = 0.01;
                cellModel.cellFooterHeight = 5;
            }
            self.giftGoodsCount += model.kGoodsCount;
        }
        else
        {
            cellModel.cellIdentify = KCommonSingleGoodsTCellForGift;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
            cellModel.cellHeaderHeight = 0.01;
            cellModel.cellFooterHeight = 5;
            cellModel.Data = model;
            self.giftGoodsCount += model.kGoodsCount;
        }
        [giftArr addObject:cellModel];
        [self.floorsAarr addObject:giftArr];
    }
//    if(self.giftDataArr.count > 0){
//        
//    }
    if(self.type == SalesCounterTypeNone){
        //添加赠品
        NSMutableArray *section7Arr = [[NSMutableArray alloc] init];
        CommonTVDataModel *giftCellModel = [[CommonTVDataModel alloc] init];
        giftCellModel.cellIdentify = KGiftAddTCell;
        giftCellModel.cellHeight = KGiftAddTCellH;
        giftCellModel.cellHeaderHeight = 0.01;
        giftCellModel.cellFooterHeight = 5;
        [section7Arr addObject:giftCellModel];
        [self.floorsAarr addObject:section7Arr];
    }
    
    
    
    
//    if ([QZLUserConfig sharedInstance].useInventory)
    {
    
        //库存参考信息
        NSMutableArray *section8Arr = [[NSMutableArray alloc] init];
        XwSystemTCellModel* model = [XwSystemTCellModel new];
        model.title = @"活动重点关注项";
        NSString* fillTag = @"未填写";
        if(self.attentionArry.count > 0){
            fillTag = @"已填写";
        }
        model.value = !self.counterDataModel.isActivity?@"无活动":fillTag;
        model.showArrow = YES;

        CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
        delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
        delivereModel.cellHeight = 40;
        delivereModel.cellHeaderHeight = 0.01;
        delivereModel.cellFooterHeight =  5;
        delivereModel.Data = model;
        [section8Arr addObject:delivereModel];
        [self.floorsAarr addObject:section8Arr];
    }
    
    //配置
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *configCellModel = [[CommonTVDataModel alloc] init];
    configCellModel.cellIdentify = KSellGoodsOrderConfigTCell;
    configCellModel.cellHeight = KSellGoodsOrderConfigTCellH;
    configCellModel.cellHeaderHeight = 0.01;
    configCellModel.cellFooterHeight = 5;
    [section4Arr addObject:configCellModel];
    [self.floorsAarr addObject:section4Arr];
    
    //统计
    NSMutableArray *section5Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *statisticsCellModel = [[CommonTVDataModel alloc] init];
    statisticsCellModel.cellIdentify = KSellGoodsOrderStatisticsTCell;
    statisticsCellModel.cellHeight = KSellGoodsOrderStatisticsTCellH;
    statisticsCellModel.cellHeaderHeight = 0.01;
    statisticsCellModel.cellFooterHeight = 5;
    [section5Arr addObject:statisticsCellModel];
    [self.floorsAarr addObject:section5Arr];
    self.configModel.payAmount = self.counterDataModel.payAmount;
    self.configModel.otherDerate = self.counterDataModel.otherDerate;
    self.configModel.shopDerate = self.counterDataModel.shopDerate;
    
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
- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
//    CommonGoodsModel *goodsModel = self.dataArr[indexPath.row];
    CommonTVDataModel* tm =  sectionArr[indexPath.row];
    CommonGoodsModel *goodsModel = tm.Data;
    
    
    
    if (isShow) {
        NSInteger index  = indexPath.row;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.Data = model;
            index ++;
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
//    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
//    CommonGoodsModel *goodsModel = self.giftDataArr[indexPath.row];
    CommonTVDataModel* tm =  sectionArr[indexPath.row];
    CommonGoodsModel *goodsModel = tm.Data;
    if (isShow) {
        NSInteger index  = indexPath.row;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.Data = model;
            index ++;
            [sectionArr addObject:cellModel];
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;

        [sectionArr removeObjectsInRange:NSMakeRange(indexPath.row + 1, goodsModel.productList.count)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

/**处理TCell高度*/
- (void)handelConfigTCellAndStatisticsTCellHeight
{
    if (self.floorsAarr.count) {
        //订单配置
        NSMutableArray *configCellArr = self.floorsAarr[self.floorsAarr.count - 3];
        CommonTVDataModel *configCellModel = configCellArr[0];
        if ([self.configModel.pickUpStatus isEqualToString:@"全部已提"]) {
            configCellModel.cellHeight = KSellGoodsOrderConfigTCellH - 41;
        }
        else
        {
            configCellModel.cellHeight = KSellGoodsOrderConfigTCellH;
        }
        
        //订单统计
        NSMutableArray *statisticsCellArr = self.floorsAarr[self.floorsAarr.count - 2];
        CommonTVDataModel *statisticsCellModel = statisticsCellArr[0];
        statisticsCellModel.cellHeight = KSellGoodsOrderStatisticsTCellH;
    
        if ([self.counterDataModel.couponDerate isEqualToString:@"0"] ||self.counterDataModel.couponDerate == nil) {
            statisticsCellModel.cellHeight -= 30;
        }
        if ([self.counterDataModel.orderDerate isEqualToString:@"0"] ||self.counterDataModel.orderDerate == nil) {
            statisticsCellModel.cellHeight -= 30;
        }
        if ([self.counterDataModel.shopDerate isEqualToString:@"0"] ||self.counterDataModel.shopDerate == nil) {
            statisticsCellModel.cellHeight -= 30;
        }
        if ([self.counterDataModel.otherDerate isEqualToString:@"0"] ||self.counterDataModel.otherDerate == nil) {
            statisticsCellModel.cellHeight -= 30;
        }
        
    }
}

/**卖货柜台Api*/
- (void)httpPath_sale
{
    //单品
    NSMutableArray *orderProductArr = [[NSMutableArray alloc] init];
    //套餐
    NSMutableArray *orderSetMealArr = [[NSMutableArray alloc] init];
    for (CommonGoodsModel *model in self.dataArr) {
        if (model.isSetMeal) {
            NSMutableDictionary *orderSetMealDic = [[NSMutableDictionary alloc] init];
            [orderSetMealDic setObject:model.id forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            
            [orderSetMealArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];

            [orderProductDic setObject:model.id forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
                }
                if (model.reserveAmount > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.reserveAmount] forKey:@"reserveAmount"];
                }
                if (model.remainAmount > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.remainAmount] forKey:@"remainAmount"];
                }
            }
            [orderProductArr addObject:orderProductDic];
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.assetId forKey:@"assetId"];
    if ([self.configModel.shopDerate isEqualToString:@"0"]) {
        self.configModel.shopDerate = @"";
    }
    [parameters setValue:self.configModel.shopDerate forKey:@"shopDerate"];
    //其他优惠
    if ([self.configModel.otherDerate isEqualToString:@"0"]) {
        self.configModel.otherDerate = @"";
    }
    [parameters setValue:self.configModel.otherDerate forKey:@"otherDerate"];
    
    [parameters setValue:self.customerId forKey:@"customerId"];
    if ([self.counterDataModel.addressId isEqualToString:@"0"]) {
        [parameters setValue:[NSNumber numberWithBool:false] forKey:@"isUse"];
    }
    else
    {
        [parameters setValue:[NSNumber numberWithBool:true] forKey:@"isUse"];
        [parameters setValue:self.counterDataModel.addressId forKey:@"addressId"];
    }
    
    [parameters setValue:orderProductArr forKey:@"orderProductDatas"];
    [parameters setValue:orderSetMealArr forKey:@"orderSetMealDatas"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_sale;
}

/**确认订单Api*/
- (void)httpPath_saveOrder
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.assetId forKey:@"assetId"];
    [parameters setValue:self.configModel.shopDerate forKey:@"shopDerate"];
    [parameters setValue:self.configModel.otherDerate forKey:@"otherDerate"];
    [parameters setValue:[NSNumber numberWithBool:self.configModel.isFreeGift] forKey:@"isFreeGift"];
    [parameters setValue:[NSNumber numberWithBool:self.configModel.isMoen] forKey:@"isMoen"];
    [parameters setValue:self.counterDataModel.payAmount forKey:@"payAmount"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    if (self.configModel.info.length > 0) {
        [parameters setValue:self.configModel.info forKey:@"info"];
    }
    
    [parameters setValue:self.counterDataModel.addressId forKey:@"addressId"];
    [parameters setValue:self.configModel.pickUpStatusID forKey:@"pickUpStatus"];
    [parameters setValue:self.configModel.paymentMethodID forKey:@"paymentMethod"];
    [parameters setValue:self.configModel.shoppingMethodID forKey:@"shoppingMethod"];
    
    //单品
    NSMutableArray *orderProductArr = [[NSMutableArray alloc] init];
    //套餐
    NSMutableArray *orderSetMealArr = [[NSMutableArray alloc] init];
    for (CommonGoodsModel *model in self.dataArr) {
        if (model.isSetMeal) {
            NSMutableDictionary *orderSetMealDic = [[NSMutableDictionary alloc] init];
            [orderSetMealDic setObject:model.id forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            
            [orderSetMealArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];
            [orderProductDic setObject:model.id forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
                }
                if (model.reserveAmount) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.reserveAmount] forKey:@"reserveAmount"];
                }
                if (model.remainAmount) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.remainAmount] forKey:@"remainAmount"];
                }
                if(self.type == SalesCounterTypeReserve){
                    [orderProductDic setObject:model.id forKey:@"id"];
                    [orderProductDic setObject:model.productId forKey:@"productId"];
                }
            }
            
            [orderProductArr addObject:orderProductDic];
        }
    }
    
    [parameters setValue:orderProductArr forKey:@"orderProductDatas"];
    [parameters setValue:orderSetMealArr forKey:@"orderSetMealDatas"];
    
    
    //赠品处理
    //单品
    NSMutableArray *orderProductGiftArr = [[NSMutableArray alloc] init];
    //套餐
    NSMutableArray *orderSetMealGiftArr = [[NSMutableArray alloc] init];
    for (CommonGoodsModel *model in self.giftDataArr) {
        if (model.isSetMeal) {
            NSMutableDictionary *orderSetMealDic = [[NSMutableDictionary alloc] init];
            [orderSetMealDic setObject:model.id forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            [orderSetMealGiftArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];
            [orderProductDic setObject:model.id  forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
                }
                if (model.reserveAmount) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.reserveAmount] forKey:@"reserveAmount"];
                }
            }
            [orderProductDic setObject:model.id  forKey:@"id"];
            [orderProductGiftArr addObject:orderProductDic];
        }
    }
    
    [parameters setValue:orderProductGiftArr forKey:@"orderGiftProductDatas"];
    [parameters setValue:orderSetMealGiftArr forKey:@"orderGiftSetMealDatas"];
    
    if(self.attentionArry.count > 0){
        NSMutableArray* array = [NSMutableArray array];
        for (XwActivityModel *model in self.attentionArry) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:model.num forKey:@"num"];
            [dict setObject:model.activityIndexName forKey:@"activityIndexName"];
            [dict setObject:model.activityIndexId forKey:@"activityIndexId"];
            
            [array addObject:dict];
        }
        [parameters setValue:array forKey:@"activityIndexIdList"];
    }
    [parameters setValue: @(self.isReserve) forKey:@"isReserve"];
    [parameters setValue: self.code forKey:@"code"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_saveOrder;
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
- (UITableView *)tableview
{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CounterAddressTCell" bundle:nil] forCellReuseIdentifier:@"CounterAddressTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderConfigTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderConfigTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderStatisticsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"GiftAddTCell" bundle:nil] forCellReuseIdentifier:@"GiftAddTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];
        
        [_tableview registerClass:[XWOrderDetailDefaultCell class] forCellReuseIdentifier:@"XWOrderDetailDefaultCell"];
    }
    return _tableview;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {

        _confirmBtn = [UIButton buttonWithTitie:NSLocalizedString(@"confirm_order", nil) WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            [self ConfirmBtnAction];
        }];
        
    }
    return _confirmBtn;
}
//- (UIButton *)reserveBtn
//{
//    if (!_reserveBtn) {
//
//        _reserveBtn = [UIButton buttonWithTitie:@"提交预定订单" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
//            [self ConfirmBtnAction];
//        }];
//
//    }
//    return _reserveBtn;
//}
//- (UIButton *)formalBtn
//{
//    if (!_formalBtn) {
//
//        _formalBtn = [UIButton buttonWithTitie:@"提交正式订单" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
//            [self ConfirmBtnAction];
//        }];
//
//    }
//    return _formalBtn;
//}
//- (NSMutableArray *)dataList
//{
//    if (!_dataList) {
//        _dataList = [[NSMutableArray alloc] init];
//    }
//    return _dataList;
//}

- (SalesCounterDataModel *)counterDataModel
{
    if (!_counterDataModel) {
        _counterDataModel = [[SalesCounterDataModel alloc] init];
    }
    return _counterDataModel;
}

- (SalesCounterConfigModel *)configModel
{
    if (!_configModel) {
        _configModel = [[SalesCounterConfigModel alloc] init];
    }
    return _configModel;
}

- (KWCommonPickView *)kwPickView
{
    if (!_kwPickView) {
        _kwPickView = [[KWCommonPickView alloc] initWithType:1];
    }
    return _kwPickView;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

- (NSMutableArray *)pickUpDataArr
{
    if (!_pickUpDataArr) {
        _pickUpDataArr = [[NSMutableArray alloc] init];
    }
    return _pickUpDataArr;
}


- (NSMutableArray *)deliveryDataArr
{
    if (!_deliveryDataArr) {
        _deliveryDataArr = [[NSMutableArray alloc] init];
    }
    return _deliveryDataArr;
}

- (NSMutableArray *)giftDataArr
{
    if (!_giftDataArr) {
        _giftDataArr = [[NSMutableArray alloc] init];
    }
    return _giftDataArr;
}




- (NSMutableArray *)receivablesDataArr
{
    if (!_receivablesDataArr) {
        _receivablesDataArr = [[NSMutableArray alloc] init];
    }
    return _receivablesDataArr;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
