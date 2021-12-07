//
//  GoodsManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsManageVC.h"
#import "CommonSearchView.h"
#import "CommonTypeSelectedView.h"
#import "CommonSingleGoodsTCell.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailVC.h"
#import "CommonTypeModel.h"
#import "SegmentHeaderView.h"
#import "SegmentTypeModel.h"
#import "KWTypeConditionSelectView.h"

@interface GoodsManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource, SegmentHeaderViewDelegate>


@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) SegmentHeaderView *typeSegmentView;

@property (nonatomic, strong) KWTypeConditionSelectView *conditionSelectView;

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

@implementation GoodsManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"wjjj");
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"goods_list", nil);
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
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
    CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
    [cell showDataWithGoodsDetailModel:self.dataList[indexPath.section] WithCellType:CommonSingleGoodsTCellTypeGoodsList];
    return cell;
    
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
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailModel *model = self.dataList[indexPath.section];
    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.productID = model.ID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
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
            if ([operation.urlTag isEqualToString:Path_getProductList]) {
                GoodsListModel *listModel = (GoodsListModel *)parserObject;
                if (listModel.productListDetailData.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.productListDetailData];
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [self.dataList removeAllObjects];
                        [self.tableview reloadData];
                        if (self.skuCode.length) {
                            self.noDataDes = @"未搜索到相关商品";
                        }
                        else
                        {
                            self.noDataDes = @"暂无商品信息";
                        }
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        self.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [self.tableview hidenRefreshFooter];
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
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    if (self.skuCode.length) {
        [parameters setValue:self.skuCode forKey:@"sku"];
    }
    if (self.mealTypeID != -1) {
        [parameters setValue:@(self.mealTypeID) forKey:@"firstCategoryId"];
    }

    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_getProductList;
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


@end
