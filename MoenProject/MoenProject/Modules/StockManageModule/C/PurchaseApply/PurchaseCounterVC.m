//
//  PurchaseCounterVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/31.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "PurchaseCounterVC.h"
#import "CommonSingleGoodsTCell.h"
#import "OrderDetailModel.h"
#import "OrderHeaderTCell.h"
#import "CounterAddressTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "SellGoodsOrderMarkTCell.h"
#import "SellGoodsOrderStatisticsTCell.h"
#import "OrderConfigTCell.h"
#import "OrderReturnStatusTCell.h"
#import "CommonGoodsModel.h"
#import "OrderInstallationTCell.h"
#import "GiftTitleTCell.h"
#import "OrderOperationSuccessVC.h"
#import "PurchaseCounterModel.h"
#import "OrderPromotionTCell.h"

#import "XwSystemTCellModel.h"
#import "XWOrderDetailDefaultCell.h"


@interface PurchaseCounterVC ()<UITableViewDelegate, UITableViewDataSource,FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton* btn1;
@property (weak, nonatomic) IBOutlet UIButton* btn2;
@property (nonatomic, strong) PurchaseCounterModel *dataModel;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) OrderDetailModel *detailModel;

@property (nonatomic, assign) OrderOperationSuccessVCType successType;

@property (nonatomic, strong) NSString *wishReceiveDate;

@property (nonatomic, strong) NSString *orderRemarks;
 
@end

@implementation PurchaseCounterVC

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
    
    if(self.controllerType == SearchGoodsVCType_Stock){
        self.title = @"进货柜台";
        self.btn1.titleLabel.text =@"保存";
    } if(self.controllerType == SearchGoodsVCType_Transfers){
        self.title = @"调拨柜台";
        self.btn1.titleLabel.text =@"继续添加";
        self.btn2.titleLabel.text =@"确认订单";
    }
    
        
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = AppBgBlueGrayColor;
    self.myTableView.emptyDataSetSource = self;
    self.myTableView.emptyDataSetDelegate = self;
    self.comScrollerView = self.myTableView;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SellGoodsOrderStatisticsTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderStatisticsTCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
    [self.myTableView registerClass:[XWOrderDetailDefaultCell class] forCellReuseIdentifier:@"XWOrderDetailDefaultCell"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.btn1.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    self.btn2.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    self.myTableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight +40);
    
}

- (void)configBaseData
{

    self.wishReceiveDate = @"";
    self.orderRemarks = @"";
    
    [self.floorsAarr removeAllObjects];
    if(self.controllerType == SearchGoodsVCType_Transfers){
        [self handleTableAallotInfoData];
    }
    [self handleTableViewFloorsData];
    
    [self handleTabStatisticsData];
    [self handleTabWishReceivekData];
    [self handleTabMarkData];
    [self.myTableView reloadData];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
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
    WEAKSELF
//    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonMealProdutcModel:goodsModel AtIndex:indexPath.section];
        [cell showDataWithCommonGoodsModel:model.Data AtIndex:indexPath.section WihtControllerType:1];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPromotionTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForSearch:model.Data];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
//        [cell showDataWithCommonProdutcModelForSearch:model.Data];
        [cell showDataWithStockTransfersForCommonSearch:model.Data];
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
        if(self.controllerType == SearchGoodsVCType_Stock||
           self.controllerType ==SearchGoodsVCType_Transfers){//进货柜台需要添写备注
//            cell.orderRemarks = self.orderRemarks;
            cell.defModel = model.Data;
            
        } else {
            [cell showDataWithString: model.Data];
        }
            cell.orderMarkBlock = ^(NSString *text) {
                self.orderRemarks = text;
            };
        return cell;
    }else if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XWOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWOrderDetailDefaultCell" forIndexPath:indexPath];
        XwSystemTCellModel* tmModel = model.Data;
        if([tmModel.value isEqualToString:@"请填写"]&& ![self.wishReceiveDate isEqualToString:@""]){
            tmModel.value = self.wishReceiveDate;
        }
        cell.model = tmModel;
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
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XwSystemTCellModel* tm = model.Data;
        if([tm.type isEqualToString:@"select"]){
            Dialog()
                .wEventOKFinishSet(^(id anyID, id otherData) {
                    NSLog(@"选中 %@ %@",anyID,otherData);
                    self.wishReceiveDate =[NSString stringWithFormat:@"%@-%@-%@",anyID[0],anyID[1],anyID[2]];
                    [self.myTableView reloadData];
                })
                .wDateTimeTypeSet(@"yyyy年MM月dd日")
                .wDefaultDateSet([NSDate date])
                .wTypeSet(DialogTypeDatePicker)
                .wStart();
            
        }
    }
}
- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
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
        [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    

}

-(IBAction)onSave:(UIButton*)sender
{
    NSLog(@"保存");
    
    
    if (self.controllerType == SearchGoodsVCType_Transfers ){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString* message =@"";
        self.successType = OrderOperationSuccessVCTypeStockSave;
        message=@"确认保存进货申请信息吗？";
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:message delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
    }
    
    
}
-(IBAction)onSubmit:(UIButton*)sender
{
    NSLog(@"提交审核");
    NSString* message =@"";
    if(self.controllerType == SearchGoodsVCType_Stock ){
        self.successType = OrderOperationSuccessVCTypeStockSubmit;
        message = @"确认将进货申请提交至AD审核吗？";
    } else if (self.controllerType == SearchGoodsVCType_Transfers ){
        self.successType = OrderOperationSuccessVCTypeTransfersSubmit;
        message = @"确认提交调拨申请吗？";
    }
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:message delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        
        if(self.successType == OrderOperationSuccessVCTypeStockSave){
            [self httpPath_stock_apply:@"save"];
        } else {
            [self httpPath_stock_apply:@"apply"];
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
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_stock_apply]||[operation.urlTag isEqualToString:Path_dallot_applyByTransfer]) {
//                PurchaseCounterModel *dataModel = (PurchaseCounterModel *)parserObject;
                if ([parserObject.code isEqualToString:@"200"]) {
                    
                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
                    orderOperationSuccessVC.orderID = parserObject.datas[@"orderID"];
                    orderOperationSuccessVC.controllerType = self.successType;
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
- (void)handleTableAallotInfoData{
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title = @"调拨信息";
    tmModel.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = tmModel;
    [section4Arr addObject:delivereModel];
    
    XwSystemTCellModel* tm1 = [XwSystemTCellModel new];
    tm1.title = [NSString stringWithFormat:@"调拨对象:%@",self.storeName];
    tm1.showArrow = NO;
    CommonTVDataModel *model = [[CommonTVDataModel alloc] init];
    model.cellIdentify = @"XWOrderDetailDefaultCell";
    model.cellHeight = 30;
    model.cellHeaderHeight = 0.01;
    model.cellFooterHeight =  5;
    model.Data = tm1;
    [section4Arr addObject:model];
    
    [self.floorsAarr addObject:section4Arr];
}
- (void)handleTableViewFloorsData
{
    
    self.detailModel = [[OrderDetailModel alloc] init];
    
    for (CommonGoodsModel *model in self.dataSource) {
        
        model.isShowDetail = NO;
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        if (!model.isSetMeal) {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.isShow = YES;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
            self.detailModel.productCount += model.kGoodsCount;
        }
        else
        {
            NSInteger setMealCount = 0;
            for (CommonProdutcModel* tm in model.productList) {
                setMealCount += tm.count;
            }
            self.detailModel.productCount = setMealCount * model.kGoodsCount;
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.isShow = YES;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        }
        
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight =  0.01;
        cellModel.Data = model;
        [sectionArr addObject:cellModel];
        

        
       
        [self.floorsAarr addObject:sectionArr];
    }
    
    
   
    
    
    
    
    
}
//期望收货时间
-(void)handleTabWishReceivekData{
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title =@"期望收货时间";
    tmModel.value =@"请填写";
    tmModel.type =@"select";
    tmModel.showArrow = YES;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = tmModel;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}
////统计
-(void)handleTabStatisticsData{
    //统计
    NSMutableArray *section5Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *statisticsCellModel = [[CommonTVDataModel alloc] init];
    statisticsCellModel.cellIdentify = KSellGoodsOrderStatisticsTCell;
    statisticsCellModel.cellHeight = KSellGoodsOrderStatisticsTCellH;
    statisticsCellModel.cellHeight -= 30 * 5;
    statisticsCellModel.cellHeaderHeight = 0.01;
    statisticsCellModel.cellFooterHeight = 5;
    statisticsCellModel.Data = self.detailModel;
    [section5Arr addObject:statisticsCellModel];
    [self.floorsAarr addObject:section5Arr];
}
////备注
-(void)handleTabMarkData{
    //备注
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.value =self.orderRemarks;
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
/**进货申请Api*/
- (void)httpPath_stock_apply:(NSString*)commitType
{
    NSMutableArray* array = [NSMutableArray array];
    for (CommonGoodsModel* model in self.dataSource) {
//        NSLog(@"goodsID = %@ goodsCount =%@ type=%@",model.id,@(model.kGoodsCount),model.isSetMeal?@"setMeal":@"product")
        NSDictionary* dict = @{
            @"goodsID":model.id,
            @"goodsCount":@(model.kGoodsCount),
            @"type":model.isSetMeal?@"setMeal":@"product",
        };
        [array addObject:dict ];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:[array copy] forKey:@"apply"];
    
    if(self.controllerType == SearchGoodsVCType_Stock ){
        [parameters setValue:commitType forKey:@"commitType"];
        [parameters setValue:self.goodsType forKey:@"goodsType"];
        
    } else if(self.controllerType == SearchGoodsVCType_Transfers){
        [parameters setValue:self.storeID forKey:@"allotBy"];
    }
    
    [parameters setValue:self.wishReceiveDate forKey:@"wishReceiveDate"];
    [parameters setValue:self.orderRemarks forKey:@"orderRemarks"];
   
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    
    if(self.controllerType == SearchGoodsVCType_Stock ){
        self.requestURL = Path_stock_apply;
        
    } else if(self.controllerType == SearchGoodsVCType_Transfers){
        self.requestURL = Path_dallot_applyByTransfer;
    }
    
}
   
    
/**订单详情Api*/
- (void)httpPath_orderDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"123" forKey:@"id"];
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

@end
