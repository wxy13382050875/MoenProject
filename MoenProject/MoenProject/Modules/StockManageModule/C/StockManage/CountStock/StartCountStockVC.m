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
#import "XwLastGoodsListModel.h"
#import "CommonGoodsModel.h"
@interface StartCountStockVC()
@property(nonatomic,strong)NSString* inventoryNo;
@property(nonatomic,assign)BOOL isContinueLast;
@property(nonatomic,strong)NSMutableArray* selectedDataArr;
@end

@implementation StartCountStockVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){
        self.title = @"开始调库";
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
    
    NSString* name = @"";
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){
        name = @"调库";
    } else {
        name = @"盘库";
    }
    
    CGSize tipSize = [@"冻结后，不允许门店做出入库操作。" sizeWithFont:FontBinB(14) constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    int labelLeftMargin = (SCREEN_WIDTH - tipSize.width) / 2;
    int labelHeight = 120;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftMargin, tipLabelStartTop, SCREEN_WIDTH - leftMargin * 2, labelHeight)];
    tipLabel.font = FontBinB(14);
    tipLabel.textColor = AppTitleBlackColor;
    tipLabel.text = [NSString stringWithFormat:@"是否要开始本次%@？\n\n开始%@后，将冻结门店库存。\n\n冻结后，不允许门店做出入库操作。",name,name];
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLabel];
    
    
    UILabel *optNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, optLabelStartTop, SCREEN_WIDTH - 60 * 2, 20)];
    optNameLabel.font = FontBinR(14);
    optNameLabel.textColor = AppTitleBlackColor;
    optNameLabel.text = [NSString stringWithFormat:@"操作人：%@(%@)",[QZLUserConfig sharedInstance].dealerName,[[QZLUserConfig sharedInstance].userRole isEqualToString: @"SHOP_LEADER"] ? @"店长":@"导购"];
    optNameLabel.numberOfLines = 0;
    optNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:optNameLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
    
    UILabel *optTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, optLabelStartTop + 20, SCREEN_WIDTH - 60 * 2, 20)];
    optTimeLabel.font = FontBinR(14);
    optTimeLabel.textColor = AppTitleBlackColor;
    optTimeLabel.text = [NSString stringWithFormat:@"操作时间：%@",dateStr];
    optTimeLabel.numberOfLines = 0;
    optTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:optTimeLabel];
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){
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
    
    
    
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){//开始调库
        if(self.isContinueLast){
            [self httpPath_inventory_callInventoryProducts];
        } else {
            [self skipStockSearchGoodsVC];
        }
        
    } else {//开始盘库
        StoreStockVC *sellGoodsScanVC = [[StoreStockVC alloc] init];
        sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
        
        sellGoodsScanVC.controllerType = self.controllerType;
        sellGoodsScanVC.goodsType = self.goodsType;
        [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
    }
    
    
    
    
}
-(void)printAction{
    
}
- (void)configBaseData
{
    self.inventoryNo = @"";
    self.isContinueLast = NO;
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    
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
                if([parserObject.code integerValue]== 200){
                    BOOL isShow = [parserObject.datas[@"info"] boolValue];
                    if(isShow){
                        
                        FDAlertView * alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否继续上次的盘点" block:^(NSInteger buttonIndex, NSString *inputStr) {
                            if(buttonIndex == 1){
                                self.isContinueLast = YES;
                                [self returnAction];
                            } else {
                                self.isContinueLast = NO;
//                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
                        [alert show];
                    }
                } else {
                    NSLog(@"parserObject.code");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                

            } else if([operation.urlTag isEqualToString:Path_inventory_callInventoryProducts]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.inventoryNo = parserObject.datas[@"inventoryNo"];
                    XwLastGoodsListModel *listModel = [XwLastGoodsListModel mj_objectWithKeyValues:parserObject.datas];
                    self.inventoryNo = listModel.inventoryNo;
                    for (Lastgoodslist* tm in listModel.LastGoodsList) {
                        CommonGoodsModel* coModel = [CommonGoodsModel new];
                        coModel.id = tm.goodsID;
                        coModel.isShowDetail = NO;
//                        coModel.isSetMeal = tm.goodsPackage!=nil?true:false;
                        coModel.code = [tm.goodsSKU mutableCopy];
//                        coModel.price = [tm.goodsPrice mutableCopy];
                        coModel.name = [tm.goodsName mutableCopy];
                        coModel.photo = [tm.goodsIMG mutableCopy];
                        coModel.kGoodsCount = 1;
//                        if(tm.isSetMeal){
//                            NSMutableArray* productList =[NSMutableArray new];
//                            for (Goodslist* packs  in tm.productList) {
//                                CommonProdutcModel* prModel = [CommonProdutcModel new];
//                                prModel.sku = [packs.goodsSKU mutableCopy];
//                                prModel.price = [packs.goodsPrice mutableCopy];
//                                prModel.count = [packs.goodsCount integerValue];
//                                prModel.photo = [packs.goodsIMG mutableCopy];
//                                prModel.name = [packs.goodsName mutableCopy];
//                                [productList addObject:prModel];
//                            }
//                            coModel.productList = productList;
//                        }
                        
                        [self.selectedDataArr addObject:coModel];
                    }
                    
                    [self skipStockSearchGoodsVC];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }

        }
    }
}
-(void)skipStockSearchGoodsVC{
    StockSearchGoodsVC *sellGoodsScanVC = [[StockSearchGoodsVC alloc] init];
    sellGoodsScanVC.goodsType = self.goodsType;
    sellGoodsScanVC.controllerType = SearchGoodsVCType_StockAdjust;
    sellGoodsScanVC.inventoryNo = self.inventoryNo;
    sellGoodsScanVC.selectedDataArr = self.selectedDataArr;
    sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
}
/**订单列表Api*/
- (void)httpPath_orderList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:self.goodsType forKey:@"goodsType"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){
        self.requestURL = Path_inventory_haveCallInventory;
    } else {
        self.requestURL = Path_inventory_haveInventoryCheckChoice;
    }
    
}
-(void)httpPath_inventory_callInventoryProducts{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:self.goodsType forKey:@"goodsType"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_inventory_callInventoryProducts;
}
-(NSMutableArray*)selectedDataArr{
    if(!_selectedDataArr){
        _selectedDataArr = [NSMutableArray array];
    }
    return _selectedDataArr;
}
@end
