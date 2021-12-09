//
//  StartCountStockVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "StartCountStockVC.h"
#import "StockSearchGoodsVC.h"
#import "FDAlertView.h"
#import "StoreStockVC.h"
@interface StartCountStockVC()<FDAlertViewDelegate>


@end

@implementation StartCountStockVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockSampleAdjustment ||
       self.controllerType == PurchaseOrderManageVCTypeStockGoodsAdjustment){
        self.title = @"调整库存";
    } else {
        self.title = @"开始盘库";
    }
    
    
    
    [self configBaseUI];
    [self configBaseData];
    
    
}
-(void)configBaseUI{
    int leftMargin = 20;
    int btnHeight = 50;
    int btnSpace = 20;
    
    int tipLabelStartTop =  100;
    int optLabelStartTop =  280;
    int optButtonStartTop =  400;
    
    
    CGSize tipSize = [@"冻结后，不允许门店做出入库操作。" sizeWithFont:FontBinB(14) constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    int labelLeftMargin = (SCREEN_WIDTH - tipSize.width) / 2;
    int labelHeight = 120;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftMargin, tipLabelStartTop, SCREEN_WIDTH - leftMargin * 2, labelHeight)];
    tipLabel.font = FontBinB(14);
    tipLabel.textColor = AppTitleBlackColor;
    tipLabel.text = @"是否要开始本次盘库？\n\n开始盘库后，将冻结门店库存。\n\n冻结后，不允许门店做出入库操作。";
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
    
    
    UILabel *optNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, optLabelStartTop, SCREEN_WIDTH - 60 * 2, 20)];
    optNameLabel.font = FontBinR(14);
    optNameLabel.textColor = AppTitleBlackColor;
    optNameLabel.text = @"操作人：李伟（导购）";
    optNameLabel.numberOfLines = 0;
    optNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:optNameLabel];
    
    UILabel *optTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, optLabelStartTop + 20, SCREEN_WIDTH - 60 * 2, 20)];
    optTimeLabel.font = FontBinR(14);
    optTimeLabel.textColor = AppTitleBlackColor;
    optTimeLabel.text = @"操作时间：2020/10/3";
    optTimeLabel.numberOfLines = 0;
    optTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:optTimeLabel];
    if(self.controllerType == PurchaseOrderManageVCTypeStockSampleAdjustment ||
       self.controllerType == PurchaseOrderManageVCTypeStockGoodsAdjustment){
        UIButton *goodsStockBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, optButtonStartTop, (SCREEN_WIDTH - leftMargin * 2 - btnSpace), btnHeight)];
        [goodsStockBtn setTitle:@"开始调库" forState:(UIControlStateNormal)];
        goodsStockBtn.backgroundColor = AppTitleBlueColor;
        goodsStockBtn.layer.cornerRadius = 20;
        [goodsStockBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:goodsStockBtn];
        
    } else {
        UIButton *goodsStockBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, optButtonStartTop, (SCREEN_WIDTH - leftMargin * 2 - btnSpace)/2, btnHeight)];
        [goodsStockBtn setTitle:@"打印" forState:(UIControlStateNormal)];
        goodsStockBtn.backgroundColor = AppTitleBlueColor;
        goodsStockBtn.layer.cornerRadius = 20;
        [goodsStockBtn addTarget:self action:@selector(printAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:goodsStockBtn];
        
        
        UIButton *sampleStockBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + btnSpace/2, optButtonStartTop, (SCREEN_WIDTH - leftMargin * 2 - btnSpace)/2, btnHeight)];
        [sampleStockBtn setTitle:@"开始盘库" forState:(UIControlStateNormal)];
        sampleStockBtn.backgroundColor = AppTitleBlueColor;
        sampleStockBtn.layer.cornerRadius = 20;
        [sampleStockBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:sampleStockBtn];
    }
    
    
    
}
-(void) returnAction{
    StoreStockVC *sellGoodsScanVC = [[StoreStockVC alloc] init];
    sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
    
    sellGoodsScanVC.controllerType = self.controllerType;
    
    [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
}
-(void)printAction{
    
}
- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_inventory_haveCallInventory]||
                [operation.urlTag isEqualToString:Path_inventory_haveInventoryCheckChoice]) {
                if(parserObject.datas[@"info"]){
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否继续上次的盘点" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                    [alert show];
                }
//                XwInOrOutWaterModel *listModel = [XwInOrOutWaterModel mj_objectWithKeyValues:parserObject.datas];
//                if (listModel.orderList.count) {
//                    self.isShowEmptyData = NO;
//                    if (weakSelf.pageNumber == 1) {
//                        [weakSelf.dataList removeAllObjects];
//                    }
//                    [weakSelf.dataList addObjectsFromArray:listModel.orderList];
//                    [weakSelf.tableview reloadData];
//                }
//                else
//                {
//                    if (weakSelf.pageNumber == 1) {
////                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
//                        [weakSelf.dataList removeAllObjects];
//                        [weakSelf.tableview reloadData];
//                        self.isShowEmptyData = YES;
//                    }
//                    else
//                    {
//                        weakSelf.pageNumber -= 1;
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
//                    }
//                    [weakSelf.tableview hidenRefreshFooter];
//                }
            }
//            if ([operation.urlTag isEqualToString:Path_load]) {
//                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
//                for (CommonCategoryModel *itemModel in model.enums) {
//                    if ([itemModel.className isEqualToString:@"TimeQuantum"]) {
//                        [self.selectDataArr removeAllObjects];
//
//                        for (CommonCategoryDataModel *model in itemModel.datas) {
//                            KWOSSVDataModel *itemModel = [[KWOSSVDataModel alloc] init];
//                            if ([model.ID isEqualToString:@"ALL"]) {
//                                itemModel.isSelected = YES;
//                            }
//                            itemModel.title = model.des;
//                            itemModel.itemId = model.ID;
//                            [self.selectDataArr addObject:itemModel];
//                        }
//                    }
//                }
//            }
        }
    }
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
//        [self httpPath_addPersonal];
        [self returnAction];
    }
}
/**订单列表Api*/
- (void)httpPath_orderList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods||
        self.controllerType == PurchaseOrderManageVCTypeStockGoodsAdjustment) {
        [parameters setValue:@"product" forKey:@"goodsType"];
    }
    else
    {
        [parameters setValue:@"sample" forKey:@"goodsType"];
    }
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockGoodsAdjustment||
       self.controllerType == PurchaseOrderManageVCTypeStockSampleAdjustment){
        self.requestURL = Path_inventory_haveCallInventory;
    } else {
        self.requestURL = Path_inventory_haveInventoryCheckChoice;
    }
    
    
    
}
@end
