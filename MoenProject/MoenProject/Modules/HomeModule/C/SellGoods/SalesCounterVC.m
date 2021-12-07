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

@interface SalesCounterVC ()<UITableViewDelegate, UITableViewDataSource, AddressListVCDelegate, CommonCouponPopViewDelegate, FDAlertViewDelegate, AddressAddVCDelegate, SearchGoodsVCDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSDampButton *confirmBtn;

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

@property (nonatomic, strong) SalesCounterDataModel *counterDataModel;

@property (nonatomic, strong) SalesCounterConfigModel *configModel;


/**当前操作的位置*/
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger giftGoodsCount;

@property (nonatomic, assign) BOOL isCanOperation;

@property (nonatomic, assign) BOOL isUseAddress;



@property (nonatomic, strong) NSMutableArray *giftDataArr;

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
}

- (void)configBaseData
{
    self.isCanOperation = YES;
    self.isUseAddress = YES;
    [self httpPath_sale];
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
        [cell showDataWithCommonGoodsModelForSalesCounter:self.dataArr[indexPath.section - 1] AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        cell.goodsNumberChangeBlock = ^{
            [weakSelf httpPath_sale];
        };
        return cell;
    }
    
    //赠品展示
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift])
    {
        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForGift:self.giftDataArr[indexPath.section - beginIndex - self.dataArr.count] AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGiftGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        cell.goodsNumberChangeBlock = ^{
            [weakSelf httpPath_sale];
        };
        return cell;
    }
    
    
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonGoodsModel *goodsModel = self.dataArr[indexPath.section - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[indexPath.row - 1]];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGiftGoodsDarkTCell])
    {
        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
        CommonGoodsModel *goodsModel = self.giftDataArr[indexPath.section - beginIndex - self.dataArr.count];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForSearch:goodsModel.productList[indexPath.row - 1]];
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
        CommonGoodsModel *model =  self.dataArr[section - 1];
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
                [addPriceLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAddPriceAction:)]];
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
                [goodsCodeLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAddCodeAction:)]];
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
                UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeft, marginTop + 10, 80, 30)];
                [codeBtn setTitle:@"PO单号" forState:UIControlStateNormal];
                codeBtn.titleLabel.font = FONTLanTingR(13);
                [codeBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                codeBtn.clipsToBounds = YES;
                codeBtn.layer.borderWidth = 1;
                codeBtn.layer.borderColor = AppTitleBlueColor.CGColor;
                codeBtn.layer.cornerRadius = 15;
                codeBtn.tag = 7000 + section;
                [codeBtn addTarget:self action:@selector(AddCodeAction:) forControlEvents:UIControlEventTouchDown];
                [footerView addSubview:codeBtn];
                marginLeft -= 90;
            }
            if (model.kAddPrice == 0) {
                UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeft, marginTop + 10, 80, 30)];
                [priceBtn setTitle:@"增项加价" forState:UIControlStateNormal];
                priceBtn.titleLabel.font = FONTLanTingR(13);
                [priceBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                priceBtn.clipsToBounds = YES;
                priceBtn.layer.borderWidth = 1;
                priceBtn.layer.borderColor = AppTitleBlueColor.CGColor;
                priceBtn.layer.cornerRadius = 15;
                priceBtn.tag = 8000 + section;
                [priceBtn addTarget:self action:@selector(AddPriceAction:) forControlEvents:UIControlEventTouchDown];
                [footerView addSubview:priceBtn];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellModel.cellFooterHeight - 5, SCREEN_WIDTH, 5)];
            lineView.backgroundColor = AppBgBlueGrayColor;
            [footerView addSubview:lineView];
        }
    }
    
    if ([cellModel.cellIdentify isEqualToString:KCommonSingleGoodsTCellForGift]) {
        NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
        CommonGoodsModel *model =  self.giftDataArr[section - beginIndex - self.dataArr.count];
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
                [addPriceLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAddPriceActionForGift:)]];
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
                [goodsCodeLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAddCodeActionForGift:)]];
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
                UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeft, marginTop + 10, 80, 30)];
                [codeBtn setTitle:@"PO单号" forState:UIControlStateNormal];
                codeBtn.titleLabel.font = FONTLanTingR(13);
                [codeBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                codeBtn.clipsToBounds = YES;
                codeBtn.layer.borderWidth = 1;
                codeBtn.layer.borderColor = AppTitleBlueColor.CGColor;
                codeBtn.layer.cornerRadius = 15;
                codeBtn.tag = 7000 + section;
                [codeBtn addTarget:self action:@selector(AddCodeActionForgift:) forControlEvents:UIControlEventTouchDown];
                [footerView addSubview:codeBtn];
                marginLeft -= 90;
            }
            if (model.kAddPrice == 0) {
                UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeft, marginTop + 10, 80, 30)];
                [priceBtn setTitle:@"增项加价" forState:UIControlStateNormal];
                priceBtn.titleLabel.font = FONTLanTingR(13);
                [priceBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                priceBtn.clipsToBounds = YES;
                priceBtn.layer.borderWidth = 1;
                priceBtn.layer.borderColor = AppTitleBlueColor.CGColor;
                priceBtn.layer.cornerRadius = 15;
                priceBtn.tag = 8000 + section;
                [priceBtn addTarget:self action:@selector(AddPriceActionForGift:) forControlEvents:UIControlEventTouchDown];
                [footerView addSubview:priceBtn];
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
    if (indexPath.section == 0) {
        [self skipToAddressListVC];
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



- (void)ConfirmBtnAction:(UIButton *)sender
{
    
    if (self.isDamping) {
        return;
    }
    self.isDamping = YES;
    //判断淋浴房单品是有填写PO单号
    for (CommonGoodsModel *model in self.dataArr) {
        if (!model.isSetMeal && model.isSpecial)
        {
            if (model.kGoodsCode.length == 0) {
                [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_pocode", nil)];
                self.isDamping = NO;
                return;
            }
        }
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
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认提交订单吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}



- (void)AddPriceAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 8000;
    self.currentIndex = atIndex;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeInputPrice message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)AddPriceActionForGift:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 8000;
    self.currentIndex = atIndex;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeInputPriceForGift message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)AddCodeAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 7000;
    self.currentIndex = atIndex;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeInputCode message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)AddCodeActionForgift:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 7000;
    self.currentIndex = atIndex;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeInputCodeForGift message:@"" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)modifyAddPriceAction:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = ges.view.tag - 5000;
    self.currentIndex = atIndex;
    CommonGoodsModel *goodsModel = self.dataArr[self.currentIndex - 1];
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeEditInputPrice message:[NSString stringWithFormat:@"%.2f",goodsModel.kAddPrice] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)modifyAddPriceActionForGift:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = ges.view.tag - 5000;
    self.currentIndex = atIndex;
    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = self.giftDataArr[self.currentIndex - beginIndex - self.dataArr.count];
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_additional_price", nil) alterType:FDAltertViewTypeEditInputPriceForGift message:[NSString stringWithFormat:@"%.2f",goodsModel.kAddPrice] delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)modifyAddCodeAction:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = ges.view.tag - 6000;
    self.currentIndex = atIndex;
    CommonGoodsModel *goodsModel = self.dataArr[self.currentIndex - 1];
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeEditInputCode message:goodsModel.kGoodsCode delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)modifyAddCodeActionForGift:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = ges.view.tag - 6000;
    self.currentIndex = atIndex;
    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = self.giftDataArr[self.currentIndex - beginIndex - self.dataArr.count];
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"input_PU_code", nil) alterType:FDAltertViewTypeEditInputCodeForGift message:goodsModel.kGoodsCode delegate:self buttonTitles:NSLocalizedString(@"c_clear", nil), NSLocalizedString(@"c_confirm", nil), nil];
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
    
}

#pragma mark -- CommonCouponPopViewDelegate
- (void)selectedCouponDelegate:(NSString *)assetID
{
    self.assetId = assetID;
    self.configModel.shopDerate = @"";
    [self httpPath_sale];
}

- (void)handleSpecialGoodsAddPrice:(double)addPrice WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonGoodsModel *goodsModel = self.dataArr[atIndex - 1];
    goodsModel.kAddPrice = addPrice;
    
    CommonTVDataModel *cellModel = sectionArr[0];
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 85;
    }

    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleSpecialGoodsAddPriceForgift:(double)addPrice WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = self.giftDataArr[atIndex - beginIndex - self.dataArr.count];
    goodsModel.kAddPrice = addPrice;
    
    CommonTVDataModel *cellModel = sectionArr[0];
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 85;
    }

    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleSpecialGoodsGoodsCode:(NSString *)goodsCode WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonGoodsModel *goodsModel = self.dataArr[atIndex - 1];
    goodsModel.kGoodsCode = goodsCode;
    
    CommonTVDataModel *cellModel = sectionArr[0];
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 85;
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleSpecialGoodsGoodsCodeForgift:(NSString *)goodsCode WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = self.giftDataArr[atIndex - beginIndex - self.dataArr.count];
    goodsModel.kGoodsCode = goodsCode;
    
    CommonTVDataModel *cellModel = sectionArr[0];
    if (goodsModel.kAddPrice == 0 &&
        goodsModel.kGoodsCode.length == 0) {
        cellModel.cellFooterHeight = 55;
    }
    else if (goodsModel.kAddPrice != 0 &&
             goodsModel.kGoodsCode.length > 0)
    {
        cellModel.cellFooterHeight = 65;
    }
    else
    {
        cellModel.cellFooterHeight = 85;
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
    
    //商品
    for (CommonGoodsModel *model in self.dataArr) {
        model.isShowDetail = NO;
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        if (!model.isSetMeal) {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            if (model.isSpecial) {
                cellModel.cellHeaderHeight = 0.01;
                if (model.kAddPrice == 0 &&
                    model.kGoodsCode.length == 0) {
                    cellModel.cellFooterHeight = 55;
                }
                else if (model.kAddPrice != 0 &&
                         model.kGoodsCode.length > 0)
                {
                    cellModel.cellFooterHeight = 65;
                }
                else
                {
                    cellModel.cellFooterHeight = 85;
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
            if (model.isSpecial) {
                cellModel.cellHeaderHeight = 0.01;
                if (model.kAddPrice == 0 &&
                    model.kGoodsCode.length == 0) {
                    cellModel.cellFooterHeight = 55;
                }
                else if (model.kAddPrice != 0 &&
                         model.kGoodsCode.length > 0)
                {
                    cellModel.cellFooterHeight = 65;
                }
                else
                {
                    cellModel.cellFooterHeight = 85;
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
            self.giftGoodsCount += model.kGoodsCount;
        }
        [giftArr addObject:cellModel];
        [self.floorsAarr addObject:giftArr];
    }
    
    
    //添加赠品
    NSMutableArray *section7Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *giftCellModel = [[CommonTVDataModel alloc] init];
    giftCellModel.cellIdentify = KGiftAddTCell;
    giftCellModel.cellHeight = KGiftAddTCellH;
    giftCellModel.cellHeaderHeight = 0.01;
    giftCellModel.cellFooterHeight = 5;
    [section7Arr addObject:giftCellModel];
    [self.floorsAarr addObject:section7Arr];
    
    
    
    
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


- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonGoodsModel *goodsModel = self.dataArr[atIndex - 1];
    if (isShow) {
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
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


- (void)handleGiftGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    NSInteger beginIndex = self.counterDataModel.rules.length > 0 ? 3:2;
    CommonGoodsModel *goodsModel = self.giftDataArr[atIndex - beginIndex - self.dataArr.count];
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
        if ([self.counterDataModel.couponDerate isEqualToString:@"0"]) {
            statisticsCellModel.cellHeight -= 30;
        }
        if ([self.counterDataModel.orderDerate isEqualToString:@"0"]) {
            statisticsCellModel.cellHeight -= 30;
        }
        if ([self.counterDataModel.shopDerate isEqualToString:@"0"]) {
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
            [orderSetMealDic setObject:model.ID forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            
            [orderSetMealArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];
            [orderProductDic setObject:model.ID forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
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
            [orderSetMealDic setObject:model.ID forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            
            [orderSetMealArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];
            [orderProductDic setObject:model.ID forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
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
            [orderSetMealDic setObject:model.ID forKey:@"setMealId"];
            [orderSetMealDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            [orderSetMealGiftArr addObject:orderSetMealDic];
        }
        else
        {
            NSMutableDictionary *orderProductDic = [[NSMutableDictionary alloc] init];
            [orderProductDic setObject:model.ID forKey:@"productId"];
            [orderProductDic setObject:[NSString stringWithFormat:@"%ld",(long)model.kGoodsCount] forKey:@"num"];
            if (model.isSpecial) {
                [orderProductDic setObject:[NSString stringWithFormat:@"%.3f",model.kGoodsArea] forKey:@"square"];
                if (model.kAddPrice > 0) {
                    [orderProductDic setObject:[NSString stringWithFormat:@"%.2f",model.kAddPrice] forKey:@"addPrice"];
                }
                if (model.kGoodsCode.length) {
                    [orderProductDic setObject:model.kGoodsCode forKey:@"codePU"];
                }
            }
            
            [orderProductGiftArr addObject:orderProductDic];
        }
    }
    
    [parameters setValue:orderProductGiftArr forKey:@"orderGiftProductDatas"];
    [parameters setValue:orderSetMealGiftArr forKey:@"orderGiftSetMealDatas"];
    
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
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height - btnHeight) style:UITableViewStyleGrouped];
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
        [_confirmBtn setTitle:NSLocalizedString(@"confirm_order", nil) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONTLanTingB(17);
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(ConfirmBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}

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


@end
