//
//  SearchGoodsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/14.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SearchGoodsVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderPromotionTCell.h"
#import "CommonGoodsModel.h"
#import "YFMPaymentView.h"
#import "STPopup.h"
#import "PurchaseCounterVC.h"

@interface SearchGoodsVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, copy) NSString *inputStr;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL isScanEnter;

@property (nonatomic, strong) UIView *shoppingCarView;

@property (nonatomic, strong) UIButton *shoppingCarBtn;

@property (nonatomic, strong) UILabel *shoppingCarNumberLab;

@property (nonatomic, strong) UIButton *shoppingCarConfirmBtn;

@property (nonatomic, strong) NSMutableArray *shoppingCarDataList;

@property (nonatomic, strong) NSMutableArray *shoppingCarfloorsAarr;


@end

@implementation SearchGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateShoppingCarStatus];
}


- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
    
    if (self.controllerType == SearchGoodsVCTypePackage) {
        self.title = @"查找套餐";
    }
    else
    {
        self.title = @"查找商品/套餐";
        [self.view addSubview:self.shoppingCarView];
    }
}

- (void)configBaseData
{
    
    [self configPagingData];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        if (self.controllerType == SearchGoodsVCTypePackage) {
            //对应接口
            [weakSelf httpPath_selectPromoComboWithSKUCode:weakSelf.inputStr];
        }
        else
        {
            //对应接口
            [weakSelf httpPath_selectProductWithSKUCode:weakSelf.inputStr];
        }
        
        
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        if (self.controllerType == SearchGoodsVCTypePackage) {
            //对应接口
            [weakSelf httpPath_selectPromoComboWithSKUCode:weakSelf.inputStr];
        }
        else
        {
            //对应接口
            [weakSelf httpPath_selectProductWithSKUCode:weakSelf.inputStr];
        }
    }];
    if (!self.isScanEnter) {
        [self.tableview hidenRefreshHearder];
        [self.tableview hidenRefreshFooter];
    }
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    if (self.controllerType == SearchGoodsVCTypePackage) {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_selectPromoComboWithSKUCode:self.inputStr];
    }
    else
    {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_selectProductWithSKUCode:self.inputStr];
    }
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
    if (section == (self.floorsAarr.count - 1))
    {
        return 100;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell]) {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModel:self.dataList[indexPath.section] AtIndex:indexPath.section WihtControllerType:self.controllerType];
        cell.goodsSelectedBlock = ^(CommonGoodsModel *model) {
//            if ([weakSelf.delegate respondsToSelector:@selector(SearchGoodsVCSelectedDelegate:)]) {
//                model.isShowDetail = NO;
//                [weakSelf.delegate SearchGoodsVCSelectedDelegate:model];
//            }
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            model.isShowDetail = NO;
            [weakSelf handleGoodsNumberWithGoodsModel:model];
            
        };
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell])
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPromotionTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForSearch:self.dataList[indexPath.section]];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonGoodsModel *goodsModel = self.dataList[indexPath.section];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForCommonSearch:goodsModel.productList[indexPath.row - 2]];
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
//    CommonGoodsModel *model = self.dataList[indexPath.section];
//    model.isShowDetail = NO;
//    if ([self.delegate respondsToSelector:@selector(SearchGoodsVCSelectedDelegate:)]) {
//        [self.delegate SearchGoodsVCSelectedDelegate:model];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    
//    StoreActivityDetailVC *storeActivityDetailVC = [[StoreActivityDetailVC alloc] init];
//    storeActivityDetailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:storeActivityDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.inputStr = keyStr;
    if (keyStr.length) {
        [self.tableview showRefreshHearder];
        [self.tableview showRefreshFooter];
    }
    else
    {
        [self.tableview hidenRefreshHearder];
        [self.tableview hidenRefreshFooter];
    }
    if (self.controllerType == SearchGoodsVCTypePackage) {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_selectPromoComboWithSKUCode:keyStr];
    }
    else
    {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_selectProductWithSKUCode:keyStr];
    }
}




#pragma mark -- private 私有方法

#pragma mark -- 新增购物车
- (void)handleGoodsNumberWithGoodsModel:(CommonGoodsModel *)goodsModel
{
    //是否是新的商品 如果是新的商品就要新增cell模型
    CommonGoodsModel *copyModel = [goodsModel copy];
    copyModel.isShowDetail = NO;
    BOOL isNewGoods = YES;
    for (CommonGoodsModel *singleModel in self.shoppingCarDataList) {
        if ([singleModel.id isEqualToString:copyModel.id]) {
            if (singleModel.isSpecial) {
//                卖货柜台多次扫描相同淋浴房时，初始化到最小销售单位，不加数量与平方
                singleModel.kGoodsArea = [copyModel.minNum floatValue];
            }
            else
            {
                singleModel.kGoodsCount += 1;
                if (singleModel.kGoodsCount > 999) {
                    singleModel.kGoodsCount = 999;
                }
            }
            isNewGoods = NO;
            [self updateShoppingCarStatus];
            break;
        }
    }
    if (isNewGoods) {
        if (copyModel.isSpecial) {
            copyModel.kGoodsArea = [copyModel.minNum floatValue];
            copyModel.kGoodsCount = 1;
        }
        else
        {
            copyModel.kGoodsCount = 1;
        }
        
        [self.shoppingCarDataList addObject:copyModel];
        [self handleTableViewFloorsDataCommonGoodsModel:copyModel];
        [self updateShoppingCarStatus];
    }
}


#pragma mark -- 更新购物车状态
- (void)updateShoppingCarStatus
{
    if (self.shoppingCarDataList.count) {
        NSInteger goodsCount = 0;
        for (CommonGoodsModel *singleModel in self.shoppingCarDataList) {
            goodsCount += singleModel.kGoodsCount;
        }
        self.shoppingCarNumberLab.hidden = NO;
//        self.shoppingCarNumberLab.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
        if (goodsCount > 99) {
            self.shoppingCarNumberLab.text = @"99+";
            self.shoppingCarNumberLab.sd_width = 30;
        }
        else
        {
            self.shoppingCarNumberLab.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
            self.shoppingCarNumberLab.sd_width = 18;
        }
        [self.shoppingCarConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setBackgroundColor:AppBtnDeepBlueColor];
        [self.shoppingCarConfirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
    }
    else
    {
        self.shoppingCarNumberLab.hidden = YES;
        self.shoppingCarNumberLab.text = [NSString stringWithFormat:@"%d",0];
        [self.shoppingCarConfirmBtn setTitle:@"未选择商品" forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setBackgroundColor:AppBgShoppingCarColor];
    }
}

#pragma mark -- 点击底部购物车按钮 展示购物车详情
- (void)showShoppingCarAction:(UIButton *)sender
{
    WEAKSELF
    if (!self.shoppingCarDataList.count) {
//        [[NSToastManager manager] showtoast:@"购物车为空"];
        return;
    }
    YFMPaymentView *pop = [[YFMPaymentView alloc]initDataSource:self.shoppingCarDataList FloorArr:self.shoppingCarfloorsAarr isShowPrice:YES];
    pop.dateChangeActionBlock = ^() {
        [weakSelf updateShoppingCarStatus];
        if ([weakSelf.delegate respondsToSelector:@selector(SearchGoodsVCSelectedDelegate:)]) {
                   [weakSelf.delegate SearchGoodsVCSelectedDelegate:weakSelf.shoppingCarDataList];
               }
        
    };
    pop.dateConfirmActionBlock = ^() {
        if (weakSelf.shoppingCarDataList.count) {
            if ([weakSelf.delegate respondsToSelector:@selector(SearchGoodsVCSelectedDelegate:)]) {
                [weakSelf.delegate SearchGoodsVCSelectedDelegate:weakSelf.shoppingCarDataList];
            }
             [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    STPopupController *popVericodeController = [[STPopupController alloc] initWithRootViewController:pop];
    popVericodeController.style = STPopupStyleBottomSheet;
    [popVericodeController presentInViewController:self];
}

#pragma mark -- 点击底部购物车按钮 确认购物车
- (void)shoppingCarConfirmAction:(UIButton *)sender
{
    if (self.shoppingCarDataList.count) {
        if ([self.delegate respondsToSelector:@selector(SearchGoodsVCSelectedDelegate:)]) {
            [self.delegate SearchGoodsVCSelectedDelegate:self.shoppingCarDataList];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
 



#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [self.tableview cancelRefreshAction];
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_selectProduct]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_selectProduct] ||
                [operation.urlTag isEqualToString:Path_selectPromoCombo]) {
//                CommonGoodsListModel *listModel = (CommonGoodsListModel *)parserObject;
                CommonGoodsListModel *listModel = [CommonGoodsListModel mj_objectWithKeyValues:parserObject];
                if ([listModel.code isEqualToString:@"200"]) {
                    if (listModel.selectProducts.count) {
                        self.isShowEmptyData = NO;
                        if (self.pageNumber == 1) {
                            [self.dataList removeAllObjects];
                            [self.floorsAarr removeAllObjects];
                        }
                        [self.dataList addObjectsFromArray:listModel.selectProducts];
                        [self handleTableViewFloorsData:listModel.selectProducts];
                        [self.tableview reloadData];
                    }
                    else
                    {
                        if (self.pageNumber == 1) {
                            self.isShowEmptyData = YES;
                            [self.dataList removeAllObjects];
                            [self.floorsAarr removeAllObjects];
                            [self.tableview reloadData];
                        }
                        else
                        {
                            self.pageNumber -= 1;
                            [[NSToastManager manager] showtoast:@"暂无更多数据"];
                        }
                        [self.tableview hidenRefreshFooter];
                    }
                    
                    
                    
//                    if (listModel.selectProducts.count) {
//
//                        self.isShowEmptyData = NO;
//                        [self.dataList removeAllObjects];
//                        [self.floorsAarr removeAllObjects];
//                        [self.dataList addObjectsFromArray:listModel.selectProducts];
//                        [self handleTableViewFloorsData:listModel.selectProducts];
//                        [self.tableview reloadData];
//                    }
//                    else
//                    {
//                        [[NSToastManager manager] showtoast:@"暂无数据"];
//                        [self.dataList removeAllObjects];
//                        [self.floorsAarr removeAllObjects];
//                        [self.tableview reloadData];
//                        self.isShowEmptyData = YES;
//                    }
                }
                else
                {
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                        [self.floorsAarr removeAllObjects];
                        [self.tableview reloadData];
                    }
                    
                    [self.tableview hidenRefreshFooter];
                    [[NSToastManager manager] showtoast:listModel.message];
                }
            }
        }
    }
}

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonGoodsModel *goodsModel = self.dataList[atIndex];
    if (isShow) {
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
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
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)handleTableViewFloorsData:(NSArray<CommonGoodsModel *> *)data
{
    for (CommonGoodsModel *model in data) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        if (!model.isSetMeal) {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.isShow = YES;
            cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
        }
        else
        {
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.isShow = YES;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
        }
        [sectionArr addObject:cellModel];
        
        if (model.isSetMeal) {
            CommonTVDataModel *activityCellModel = [[CommonTVDataModel alloc] init];
            activityCellModel.cellIdentify = KOrderPromotionTCell;
            activityCellModel.cellHeight = KOrderPromotionTCellH;
//            activityCellModel.isShow = YES;
            [sectionArr addObject:activityCellModel];
        }
        
        [self.floorsAarr addObject:sectionArr];
    }
}


- (void)handleTableViewFloorsDataCommonGoodsModel:(CommonGoodsModel *)dataModel
{
    NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
    //当前商品的Cell
    CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
    if (!dataModel.isSetMeal) {
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
    }
    else
    {
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
    }
    [sectionArr addObject:cellModel];
    [self.shoppingCarfloorsAarr addObject:sectionArr];
}

/**查询套餐或商品Api*/
- (void)httpPath_selectProductWithSKUCode:(NSString *)code
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:code forKey:@"code"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_selectProduct;
}


/**查询促销活动中套餐信息Api*/
- (void)httpPath_selectPromoComboWithSKUCode:(NSString *)code
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:code forKey:@"code"];
    [parameters setValue:self.promoId forKey:@"promoId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_selectPromoCombo;
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

#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeGoods;
    }
    return _searchView;
}


- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 124) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
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


- (NSMutableArray *)shoppingCarDataList
{
    if (!_shoppingCarDataList) {
        _shoppingCarDataList = [[NSMutableArray alloc] init];
    }
    return _shoppingCarDataList;
}

- (NSMutableArray *)shoppingCarfloorsAarr
{
    if (!_shoppingCarfloorsAarr) {
        _shoppingCarfloorsAarr = [[NSMutableArray alloc] init];
    }
    return _shoppingCarfloorsAarr;
}



- (UIView *)shoppingCarView
{
    if (!_shoppingCarView) {
        _shoppingCarView = [[UIView alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 160, SCREEN_WIDTH - 30, 50)];
        _shoppingCarView.backgroundColor = AppBgShoppingCarColor;
        _shoppingCarView.clipsToBounds = YES;
        _shoppingCarView.layer.cornerRadius = 25;
        
        UIButton *shoppingCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        [shoppingCarBtn setImage:ImageNamed(@"s_shoppingcar_deep_icon") forState:UIControlStateNormal];
        [shoppingCarBtn addTarget:self action:@selector(showShoppingCarAction:) forControlEvents:UIControlEventTouchDown];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 18, 18)];
        numberLab.text = @"0";
        numberLab.textColor = AppTitleWhiteColor;
        numberLab.font = FONTSYS(12);
        numberLab.hidden = YES;
        numberLab.backgroundColor = AppTitleGoldenColor;
        numberLab.clipsToBounds = YES;
        numberLab.layer.cornerRadius = 9;
        numberLab.textAlignment = NSTextAlignmentCenter;
        self.shoppingCarNumberLab = numberLab;
        [shoppingCarBtn addSubview:numberLab];
        [_shoppingCarView addSubview:shoppingCarBtn];
        
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_shoppingCarView.sd_width - 125, 0, 125, 50)];
        confirmBtn.titleLabel.font = FontBinB(15);
        [confirmBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [confirmBtn setTitle:@"未选择商品" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(shoppingCarConfirmAction:) forControlEvents:UIControlEventTouchDown];
        self.shoppingCarConfirmBtn = confirmBtn;
        [_shoppingCarView addSubview:confirmBtn];
    }
    return _shoppingCarView;
}

- (void)setSearchSKUCode:(NSString *)searchSKUCode
{
    [self configPagingData];
    self.searchView.inputTxtStr = searchSKUCode;
    self.inputStr = searchSKUCode;
    self.isScanEnter = YES;
    [[NSToastManager manager] showprogress];
    [self httpPath_selectProductWithSKUCode:searchSKUCode];
}

//- (void)setDataArr:(NSMutableArray *)dataArr
//{
////    _dataArr = dataArr;
////    [self.dataList removeAllObjects];
////    [self.floorsAarr removeAllObjects];
////    [self.dataList addObjectsFromArray:dataArr];
////    [self handleTableViewFloorsData:dataArr];
////    [self.tableview reloadData];
//}

- (void)setSelectedDataArr:(NSMutableArray *)selectedDataArr
{
    _selectedDataArr = selectedDataArr;
    for (CommonGoodsModel *model in _selectedDataArr) {
        CommonGoodsModel *copyModel = [model copy];
        copyModel.isShowDetail = NO;
        [self.shoppingCarDataList addObject:copyModel];
        [self handleTableViewFloorsDataCommonGoodsModel:copyModel];
    }
}


@end
