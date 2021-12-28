//
//  StockQueryVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StockQueryVC.h"
#import "CommonSearchView.h"
#import "CommonTypeSelectedView.h"
#import "CommonSingleGoodsTCell.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailVC.h"
#import "CommonTypeModel.h"
#import "SegmentHeaderView.h"
#import "SegmentTypeModel.h"
#import "KWTypeConditionSelectView.h"
#import "XwInventoryModel.h"
#import "XwStoreListModel.h"
@interface StockQueryVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource, SegmentHeaderViewDelegate>


@property (nonatomic, strong) CommonSearchView *searchView;

//@property (nonatomic, strong) SegmentHeaderView *typeSegmentView;

//@property (nonatomic, strong) KWTypeConditionSelectView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *typeList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

/**商品类型*/
@property (nonatomic, assign) NSInteger mealTypeID;
/**商品SKU*/
@property (nonatomic, copy) NSString *skuCode;

@end

@implementation StockQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"库存查询";
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    self.skuCode = @"";
    self.mealTypeID = -1;
    
    [self configPagingData];
//    [[NSToastManager manager] showprogress];
//    [self httpPath_getProductList];
//    [self httpPath_getProductCategory];
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
//    [weakSelf httpPath_getProductCategory];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Storelist* model = self.dataList[section];
    return model.inventoryList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
//    [cell showDataWithGoodsDetailModel:self.dataList[indexPath.section][indexPath.row] WithCellType:CommonSingleGoodsTCellTypeGoodsList];
    Storelist* model = self.dataList[indexPath.section];
    cell.inventoryModel = model.inventoryList[indexPath.row];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Storelist* model = self.dataList[section];
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 30)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.storeName;
    [headerView addSubview:timeLab];
    
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
//    Inventorylist *model = self.dataList[indexPath.section][indexPath.row];
//    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
//    goodsDetailVC.productID = model.goodsID;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.skuCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_getProductList];
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
            if ([operation.urlTag isEqualToString:Path_inventory_inventorySearch]) {
                XwStoreListModel *listModel = [XwStoreListModel mj_objectWithKeyValues:parserObject.datas];
                if (listModel.storeList.count) {
                    self.isShowEmptyData = NO;
//                    if (weakSelf.pageNumber == 1) {
//                        [weakSelf.dataList removeAllObjects];
//                    }
//                    [weakSelf.dataList addObjectsFromArray:listModel.inventoryList];
                    weakSelf.dataList = [listModel.storeList copy];
                    [weakSelf.tableview reloadData];
                }
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
//                if (self.typeList.count) {
//                    [self.view addSubview:self.typeSegmentView];
//                }
            }
        }
    }
}

/**门店商品列表Api*/
- (void)httpPath_getProductList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
//    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
    [parameters setValue:self.skuCode forKey:@"goodsID"];

    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_inventory_inventorySearch;
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



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, SCREEN_HEIGHT - 120) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无商品信息";
        
    }
    return _tableview;
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


@end
