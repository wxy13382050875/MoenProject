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
#import "PurchaseCounterVC.h"

#import "XwOrderDetailStockCell.h"
#import "XwSystemTCellModel.h"
#import "XWOrderDetailDefaultCell.h"
#import "SellGoodsOrderStatisticsTCell.h"

#import "XwOrderDetailDeliveryCell.h"

#import "XwOrderDetailStockInfoCell.h"
#import "XwOrderDetailAllotCell.h"
#import "XwOrderDetailAuditMarkCell.h"
#import "XwOrderDetailRefundCell.h"
#import "XwOrderDetailTotalCell.h"
#import "XwOrderDetailAdjustInventoryCell.h"
#import "XwOrderDetailGoodsInventory.h"
#import "PurchaseTypeChooseVC.h"
#import "XwOrderDetailGoodCell.h"
#import "XwProblemInventoryVC.h"

#import "OrderDetailVC.h"

#import "XwDeliveMarkrCell.h"//发货备注
#import "XwExpressCell.h"
#import "TZImagePickerController.h"
#import "NSHttpClient.h"
#import "BaseModelFactory.h"
@interface XwOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource ,FDAlertViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;

@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;

@property (nonatomic, strong) XwOrderDetailModel *dataModel;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray *giftGoodsList;

@property (nonatomic, strong) NSString *wishReceiveDate;

@property (nonatomic, strong) NSString *orderRemarks;
@property (nonatomic, strong) NSString *expressID;//快递单号
@property (nonatomic, strong) NSString *remarks;//发货备注信息
@property (nonatomic, strong) NSString *expressIMG;//快递图片
 
@property (nonatomic, assign) BOOL isDeliver;


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

//UIImage 数组
@property (nonatomic,strong) NSArray *photoArray;

//UIImage Asset 数组
@property (nonatomic,strong) NSArray *assetsArray;
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
//    self.title = NSLocalizedString(@"order_detail", nil);
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0)) ;
    
//    审核（同意/拒绝/发货） approve/refuse/deliver
    self.btn = [UIButton buttonWithTitie:@"同意" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"同意");
        if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
            [self httpPath_refund_returnOperate:@"approve"];
        } else{
            [self httpPath_dallot_transferOperate:@"agree"];
        }
        
    }];
    [self.view addSubview:self.btn];
    self.btn1 = [UIButton buttonWithTitie:@"拒绝" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor] WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"拒绝");
        if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
            [self httpPath_refund_returnOperate:@"refuse"];
        } else{
            [self httpPath_dallot_transferOperate:@"refuse"];
        }
    }];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithTitie:@"确认发货" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        NSLog(@"确认发货");
        FDAlertView *alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否确认发货" block:^(NSInteger buttonIndex, NSString *inputStr) {
            if(buttonIndex == 1){
                if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
                    [self httpPath_refund_returnOperate:@"deliver"];
                } else{
                    [self httpPath_dallot_transferOperate:@"deliver"];
                }
            }
        } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil),  nil];
        [alert show];

        
    }];
    [self.view addSubview:self.btn2];
    
    self.btn3 = [UIButton buttonWithTitie:@"确认收货" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {

        
        FDAlertView *alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否确认收货" block:^(NSInteger buttonIndex, NSString *inputStr) {
            if(buttonIndex == 1){
                [self httpPath_delivery_confirmReceipt];
            }
        } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil),  nil];
        [alert show];
    }];
    [self.view addSubview:self.btn3];
    
    
    self.btn4 = [UIButton buttonWithTitie:@"继续添加" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
       
        NSMutableArray* selectArr = [NSMutableArray new];
        for (Goodslist* tm in self.dataModel.goodsList) {
            CommonGoodsModel* coModel = [CommonGoodsModel new];
            coModel.id = tm.goodsID;
            coModel.isSetMeal = tm.goodsPackage!=nil?true:false;
            coModel.code = [tm.goodsSKU mutableCopy];
            coModel.price = [tm.goodsPrice mutableCopy];
            coModel.name = [tm.goodsName mutableCopy];
            coModel.photo = [tm.goodsIMG mutableCopy];
            coModel.kGoodsCount = [tm.goodsCount integerValue];
            if(tm.goodsPackage != nil){
                NSMutableArray* productList =[NSMutableArray new];
                for (Goodslist* packs  in tm.goodsPackage.goodsList) {
                    CommonProdutcModel* prModel = [CommonProdutcModel new];
                    prModel.sku = [packs.goodsSKU mutableCopy];
                    prModel.price = [packs.goodsPrice mutableCopy];
                    prModel.count = [packs.goodsCount integerValue];
                    prModel.photo = [packs.goodsIMG mutableCopy];
                    prModel.name = [packs.goodsName mutableCopy];
                    [productList addObject:prModel];
                }
                coModel.productList = productList;
            }
            
            [selectArr addObject:coModel];
        }
        StockSearchGoodsVC *sellGoodsScanVC = [[StockSearchGoodsVC alloc] init];
        sellGoodsScanVC.goodsType = self.dataModel.orderType;
        sellGoodsScanVC.controllerType = SearchGoodsVCType_Stock;
        sellGoodsScanVC.selectedDataArr = selectArr;
        sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
    }];
    [self.view addSubview:self.btn4];
    
    self.btn5 = [UIButton buttonWithTitie:@"提交审核" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor]  WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认将进货申请提交至AD审核吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
        
    }];
    [self.view addSubview:self.btn5];
    
    self.btn6 = [UIButton buttonWithTitie:@"调整" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor]  WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        XwProblemInventoryVC* VC = [XwProblemInventoryVC new];
        VC.goodsType = self.dataModel.orderType;
        /**日常盘点*/
        
        if( self.controllerType == PurchaseOrderManageVCTypePlateStorage){
            VC.controllerType = PurchaseOrderManageVCTypeStockDaily;
        }  else if( self.controllerType == PurchaseOrderManageVCTypeLibrary){
            VC.controllerType = PurchaseOrderManageVCTypeStockAdjust;
        }
        
        VC.model = self.dataModel;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }];
    [self.view addSubview:self.btn6];
    
    
    self.btn1.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    self.btn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
 
    self.btn2.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    
    self.btn3.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    
    self.btn4.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    self.btn5.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
    
    self.btn6.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    
    self.btn.hidden = YES;
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [self httpPath_stock_apply];
        
    }
}
- (void)configBaseData
{
    self.wishReceiveDate = @"";
    self.orderRemarks = @"";
    
    self.expressID= @"";
    self.remarks= @"";
    self.expressIMG= @"";
    
    
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
    
    return 0.1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableArray *dataArr = self.floorsAarr[section];
    if(dataArr.count > 0){
        CommonTVDataModel *model = dataArr[0];
        return model.cellFooterHeight;
    } else {
        return 0.01;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    
    if ([model.cellIdentify isEqualToString:@"XwOrderDetailStockCell"]) {
        XwOrderDetailStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailStockCell" forIndexPath:indexPath];
        cell.model = self.dataModel;
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:@"XwOrderDetailGoodCell"])
    {
        XwOrderDetailGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailGoodCell" forIndexPath:indexPath];
        if(self.isDeliver){
            cell.delModel = model.Data;
        } else {
            cell.model = model.Data;
        }
        
        cell.goodsShowDetailBlock = ^(BOOL isShow) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:indexPath];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KReturnOrderDetailReasonTCell])
    {
        ReturnOrderDetailReasonTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderDetailReasonTCell" forIndexPath:indexPath];
//        [cell showDataWithString:self.dataModel.returnReason];
        [cell showDataRefundWithString:self.dataModel.returnReason];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {

    
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderPromotionTCell forIndexPath:indexPath];
//        [cell showDataWithOrderAcitvitiesString:self.dataModel.maxAmount WithOrderDerate:@""];
        
        return cell;
    }

    else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        
        
        cell.defModel = model.Data;
        cell.orderMarkBlock = ^(NSString *text) {
            self.orderRemarks = text;
        };
        
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XWOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWOrderDetailDefaultCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    }else if ([model.cellIdentify isEqualToString:@"XwOrderDetailDeliveryCell"]){
        XwOrderDetailDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailDeliveryCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailStockInfoCell"]){
        XwOrderDetailStockInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailStockInfoCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailAllotCell"]){
        XwOrderDetailAllotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailAllotCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailAuditMarkCell"]){
        XwOrderDetailAuditMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailAuditMarkCell" forIndexPath:indexPath];
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailRefundCell"]){
        XwOrderDetailRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailRefundCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailTotalCell"]){
        XwOrderDetailTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailTotalCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailAdjustInventoryCell"]){
        XwOrderDetailAdjustInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailAdjustInventoryCell" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwOrderDetailGoodsInventory"]){
        XwOrderDetailGoodsInventory *cell = [tableView dequeueReusableCellWithIdentifier:@"XwOrderDetailGoodsInventory" forIndexPath:indexPath];
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XwExpressCell"]){//快递单号
        XwExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwExpressCell" forIndexPath:indexPath];
//        cell.model = model.Data;
        if(![self.expressIMG isEqualToString:@""]){
            cell.expressIMG = self.expressIMG;
        }
        cell.inputBlock = ^(NSString * _Nonnull text) {
            self.expressID = text;
        };
        cell.openBlock = ^{
            NSLog(@"打开相册");
            [self openCamera];
        };
        return cell;
    }else if ([model.cellIdentify isEqualToString:@"XwDeliveMarkrCell"]){//发货备注
        XwDeliveMarkrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XwDeliveMarkrCell" forIndexPath:indexPath];
//        cell.model = model.Data;
        cell.inputBlock = ^(NSString * _Nonnull text) {
            self.remarks = text;
        };
        return cell;
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
//    NSMutableArray *dataArr = self.floorsAarr[section];
    
    
    
  
    
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
    
    
    if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XwSystemTCellModel* tm = model.Data;
        if([tm.type isEqualToString:@"skip"]){
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = tm.deliverID;
            orderDetailVC.isHide = YES;
            if(self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||//调拨单发货信息
                      self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeDeliveryApply;
                
            }  else if( self.controllerType == PurchaseOrderManageVCTypeInventoryStocker){//总仓发货
                
                 orderDetailVC.controllerType = PurchaseOrderManageVCTypeDeliveryStocker;
                
             }  else if( self.controllerType == PurchaseOrderManageVCTypeSTOCK){//进货单
                 
                 orderDetailVC.controllerType = PurchaseOrderManageVCTypeDeliveryOrder;
             }
            
            
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
    } else if([model.cellIdentify isEqualToString:@"XwOrderDetailStockInfoCell"]){
        XwOrderDetailModel* tm = model.Data;
        if(self.controllerType == PurchaseOrderManageVCTypeInventoryStocker){/**库存-总仓发货*/
//                  orderDetailVC.orderID = tm.taskID;
//                  orderDetailVC.controllerType = PurchaseOrderManageVCTypeSTOCK;
            OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
            orderDetailVC.orderID = tm.orderID;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
         } else if( self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){//发货-门店自提
         } else {//发货-门店自提
           
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
    //        orderDetailVC.orderID = tm.ordeID;
            if( self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){//发货-进货申请
                orderDetailVC.orderID = tm.sendOrderID;
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeSTOCK;
            }
            else if( self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){//发货-调拨申请
                orderDetailVC.orderID = tm.orderCode;
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeAllocteOrder;
            }  else if( self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){//发货-总仓发货
                 orderDetailVC.orderID = tm.orderCode;
                 orderDetailVC.controllerType = PurchaseOrderManageVCTypeInventoryStocker;
              }
            [self.navigationController pushViewController:orderDetailVC animated:YES];
         }
        
    }
}
- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSIndexPath*)indexPath
{
    
    NSMutableArray *sectionArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel* tm =  sectionArr[indexPath.row];
    Goodslist *goodsModel = tm.Data;
    if (isShow) {
        NSInteger index  = indexPath.row;
        for (Goodslist *model in goodsModel.goodsPackage.goodsList) {
            model.orderStatus = self.dataModel.orderApplyProgress;
            model.controllerType = self.controllerType;
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

        [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.goodsPackage.goodsList.count, goodsModel.goodsPackage.goodsList.count)];
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
    CommonMealProdutcModel *goodsModel = self.giftGoodsList[atIndex - intervalNumber - self.goodsList.count - 1];
    if (isShow) {
        NSInteger cellDataIndex = 0;
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGiftGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            cellModel.dataIndex = cellDataIndex;
            [sectionArr addObject:cellModel];
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
    }else if([status isEqualToString:@"refuse"]){
        orderStatus = @"已拒绝";
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
    }
    
    
   
    
    return orderStatus;
}
-(NSString*)getInventoryStatus:(NSString*)status{
    NSString* orderStatus= @"";
    if([status isEqualToString:@"all"]){
        orderStatus = @"待提交";
    } else if([status isEqualToString:@"ing"]){
        orderStatus = @"盘库中";
    } else if([status isEqualToString:@"wait"]){
        orderStatus = @"待审核";
    } else if([status isEqualToString:@"pass"]){
        orderStatus = @"审核不通过";
    } else if([status isEqualToString:@"finish"]){
        orderStatus = @"已完成";
    }
    return orderStatus;
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
            [self.floorsAarr removeAllObjects];
            if ([operation.urlTag isEqualToString:Path_stock_orderDetail]) {//进货单详情
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.orderRemarks = self.dataModel.orderRemarks;
                    self.dataModel.orderStatusText = [self getOrderStatus:self.dataModel.orderApplyProgress];
                    self.dataModel.progressName = @"进货申请进度";
                    if([self.dataModel.orderApplyProgress isEqualToString:@"waitSub"]){
                        self.btn4.hidden = NO;
                        self.btn5.hidden = NO;
                    }
                    [self handleTabStockData];
                    [self handleTabProgressData];
                    [self handleTabSendInfoData];
                    [self handleTableViewFloorsData];
                    [self handleTabStatisticsData];
                    [self handleTabWishReceivekData];
                    
                    [self handleTabMarkData:YES];
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if([operation.urlTag isEqualToString:Path_stock_apply]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"提交审核成功"];
                    OrderOperationSuccessVC *orderOperationSuccessVC = [[OrderOperationSuccessVC alloc] init];
                    orderOperationSuccessVC.orderID = parserObject.datas[@"orderID"];
                    orderOperationSuccessVC.controllerType = OrderOperationSuccessVCTypeStockSubmit;
                    orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if ([operation.urlTag isEqualToString:Path_delivery_sendOrderDetail]) {//发货单详情
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    if([self.dataModel.sendOrderStatus isEqualToString:@"waitGoods"]&& !self.isHide){
                        self.btn3.hidden = NO;
                    }
                    
                    self.dataModel.orderStatusText =  [self getOrderStatus:self.dataModel.sendOrderStatus];;
                    
                    if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){
                        self.dataModel.progressName = @"进货单";
                    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
                        self.dataModel.progressName = @"调拨单";
                    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){
                        self.dataModel.progressName = @"订单";
                    }else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
                        self.dataModel.progressName = @"总仓发货";
                    }
                    
                    self.orderRemarks = self.dataModel.orderRemarks;
                    
                    [self handleTabdDliverData];//发货单头部信息
                    [self handleTabdStockDliverData];//发货单进货信息
                    [self handleTabInvoicesData];
                    [self handleTableViewFloorsData];
                    [self handleTabStatisticsData];
                    [self handleTabMarkData:NO];
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }  else if([operation.urlTag isEqualToString:Path_delivery_confirmReceipt]){
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"确认收货成功"];
                    if(self.refreshBlock){
                        self.refreshBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if ([operation.urlTag isEqualToString:Path_dallot_transferOrderDetail]) {//调拔单详情
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.orderRemarks = self.dataModel.orderRemarks;
                    if([self.dataModel.orderType isEqualToString:@"task"]){
                        if([self.dataModel.orderApplyProgress isEqualToString:@"waitDeliver"]||
                           [self.dataModel.orderApplyProgress isEqualToString:@"partDeliver"]){
                            self.btn2.hidden = NO;
                            self.isDeliver = YES;
                        } else if([self.dataModel.orderApplyProgress isEqualToString:@"wait"]&&
                                  self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
                            self.btn.hidden = NO;
                            self.btn1.hidden = NO;
                        }
                    }
                    
                    
                    self.dataModel.orderStatusText = [self getOrderStatus:self.dataModel.orderApplyProgress];
                    self.dataModel.progressName = @"调拨申请进度";
                    
                    [self handleTabAllotData];
                    [self handleTabProgressData];
                    [self handleTabSendInfoData];
                    [self handleTableViewFloorsData];
                    
                    [self handleTabStatisticsData];
                    [self handleTabWishReceivekData];
                    [self handleTabMarkData:NO];
                    
                    
                    if([self.dataModel.orderApplyProgress isEqualToString:@"waitDeliver"]){
                        [self handleTabExpressData];
                        [self handleTabDeliveMarkData];
                    }
                    
                    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask&&
                       [self.dataModel.orderApplyProgress isEqualToString:@"wait"]){
                        [self handleTabAuditMarkData];
                    }
                    
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if([operation.urlTag isEqualToString:Path_dallot_transferOperate]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"调拨操作成功"];
                    if(self.refreshBlock){
                        self.refreshBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                
                
            } else if ([operation.urlTag isEqualToString:Path_refund_returnOrderDetail]) {//退仓单详情
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    if([self.dataModel.orderApplyProgress isEqualToString:@"waitDeliver"]){
                        self.btn2.hidden = NO;
                    } else if([self.dataModel.orderApplyProgress isEqualToString:@"wait"]){
                        self.btn.hidden = NO;
                        self.btn1.hidden = NO;
                    }
                    self.dataModel.orderStatusText = [self getOrderStatus:self.dataModel.orderApplyProgress];
                    self.dataModel.progressName = @"退仓进度";
                    
                    [self handleTabRefundData];
                    [self handleTabProgressData];
                    [self handleTabGoodsInfoData];
                    [self handleTableViewFloorsData];
                    [self handleTabStatisticsData];
                    [self handleTabRefundReasonData];
                    
                    if([self.dataModel.orderApplyProgress isEqualToString:@"wait"]){
                        [self handleTabMarkData:YES];
                    } else {
                        if(![self.dataModel.checkRemarks isEqualToString:@""]){
                            self.orderRemarks = self.dataModel.checkRemarks;
                            [self handleTabMarkData:NO];
                        }
                    }
                    
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }else if([operation.urlTag isEqualToString:Path_refund_returnOperate]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"退仓操作成功"];
                    if(self.refreshBlock){
                        self.refreshBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                
                
            } else if (
                [operation.urlTag isEqualToString:Path_inventory_generalOrderDetail]) {//总仓明细
//                    self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                    self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataModel.orderStatusText = [self getOrderStatus:self.dataModel.generalOrderProgress];
                    self.dataModel.progressName = @"总仓任务进度";
                    
                    [self handleTabTotalData];
                    [self handleTabdStockDliverData];
                    [self handleTabProgressData];
                    [self handleTabSendInfoData];
                    [self handleTableViewFloorsData];
                    
                    [self handleTabStatisticsData];
                    [self handleTabWishReceivekData];
                    [self handleTabMarkData:NO];
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            } else if ([operation.urlTag isEqualToString:Path_inventory_inventoryCheckOrderDetail]) {//盘库单明细
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                       
                       if ([parserObject.code isEqualToString:@"200"]) {
                           
                           if([self.dataModel.orderStatus isEqualToString:@"stop"]){
                               self.btn6.hidden = NO;
                           }
                           self.isShowEmptyData = NO;
                           self.dataModel.orderStatusText = [self getInventoryStatus:self.dataModel.orderStatus];
                           self.dataModel.progressName = @"盘库单";
                           [self handleTabAdjustInventoryData];
                           [self handleTableViewInventoryData];
                           [self handleTabInventoryStatisticsData];
                           [self.tableView reloadData];
                       }
                       else
                       {
                           self.isShowEmptyData = YES;
                           [[NSToastManager manager] showtoast:parserObject.message];
                       }
                       
            } else if ([operation.urlTag isEqualToString:Path_inventory_callInventoryOrderDetail]) {//调库单详情
                self.dataModel = [XwOrderDetailModel mj_objectWithKeyValues:parserObject.datas[@"datas"]];
                       
                       if ([parserObject.code isEqualToString:@"200"]) {
                           if([self.dataModel.orderStatus isEqualToString:@"stop"]){
                               self.btn6.hidden = NO;
                           }
                           self.isShowEmptyData = NO;
                           self.dataModel.orderStatusText = [self getInventoryStatus:self.dataModel.orderStatus];
                           self.dataModel.progressName = @"调库单";
                           [self handleTabAdjustInventoryData];
                           [self handleTableViewInventoryData];
                           [self handleTabInventoryStatisticsData];
                           [self.tableView reloadData];
                       }
                       else
                       {
                           self.isShowEmptyData = YES;
                           [[NSToastManager manager] showtoast:parserObject.message];
                       }
                       
            }else if([operation.urlTag isEqualToString:Path_stock_apply]) {
                [self httpPath_orderDetail];;
                
            }else if([operation.urlTag isEqualToString:Path_delivery_confirmReceipt]) {
                [[NSToastManager manager] showtoast:@"收货成功"];
                if(self.refreshBlock){
                    self.refreshBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];;
                
            }
        }
    }
}



#pragma  mark -- 配置楼层信息
//进货单头部信息
-(void)handleTabStockData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailStockCell";
    orderHeaderCellModel.cellHeight = 100;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//发货单头部信息
-(void)handleTabdDliverData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailDeliveryCell";
    orderHeaderCellModel.cellHeight = 140;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//调拨单头部信息
-(void)handleTabAllotData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailAllotCell";
    orderHeaderCellModel.cellHeight = 140;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//退仓单头部信息
-(void)handleTabRefundData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailRefundCell";
    orderHeaderCellModel.cellHeight = 100;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//总仓发货头部信息
-(void)handleTabTotalData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailTotalCell";
    orderHeaderCellModel.cellHeight = 100;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//盘库调库头部信息
-(void)handleTabAdjustInventoryData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailAdjustInventoryCell";
    orderHeaderCellModel.cellHeight = 100;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//发货单进货单信息
-(void)handleTabdStockDliverData{
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = @"XwOrderDetailStockInfoCell";
    orderHeaderCellModel.cellHeight = 100;
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 5;
    orderHeaderCellModel.Data = self.dataModel;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
}
//详情进度信息
-(void)handleTabProgressData{
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = self.dataModel.progressName;
    model.value = self.dataModel.orderStatusText;
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
//发货商品信息
-(void)handleTabInvoicesData{
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = @"发货商品信息";
    
    model.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = model;
    [section4Arr addObject:delivereModel];
    
//    if (self.dataModel.sendOrderInfo.count > 0) {
//        for (NSDictionary* dict in self.dataModel.sendOrderInfo) {
//            XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
//            tmModel.title = dict[@"sendOrderTime"];;
//            tmModel.value = dict[@"sendOrderID"];
//            tmModel.deliverID =dict[@"sendOrderID"];
//            tmModel.showArrow = YES;
//            tmModel.type = @"skip";
//            CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
//            delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
//            delivereModel.cellHeight = 30;
//            delivereModel.cellHeaderHeight = 0.01;
//            delivereModel.cellFooterHeight =  0.01;
//            delivereModel.Data = tmModel;
//            [section4Arr addObject:delivereModel];
//        }
//
//    } else {
//        XwSystemTCellModel* model = [XwSystemTCellModel new];
//        model.title = @"暂无发货信息";
//        model.showArrow = NO;
//        CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
//        delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
//        delivereModel.cellHeight = 30;
//        delivereModel.cellHeaderHeight = 0.01;
//        delivereModel.cellFooterHeight =  0.01;
//        delivereModel.Data = model;
//        [section4Arr addObject:delivereModel];
//    }
    
    [self.floorsAarr addObject:section4Arr];
}
//发货信息
-(void)handleTabSendInfoData{
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
    
    if (self.dataModel.sendOrderInfo.count > 0) {
        for (NSDictionary* dict in self.dataModel.sendOrderInfo) {
            XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
            tmModel.title = dict[@"sendOrderTime"];;
            tmModel.value = dict[@"sendOrderID"];
            tmModel.deliverID =dict[@"sendOrderID"];
            tmModel.showArrow = YES;
            tmModel.type = @"skip";
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
-(void)handleTabGoodsInfoData{
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    XwSystemTCellModel* model = [XwSystemTCellModel new];
    model.title = @"商品信息";
    model.showArrow = NO;
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  0.01;
    delivereModel.Data = model;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}
//商品信息
- (void)handleTableViewFloorsData
{
    
    for (Goodslist *model in self.dataModel.goodsList) {
        model.orderStatus = self.dataModel.orderApplyProgress;
        model.controllerType = self.controllerType;
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];

        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        cellModel.Data = model;
        cellModel.cellIdentify = @"XwOrderDetailGoodCell";
        if ( model.goodsPackage !=nil) {
            cellModel.cellHeight = 140;
        }
        else
        {
            cellModel.cellHeight = 115;
        }
        [sectionArr addObject:cellModel];
        [self.floorsAarr addObject:sectionArr];
        
    }
    
}
//库存商品信息
- (void)handleTableViewInventoryData
{
    NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
    for (Goodslist *model in self.dataModel.goodsList) {
        
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = @"XwOrderDetailGoodsInventory";
        cellModel.cellHeight = 150;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight = 5;
        cellModel.Data = model;
        
        [sectionArr addObject:cellModel];
        
    }
    
    [self.floorsAarr addObject:sectionArr];
}
//期望收货时间
-(void)handleTabWishReceivekData{
    
    NSString *string = self.dataModel.wishReceiveDate;
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormtter stringFromDate:inputDate];
    
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title =@"期望收货时间";
    tmModel.value =dateString;
    tmModel.showArrow = NO;
    tmModel.type = @"select";
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
//数量统计
-(void)handleTabStatisticsData{
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title =[NSString stringWithFormat:@"共%@件商品",self.dataModel.goodsCount];
//    tmModel.value =self.dataModel.wishReceiveDate;
    tmModel.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight = 5;
    delivereModel.Data = tmModel;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}
//备注
-(void)handleTabMarkData:(BOOL)isEdit{
    
    
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.value =[self.orderRemarks isEqualToString:@""]?@"备注：无":self.orderRemarks;
    tmModel.isEdit = isEdit;
    
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = KSellGoodsOrderMarkTCell;
    markCellModel.cellHeight = KSellGoodsOrderMarkTCellH;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    markCellModel.Data =tmModel;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
//审核备注
-(void)handleTabAuditMarkData{
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = @"XwOrderDetailAuditMarkCell";
    markCellModel.cellHeight = 80;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 40;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
//录入快递单号
-(void)handleTabExpressData{
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = @"XwExpressCell";
    markCellModel.cellHeight = 80;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
//填写发货备注信息
-(void)handleTabDeliveMarkData{
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = @"XwDeliveMarkrCell";
    markCellModel.cellHeight = 80;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = KWBottomSafeHeight + 40;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
//退仓原因
-(void)handleTabRefundReasonData{
    
    CGSize size = [self.dataModel.returnReason sizeWithFont:FONT(13) Size:CGSizeMake((SCREEN_WIDTH -30)- 90, 2000)];
    CGFloat height = 40;
    if(size.height  > 40){
        height  = size.height + 20;
    }
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = KReturnOrderDetailReasonTCell;
    markCellModel.cellHeight = height;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
//盘库调库数量统计
-(void)handleTabInventoryStatisticsData{
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title =@"盘库商品数量";
    tmModel.value =[NSString stringWithFormat:@"%@件",self.dataModel.goodsCount];
    tmModel.showArrow = NO;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight = 5;
    delivereModel.Data = tmModel;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
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
        self.title = @"退仓单详情";
        self.requestURL = Path_refund_returnOrderDetail;
    } else if(self.controllerType ==PurchaseOrderManageVCTypeAllocteOrder||
              self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
        self.title = @"调拨单详情";
        self.requestURL = Path_dallot_transferOrderDetail;
    }  else if( self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
               self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        self.title = @"发货单详情";
         self.requestURL = Path_delivery_sendOrderDetail;
     } else if( self.controllerType == PurchaseOrderManageVCTypeInventoryStocker){
         self.title = @"总仓任务详情";
         self.requestURL = Path_inventory_generalOrderDetail;
     } else if( self.controllerType == PurchaseOrderManageVCTypePlateStorage){
         self.title = @"盘库单详情";
         self.requestURL = Path_inventory_inventoryCheckOrderDetail;
     }  else if( self.controllerType == PurchaseOrderManageVCTypeLibrary){
         self.title = @"调库单详情";
         self.requestURL = Path_inventory_callInventoryOrderDetail;
     } else {
         self.title = @"进货单详情";
        self.requestURL = Path_stock_orderDetail;
    }
          
}

/**进货申请Api*/
- (void)httpPath_stock_apply
{
    NSMutableArray* array = [NSMutableArray array];
    for (Goodslist* model in self.dataModel.goodsList) {
//        NSLog(@"goodsID = %@ goodsCount =%@ type=%@",model.id,@(model.kGoodsCount),model.isSetMeal?@"setMeal":@"product")
        NSDictionary* dict = @{
            @"goodsID":model.goodsID,
            @"goodsCount":model.goodsCount,
            @"type":model.goodsPackage!=nil?@"setMeal":@"product",
        };
        [array addObject:dict ];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:[array copy] forKey:@"apply"];
    
    [parameters setValue:@"apply" forKey:@"commitType"];
    
    
    [parameters setValue:self.wishReceiveDate forKey:@"wishReceiveDate"];
    [parameters setValue:self.orderRemarks forKey:@"orderRemarks"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    
    self.requestURL = Path_stock_apply;
    
}

/**订单详情Api*/
- (void)httpPath_refund_returnOperate:(NSString*)operate
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue:operate forKey:@"operate"];
    [parameters setValue:self.orderRemarks forKey:@"checkRemarks"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_refund_returnOperate;
    
}
/**调拔操作Api*/
- (void)httpPath_dallot_transferOperate:(NSString*)operate
{
    
    NSMutableArray* array = [NSMutableArray array];
    for (Goodslist* model in self.dataModel.goodsList) {
        
        NSDictionary* dict = @{
            @"goodsID":model.goodsID,
            @"goodsCount":model.goodsCount,
            @"setMealId":model.goodsPackage!=nil?model.goodsID:@"",
        };
        [array addObject:dict ];
        
        
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue:operate forKey:@"operate"];
    [parameters setValue:self.expressID forKey:@"expressID"];
    [parameters setValue:self.expressIMG forKey:@"expressIMG"];
    [parameters setValue:self.remarks forKey:@"remarks"];
    [parameters setValue:array forKey:@"goodsList"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_dallot_transferOperate;
    
}
/**确认收货Api*/
- (void)httpPath_delivery_confirmReceipt{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: self.orderID forKey:@"orderID"];
    if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){
        [parameters setValue:@"order" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
        [parameters setValue:@"apply" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){
        [parameters setValue:@"shopSelf" forKey:@"orderType"];
    }else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        [parameters setValue:@"stocker" forKey:@"orderType"];
    }
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_delivery_confirmReceipt;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        
        
        [_tableView registerClass:[XwOrderDetailStockCell class] forCellReuseIdentifier:@"XwOrderDetailStockCell"];
        
        [_tableView registerClass:[XWOrderDetailDefaultCell class] forCellReuseIdentifier:@"XWOrderDetailDefaultCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[XwOrderDetailDeliveryCell class] forCellReuseIdentifier:@"XwOrderDetailDeliveryCell"];
        
        [_tableView registerClass:[XwOrderDetailStockInfoCell class] forCellReuseIdentifier:@"XwOrderDetailStockInfoCell"];
        
        [_tableView registerClass:[XwOrderDetailAllotCell class] forCellReuseIdentifier:@"XwOrderDetailAllotCell"];
        
        [_tableView registerClass:[XwOrderDetailAuditMarkCell class] forCellReuseIdentifier:@"XwOrderDetailAuditMarkCell"];
        
        [_tableView registerClass:[XwOrderDetailRefundCell class] forCellReuseIdentifier:@"XwOrderDetailRefundCell"];
        
        [_tableView registerClass:[XwOrderDetailTotalCell class] forCellReuseIdentifier:@"XwOrderDetailTotalCell"];
        
        [_tableView registerClass:[XwOrderDetailAdjustInventoryCell class] forCellReuseIdentifier:@"XwOrderDetailAdjustInventoryCell"];
        
        [_tableView registerClass:[XwOrderDetailGoodsInventory class] forCellReuseIdentifier:@"XwOrderDetailGoodsInventory"];
        
        [_tableView registerClass:[XwOrderDetailGoodCell class] forCellReuseIdentifier:@"XwOrderDetailGoodCell"];
        
        [_tableView registerClass:[XwExpressCell class] forCellReuseIdentifier:@"XwExpressCell"];
        
        [_tableView registerClass:[XwDeliveMarkrCell class] forCellReuseIdentifier:@"XwDeliveMarkrCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _tableView;
}
#pragma mark 相册
-(void)openCamera{
    WEAKSELF
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.allowTakePicture  = YES;
    [tzImagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.assetsArray = assets;
        weakSelf.photoArray = photos;
        [weakSelf upLoadImageAction];
    }];
    [self presentViewController:tzImagePickerVc animated:YES completion:nil];
}
- (void)extracted {
    [[NSHttpClient client] uploadWithUrl:Path_publishImage imageArr:self.photoArray progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [[NSToastManager manager] hideprogress];
//            MoenBaseModel *model = [BaseModelFactory modelWithURL:Path_publishProductSampleImage
//                                                     responseJson:responseObject];
//            if (model == nil) {
//                model = [[MoenBaseModel alloc] init];
//            }
//            model.code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//            model.message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
//
            NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([resultCode isEqualToString:@"200"]) {
                
//                NSLog(@"%@",responseObject[@"datas"][@"urls"])
                NSArray* array = responseObject[@"datas"][@"urls"];
//                NSLog(@"%@",[NSString DataTOjsonString:array])
                if(array.count > 0){
                    self.expressIMG = array[0];
                    [self.tableView reloadData];
                }
//                [[NSToastManager manager] showtoast:@"发表出样报告成功"];
//                ProductSampleResultModel *dataModel = (ProductSampleResultModel *)model;
//                SamplingDetailVC *samplingDetailVC = [[SamplingDetailVC alloc] init];
//                samplingDetailVC.controllerType = SamplingDetailVCTypeSuccess;
//                samplingDetailVC.dataModel = dataModel;
//                [self.navigationController setNavigationBarHidden:NO];
//                [self.navigationController pushViewController:samplingDetailVC animated:YES];
                
            }else{
                [[NSToastManager manager] showtoast:responseObject[@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@", error);
        [[NSToastManager manager] hideprogress];
    }];
}

/**上传图片操作*/
- (void)upLoadImageAction
{
    [[NSToastManager manager] showmodalityprogress];
    [self extracted];
}

@end
