//
//  StoreStockVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreStockVC.h"
#import "CommonSearchView.h"
#import "CommonTypeSelectedView.h"
#import "CommonSingleGoodsTCell.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailVC.h"
#import "CommonTypeModel.h"
#import "SegmentHeaderView.h"
#import "SegmentTypeModel.h"
#import "KWTypeConditionSelectView.h"
#import "StockQueryVC.h"
#import "ChangeStockTCell.h"

#import "XwInventoryModel.h"
#import "XwLastGoodsListModel.h"

#import "StockOperationSuccessVC.h"
#import "StartCountStockVC.h"
//#import "ChangeStockAdjustVC.h"
#import "StockManageChildVC.h"
@interface StoreStockVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource, SegmentHeaderViewDelegate>


@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) SegmentHeaderView *typeSegmentView;

@property (nonatomic, strong) KWTypeConditionSelectView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *typeList;

@property (nonatomic, strong) UIButton* saveBth;

@property (nonatomic, strong) UIButton* submitBtn;
/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

/**商品类型*/
@property (nonatomic, assign) NSInteger mealTypeID;
/**商品SKU*/
@property (nonatomic, copy) NSString *skuCode;

@property (nonatomic, copy) NSString *operateType;
//调库单编号
@property (nonatomic, copy) NSString *inventoryNo;

@end

@implementation StoreStockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}
-(void)backBthOperate{
    NSLog(@"返回");
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    BOOL isStock = NO;
    UIViewController* stVC;
    for (UIViewController* vc in marr) {
        if ([vc isKindOfClass:[StockManageChildVC class]]) {
//            [marr removeObject:vc];
            isStock = YES;
            stVC = vc;
        }
    }
    if (isStock) {
        
        [self.navigationController popToViewController:stVC animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
    
    
    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods) {
        self.title = @"门店库存";
    }
    else if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample)
    {
        self.title = @"样品库存";
    } else if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust)
    {
        self.title = @"调库";
        [self.view addSubview:self.submitBtn];
        self.submitBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    } else  if (self.controllerType == PurchaseOrderManageVCTypeStockDaily){
        self.title = @"盘库";
        [self.view addSubview:self.saveBth];
        [self.view addSubview:self.submitBtn];
        self.saveBth.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
        self.submitBtn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);

        
    }
//    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods||
//        self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample){
//        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"调整库存" style:UIBarButtonItemStylePlain target:self action:@selector(goChangeStockVC:)];
//        [rightBarButton setTintColor: [UIColor whiteColor]];
//        self.navigationItem.rightBarButtonItem = rightBarButton;
//    }
    
}

- (void)configBaseData
{
    self.skuCode = @"";
    self.mealTypeID = 0;
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_getProductList];
    [self httpPath_getProductCategory];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_getProductList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_getProductList];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_getProductList];
    [weakSelf httpPath_getProductCategory];
}

//- (void)goChangeStockVC:(UIBarButtonItem *)sender {
////    StockQueryVC *stockQueryVC = [[StockQueryVC alloc] init];
////    stockQueryVC.hidesBottomBarWhenPushed = YES;
////
////    [self.navigationController pushViewController:stockQueryVC animated:YES];
//    StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
//    startCountStockVC.hidesBottomBarWhenPushed = YES;
//
//
//    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods) {
//        startCountStockVC.controllerType = PurchaseOrderManageVCTypeStockGoodsAdjustment;
//    }
//    else if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample)
//    {
//        startCountStockVC.controllerType = PurchaseOrderManageVCTypeStockSampleAdjustment;
//    }
//
//    [self.navigationController pushViewController:startCountStockVC animated:YES];
//}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.controllerType == PurchaseOrderManageVCTypeStockDaily||
             self.controllerType == PurchaseOrderManageVCTypeStockAdjust)
    {
        return 155;
    } else {
        return 115;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeStockTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeStockTCell" forIndexPath:indexPath];
//    [cell showDataWithGoodsDetailModel:self.dataList[indexPath.section]];
    
    if (self.controllerType == PurchaseOrderManageVCTypeStockDaily||
             self.controllerType == PurchaseOrderManageVCTypeStockAdjust)
    {
        cell.lastModel =self.dataList[indexPath.section];
    } else {
        cell.model =self.dataList[indexPath.section];
    }
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
//    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    timeLab.font = FontBinB(14);
//    timeLab.textColor = AppTitleBlackColor;
//    timeLab.text = @"本店库存";
//    [headerView addSubview:timeLab];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodsDetailModel *model = self.dataList[indexPath.section];
//    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
//    goodsDetailVC.productID = model.ID;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.skuCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_getProductList];
}

#pragma mark -- SegmentHeaderViewDelegate

- (void)SegmentHeaderViewSelectedBlock:(NSInteger)typeID
{
    if (typeID == -2) {
        [self showConditionSelectView];
    }
    else
    {
        self.mealTypeID = typeID;
        
        [[NSToastManager manager] showprogress];
        [self httpPath_getProductList];
    }
}

- (void)showConditionSelectView
{
    WEAKSELF
    [self.conditionSelectView showWithArray:self.typeList WithActionBlock:^(NSInteger typeID, NSInteger atIndex) {
        
        weakSelf.mealTypeID = typeID;
        [[NSToastManager manager] showprogress];
        [weakSelf httpPath_getProductList];
        [weakSelf.typeSegmentView changeItemWithTargetIndex:atIndex];
        //        if (type == 1) {
        //            [weakSelf handleRequestDataWith:model];
        //        }
        //        [weakSelf.screenSegmentView defaultAction];
        
    } WithCancelBlock:^{
        [weakSelf.typeSegmentView setDefaultStatus];
    }];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getProductList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_inventory_storeInventory]
                ) {
                XwInventoryModel *listModel = [XwInventoryModel mj_objectWithKeyValues:parserObject.datas];
                self.inventoryNo = listModel.inventoryNo;
                if (listModel.inventoryList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.inventoryList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            }
            else if (
                [operation.urlTag isEqualToString:Path_inventory_inventoryCheckOperate]
                ) {
                    if ([parserObject.code isEqualToString:@"200"]) {
                        
                        StockOperationSuccessVC *orderOperationSuccessVC = [[StockOperationSuccessVC alloc] init];
                        NSMutableDictionary* dict = [parserObject.datas[@"datas"] mutableCopy];
                        [dict setValue:self.operateType forKey:@"operateType"];
                        
                        orderOperationSuccessVC.dict = [dict copy];
                        orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                    }
                    else
                    {
                        self.isShowEmptyData = YES;
                        [[NSToastManager manager] showtoast:parserObject.message];
                    }
                }
            
            
            else if ([operation.urlTag isEqualToString:Path_inventory_inventoryCheckChoice]||
                     [operation.urlTag isEqualToString:Path_inventory_callInventoryCheckChoice]
                ) {
                    XwLastGoodsListModel *listModel = [XwLastGoodsListModel mj_objectWithKeyValues:parserObject.datas];
                self.inventoryNo = listModel.inventoryNo;
                if (listModel.LastGoodsList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.LastGoodsList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            } else if ([operation.urlTag isEqualToString:Path_inventory_inventorySortByStore]) {
//                CommonTypeListModel *listModel = (CommonTypeListModel *)parserObject;
                CommonTypeListModel *listModel = [CommonTypeListModel mj_objectWithKeyValues:parserObject.datas];
                [self.typeList removeAllObjects];
                for (CommonTypeModel *itemModel in listModel.listData)
                {
                    SegmentTypeModel *item = [[SegmentTypeModel alloc] init];
                    item.ID = [itemModel.id integerValue];
                    item.name = itemModel.name;
                    if (itemModel.id == 0) {
                        item.isSelected = YES;
                    }
                    [self.typeList addObject:item];
                }
                if (self.typeList.count) {
                    [self.view addSubview:self.typeSegmentView];
                }
            }
        }
    }
}

/**门店商品列表Api*/
- (void)httpPath_getProductList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"page"];
    [parameters setValue:@(self.pageSize) forKey:@"size"];
    [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
    
//    库存类型，商品或样品  product/sample
    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods||
        self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample) {
        [parameters setValue:self.goodsType forKey:@"inventorySortType"];
    } else {
        [parameters setValue:self.goodsType forKey:@"goodsType"];
    }
    [parameters setValue:self.skuCode forKey:@"goodsKey"];
    [parameters setValue:@(self.mealTypeID) forKey:@"inventorySortID"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods||
        self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample) {
        self.requestURL = Path_inventory_storeInventory;
    }
    else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)//日常盘库
    {
        self.requestURL = Path_inventory_inventoryCheckChoice;
    } else {
        self.requestURL = Path_inventory_callInventoryCheckChoice;
    }
    
    
}

/**盘库操作（保存或确认）Api*/
- (void)httpPath_Path_inventory_inventoryCheckOperate:(NSString*)type
{
    self.operateType = type;
    NSMutableArray* array = [NSMutableArray array];
    for(Lastgoodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCountAfter isEqualToString:@""]){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCountAfter forKey:@"goodsCount"];
            [dict setObject:model.reason==nil?@"":model.reason forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
        [parameters setValue:self.operateType forKey:@"operateType"];
        [parameters setValue:self.inventoryNo forKey:@"inventoryNo"];
        [parameters setValue:self.goodsType forKey:@"goodsType"];
        [parameters setValue:array forKey:@"goodsList"];
        self.requestType = NO;
        self.requestParams = parameters;
        self.requestURL = Path_inventory_inventoryCheckOperate;
    } else {
        [[NSToastManager manager] showtoast:@"请输入库存数"];
    }
    
}
/**调库单调整（保存或确认）Api*/
- (void)httpPath_inventory_callInventoryOrderOperate
{
    NSMutableArray* array = [NSMutableArray array];
    for(Goodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCount isEqualToString:@""]&&model.goodsCount !=nil){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCount forKey:@"goodsCount"];
            [dict setObject:@"" forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:self.inventoryNo forKey:@"callInventoryOrderID"];
        
        [parameters setValue:array forKey:@"goodsList"];
        self.requestType = NO;
        self.requestParams = parameters;
        self.requestURL = Path_inventory_callInventoryOrderOperate;
    } else {
        [[NSToastManager manager] showtoast:@"请输入库存数"];
    }
    
}
/**获取商品品类Api*/
- (void)httpPath_getProductCategory
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: [QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
    
    self.requestType = NO;
    self.requestParams = parameters;
//    self.requestURL = Path_getProductCategory;
    self.requestURL = Path_inventory_inventorySortByStore;
}

#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeGoodsList;
        
    }
    return _searchView;
}

- (SegmentHeaderView *)typeSegmentView
{
    if (!_typeSegmentView) {
        _typeSegmentView = [[SegmentHeaderView alloc] initWithFrame:CGRectMake(0, 57, SCREEN_WIDTH, 45) titleArray:self.typeList];
        _typeSegmentView.delegate = self;
    }
    return _typeSegmentView;
}



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 168) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ChangeStockTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStockTCell"];
        
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无商品信息";
        
    }
    return _tableview;
}

- (KWTypeConditionSelectView *)conditionSelectView
{
    if (!_conditionSelectView) {
        _conditionSelectView = [[KWTypeConditionSelectView alloc] initWithMarginTop:SCREEN_NavTop_Height + 103];
    }
    return _conditionSelectView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (NSMutableArray *)typeList
{
    if (!_typeList) {
        _typeList = [[NSMutableArray alloc] init];
    }
    return _typeList;
}


#pragma mark -- 刷新重置等设置
- (void)configPagingData
{
    self.pageNumber = 1;
    self.pageSize = 10;
}
- (void)handlePageSize
{
    if (self.pageNumber > 1) {
        self.pageSize = self.pageSize * self.pageNumber;
        self.pageNumber = 1;
    }
}
- (void)handlePageNumber
{
    if (self.pageSize > 10) {
        self.pageNumber = self.pageSize / 10;
        self.pageSize = 10;
    }
}
-(UIButton*)saveBth{
    if(!_saveBth){
        _saveBth = [UIButton buttonWithTitie:@"保存" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnGoldenColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"保存");
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:@"是否保存盘库信息？保存后,下次可继续盘库" block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    [self httpPath_Path_inventory_inventoryCheckOperate:@"save"];
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
            
        }];
    }
    return  _saveBth;
}
-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"盘库确认" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"盘库确认");
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:@"是否提交保存盘库信息？" block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    [self httpPath_Path_inventory_inventoryCheckOperate:@"confirm"];
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
            
            
            
        }];
    }
    return  _submitBtn;
}
@end
