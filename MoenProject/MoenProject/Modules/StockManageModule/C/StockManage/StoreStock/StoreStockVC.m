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


@end

@implementation StoreStockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
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
    } else {
        self.title = @"盘库";
        [self.view addSubview:self.saveBth];
        [self.view addSubview:self.submitBtn];
        self.saveBth.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);
        self.submitBtn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40).widthIs(SCREEN_WIDTH/2);

        
    }
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"调整库存" style:UIBarButtonItemStylePlain target:self action:@selector(goChangeStockVC:)];
    [rightBarButton setTintColor: [UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)configBaseData
{
    self.skuCode = @"";
    self.mealTypeID = -1;
    
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

- (void)goChangeStockVC:(UIBarButtonItem *)sender {
    StockQueryVC *stockQueryVC = [[StockQueryVC alloc] init];
    stockQueryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:stockQueryVC animated:YES];
}


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
    return 115;
    
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
    
    
    if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockGoods||
             self.controllerType == PurchaseOrderManageVCTypeStocktakingStockSample)
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
            if (
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
            
            
            if (
                [operation.urlTag isEqualToString:Path_inventory_inventoryCheckChoice]
                ) {
                    XwLastGoodsListModel *listModel = [XwLastGoodsListModel mj_objectWithKeyValues:parserObject.datas];
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
            }
            if ([operation.urlTag isEqualToString:Path_getProductCategory]) {
                CommonTypeListModel *listModel = (CommonTypeListModel *)parserObject;
                [self.typeList removeAllObjects];
                for (CommonTypeModel *itemModel in listModel.listData)
                {
                    SegmentTypeModel *item = [[SegmentTypeModel alloc] init];
                    item.ID = itemModel.ID;
                    item.name = itemModel.name;
                    if (itemModel.ID == 0) {
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
    if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockGoods) {
        [parameters setValue:@"product" forKey:@"inventorySortType"];
    }
    else if (self.controllerType == PurchaseOrderManageVCTypeInventoryStockSample)
    {
        [parameters setValue:@"sample" forKey:@"inventorySortType"];
    } else if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockGoods){
        [parameters setValue:@"product" forKey:@"goodsType"];
        
    } else if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockSample){
        [parameters setValue:@"sample" forKey:@"goodsType"];
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
    else if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockGoods||
             self.controllerType == PurchaseOrderManageVCTypeStocktakingStockSample)
    {
        self.requestURL = Path_inventory_inventoryCheckChoice;
    }
    
    
}

/**盘库操作（保存或确认）Api*/
- (void)httpPath_Path_inventory_inventoryCheckOperate:(NSString*)type
{
    self.operateType = type;
    NSMutableArray* array = [NSMutableArray array];
    for(Lastgoodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCount isEqualToString:@""]){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCount forKey:@"goodsCount"];
            [dict setObject:model.reason forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
        [parameters setValue:self.operateType forKey:@"operateType"];
        if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockGoods){
            [parameters setValue:@"product" forKey:@"goodsType"];
            
        } else if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockSample){
            [parameters setValue:@"sample" forKey:@"goodsType"];
        }
        [parameters setValue:array forKey:@"goodsList"];
        self.requestType = NO;
        self.requestParams = parameters;
        self.requestURL = Path_inventory_inventoryCheckOperate;
    } else {
        [[NSToastManager manager] showtoast:@"请输入库存数"];
    }
    
}

/**获取商品品类Api*/
- (void)httpPath_getProductCategory
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getProductCategory;
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
            [self httpPath_Path_inventory_inventoryCheckOperate:@"save"];
        }];
    }
    return  _saveBth;
}
-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"盘库确认" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"盘库确认");
            [self httpPath_Path_inventory_inventoryCheckOperate:@"confirm"];
        }];
    }
    return  _submitBtn;
}
@end
