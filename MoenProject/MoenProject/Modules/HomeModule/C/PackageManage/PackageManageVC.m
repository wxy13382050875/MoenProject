//
//  PackageManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageManageVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsTCell.h"
#import "OrderPromotionTCell.h"
#import "PackageDetailModel.h"
#import "PackageDetailVC.h"
#import "CommonTVDataModel.h"
#import "CommonTypeModel.h"
#import "SegmentHeaderView.h"
#import "SegmentTypeModel.h"
#import "KWTypeConditionSelectView.h"

@interface PackageManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource, SegmentHeaderViewDelegate>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) SegmentHeaderView *typeSegmentView;

@property (nonatomic, strong) KWTypeConditionSelectView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSMutableArray *typeList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

/**套餐类型*/
@property (nonatomic, assign) NSInteger mealTypeID;
/**商品SKU*/
@property (nonatomic, copy) NSString *skuCode;
@end

@implementation PackageManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"package_list", nil);
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    self.skuCode = @"";
    self.mealTypeID = -1;
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_getComboList];
    [self httpPath_getComboTypes];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_getComboList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_getComboList];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_getComboTypes];
    [weakSelf httpPath_getComboList];
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
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell]) {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithPackageDetailModel:self.dataList[indexPath.section] WithCellType:CommonSingleGoodsTCellTypePackageList];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPromotionTCell" forIndexPath:indexPath];
        PackageDetailModel *model = self.dataList[indexPath.section];
        [cell showDataWithPromotionInfoModel:model.list[indexPath.row - 1]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
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
    PackageDetailModel *model = self.dataList[indexPath.section];
    PackageDetailVC *packageDetailVC = [[PackageDetailVC alloc] init];
    packageDetailVC.packageID = model.comId;
    packageDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:packageDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.skuCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_getComboList];
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
        [self httpPath_getComboList];
    }
}

- (void)showConditionSelectView
{
    WEAKSELF
    [self.conditionSelectView showWithArray:self.typeList WithActionBlock:^(NSInteger typeID, NSInteger atIndex) {
        weakSelf.mealTypeID = typeID;
        [[NSToastManager manager] showprogress];
        [weakSelf httpPath_getComboList];
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
        if ([operation.urlTag isEqualToString:Path_getComboList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getComboList]) {
                PackageListModel *listModel = (PackageListModel *)parserObject;
                if (listModel.listData.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                        [self.floorsAarr removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.listData];
                    [self handleTableViewFloorsData:listModel.listData];
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [self.dataList removeAllObjects];
                        [self.floorsAarr removeAllObjects];
                        [self.tableview reloadData];
                        self.isShowEmptyData = YES;
                        if (self.skuCode.length) {
                             self.noDataDes = @"未搜索到相关套餐";
                        }
                        else
                        {
                             self.noDataDes = @"暂无套餐信息";
                        }
                    }
                    else
                    {
                        self.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [self.tableview hidenRefreshFooter];
                }
            }
            if ([operation.urlTag isEqualToString:Path_getComboTypes]) {
                CommonTypeListModel *listModel = (CommonTypeListModel *)parserObject;
                [self.typeList removeAllObjects];
                
                
                for (CommonTypeModel *itemModel in listModel.MealMainData)
                {
                    SegmentTypeModel *item = [[SegmentTypeModel alloc] init];
                    item.ID = itemModel.ID;
                    item.name = itemModel.name;
                    if (itemModel.ID == 0) {
                        item.isSelected = YES;
                    }
                    [self.typeList addObject:item];
                }
                [self.view addSubview:self.typeSegmentView];
            }
            
        }
    }
}


- (void)handleTableViewFloorsData:(NSArray<PackageDetailModel *> *)data
{
    for (PackageDetailModel *model in data) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        [sectionArr addObject:cellModel];
        for (PromotionInfoModel *infoModel in model.list) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KOrderPromotionTCell;
            cellModel.cellHeight = KOrderPromotionTCellH;
            [sectionArr addObject:cellModel];
        }
        
        [self.floorsAarr addObject:sectionArr];
        
    }
}

/**套餐列表Api*/
- (void)httpPath_getComboList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    if (self.skuCode.length) {
        [parameters setValue:self.skuCode forKey:@"skuCode"];
    }
    if (self.mealTypeID != -1) {
        [parameters setValue:@(self.mealTypeID) forKey:@"typeId"];
    }
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_getComboList;
}


/**套餐类型Api*/
- (void)httpPath_getComboTypes
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getComboTypes;
}

#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypePackage;
        
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
        [_tableview registerNib:[UINib nibWithNibName:KCommonSingleGoodsTCell bundle:nil] forCellReuseIdentifier:KCommonSingleGoodsTCell];
        [_tableview registerNib:[UINib nibWithNibName:KOrderPromotionTCell bundle:nil] forCellReuseIdentifier:KOrderPromotionTCell];
        
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无套餐信息";
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

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

- (NSMutableArray *)typeList
{
    if (!_typeList) {
        _typeList = [[NSMutableArray alloc] init];
    }
    return _typeList;
}

- (KWTypeConditionSelectView *)conditionSelectView
{
    if (!_conditionSelectView) {
        _conditionSelectView = [[KWTypeConditionSelectView alloc] initWithMarginTop:SCREEN_NavTop_Height + 103];
    }
    return _conditionSelectView;
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
