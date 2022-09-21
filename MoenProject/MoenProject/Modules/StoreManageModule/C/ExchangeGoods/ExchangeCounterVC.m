//
//  ExchangeCounterVC.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/27.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "ExchangeCounterVC.h"
#import "CommonSingleGoodsTCell.h"
#import "SellGoodsOrderStatisticsTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "OrderOperationSuccessVC.h"
#import "ExchangProductInfoModel.h"
#import "GiftTitleTCell.h"
@interface ExchangeCounterVC ()<UITableViewDelegate, UITableViewDataSource,FDAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableview;

@property (nonatomic, strong) NSDampButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSString *exchangeReason;
 
@end

@implementation ExchangeCounterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void)configBaseUI
{
    self.title = @"换货柜台";
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    
    [self.view addSubview:self.tableview];
    self.tableview.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, isIphoneX?55:40, 0)) ;
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(isIphoneX?55:40);
        
    
   
}

- (void)configBaseData
{

    self.exchangeReason = @"";
    
    [self.floorsAarr removeAllObjects];

    [self handleTableViewFloorsData];
    
    [self handleTabMarkData];
    
    [self handleTabStatisticsData];
    
    [self.tableview reloadData];
}

- (void)reconnectNetworkRefresh
{
//    WEAKSELF
//    [weakSelf httpPath_orderDetail];
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
//    NSMutableArray *dataArr =
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
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
//    WEAKSELF
//    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];

        cell.exchangeCounterModel = model.Data;
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderStatisticsTCell])
    {
        SellGoodsOrderStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderStatisticsTCell" forIndexPath:indexPath];
        
        [cell showDataWithOrderDetailModel:model.Data];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        [cell showExchangeReason];
        cell.orderMarkBlock = ^(NSString *text) {
            self.exchangeReason = text;
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KGiftTitleTCell])
    {
        GiftTitleTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftTitleTCell" forIndexPath:indexPath];
        cell.currentTitle = model.Data;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)ConfirmBtnAction:(UIButton *)sender
{
    [self isConfirmReturnGoods];
}

#pragma mark- event response
- (void)isConfirmReturnGoods
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确定提交换货信息吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [self httpPath_ConfirmExchange];
    }
}

/**确认退货 Api*/
- (void)httpPath_ConfirmExchange
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableArray* goods = [NSMutableArray array];
    for (ProductlistModel* model in self.goodlist) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:model.nGoodsID forKey:@"goodsId"];
        [dic setValue:model.goodsID forKey:@"oldGoodsId"];
        [dic setValue:model.targetId forKey:@"targetId"];
        [dic setValue:model.type.id forKey:@"type"];
        [goods addObject:dic];
    }
    
    
    [parameters setValue: goods forKey:@"goodsList"];
    [parameters setValue: self.exchangeReason forKey:@"exchangeReason"];
    [parameters setValue: self.orderID forKey:@"orderId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_ConfirmExchange;
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
//    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_ConfirmExchange]) {
                if ([parserObject.code isEqualToString:@"200"]) {
                    
                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
                    orderOperationSuccessVC.orderID = parserObject.datas[@"orderId"];
                    orderOperationSuccessVC.controllerType = OrderOperationSuccessVCTypeExchangeSubmit;
                    orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }
        }
    }
}



#pragma  mark -- 配置楼层信息

- (void)handleTableViewFloorsData
{
    
    for (ProductlistModel *model in self.goodlist) {
        
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.isShow = YES;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight =  0.01;
        cellModel.Data = model;
        [sectionArr addObject:cellModel];
        

        
       
        [self.floorsAarr addObject:sectionArr];
    }
    
}

////统计
-(void)handleTabStatisticsData{
    //统计
    NSInteger count = 0;
    
    for (ProductlistModel * model in self.goodlist) {
        count += [model.goodsCount integerValue];
    }
    NSMutableArray *section8Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *giftTitleCellModel = [[CommonTVDataModel alloc] init];
    giftTitleCellModel.cellIdentify = KGiftTitleTCell;
    giftTitleCellModel.cellHeight = KGiftTitleTCellH;
    giftTitleCellModel.cellHeaderHeight = 5;
    giftTitleCellModel.cellFooterHeight = 0.01;
    giftTitleCellModel.Data = [NSString stringWithFormat:@"共换%ld件商品",count];
    [section8Arr addObject:giftTitleCellModel];
    [self.floorsAarr addObject:section8Arr];
}
////备注
-(void)handleTabMarkData{
    //添加赠品
    NSMutableArray *section8Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *giftTitleCellModel = [[CommonTVDataModel alloc] init];
    giftTitleCellModel.cellIdentify = KGiftTitleTCell;
    giftTitleCellModel.cellHeight = KGiftTitleTCellH;
    giftTitleCellModel.cellHeaderHeight = 5;
    giftTitleCellModel.cellFooterHeight = 0.01;
    giftTitleCellModel.Data = @"换货原因";
    [section8Arr addObject:giftTitleCellModel];
    [self.floorsAarr addObject:section8Arr];
    //备注
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.value =self.exchangeReason;
    tmModel.isEdit = YES;
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = KSellGoodsOrderMarkTCell;
    markCellModel.cellHeight = KSellGoodsOrderMarkTCellH;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    markCellModel.Data = tmModel;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}


#pragma mark -- Getter&Setter
- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
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
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderStatisticsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"GiftTitleTCell" bundle:nil] forCellReuseIdentifier:@"GiftTitleTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.noDataDes = @"暂无可退订单";
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
@end
