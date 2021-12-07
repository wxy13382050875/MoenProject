//
//  CustomerAccountVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CustomerAccountVC.h"
#import "CustomerAccountListTCell.h"
#import "CouponInfoModel.h"

#import "couponCategoryTCell.h"
#import "CouponStoreTCell.h"
#import "CouponStoreAddressTCell.h"

@interface CustomerAccountVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation CustomerAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"customer_account", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无优惠券";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CustomerAccountListTCell" bundle:nil] forCellReuseIdentifier:@"CustomerAccountListTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"couponCategoryTCell" bundle:nil] forCellReuseIdentifier:@"couponCategoryTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponStoreTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponStoreAddressTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreAddressTCell"];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_couponList];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_couponList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_couponList];
    }];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_couponList];
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
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    if ([model.cellIdentify isEqualToString:KCustomerAccountListTCell]) {
        CustomerAccountListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerAccountListTCell" forIndexPath:indexPath];

        [cell showDataWithCouponInfoModel:self.dataList[indexPath.section] WithIsEdit:NO AtIndex:indexPath.section IsShowRef:NO];
        cell.selectedActionBlock = ^(NSInteger clickType, NSInteger atIndex, BOOL isShowDetail) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShowDetail WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KcouponCategoryTCell])
    {
        couponCategoryTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCategoryTCell" forIndexPath:indexPath];
        CouponInfoModel *goodsModel = self.dataList[indexPath.section];
        [cell showDataWithString:goodsModel.couponCategory];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCouponStoreTCell])
    {
        CouponStoreTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreTCell" forIndexPath:indexPath];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCouponStoreAddressTCell])
    {
        CouponStoreAddressTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreAddressTCell" forIndexPath:indexPath];
        CouponInfoModel *goodsModel = self.dataList[indexPath.section];
        if ([goodsModel.couponType isEqualToString:@"订单优惠"]) {
            ShopInfo *shopModel = goodsModel.shopList[indexPath.row - 2];
            [cell showDataWithString:shopModel.shopName];
        }
        else
        {
            ShopInfo *shopModel = goodsModel.shopList[indexPath.row - 3];
            [cell showDataWithString:shopModel.shopName];
        }
        
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
//#pragma mark -- UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CouponInfoModel *goodsModel = self.dataList[atIndex];
    if (isShow) {
        if ([goodsModel.couponType isEqualToString:@"品类优惠"]) {
            CommonTVDataModel *categorycellModel = [[CommonTVDataModel alloc] init];
            categorycellModel.cellIdentify = KcouponCategoryTCell;
            CGFloat height = [NSTool getHeightWithContent:[NSString stringWithFormat:@"参与活动的品类：%@",goodsModel.couponCategory] width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
            categorycellModel.cellHeight = height + 20;
            [sectionArr addObject:categorycellModel];
        }
        
        CommonTVDataModel *storecellModel = [[CommonTVDataModel alloc] init];
        storecellModel.cellIdentify = KCouponStoreTCell;
        storecellModel.cellHeight = KCouponStoreTCellHeight;
        [sectionArr addObject:storecellModel];
        
        for (ShopInfo *model in goodsModel.shopList) {
            CommonTVDataModel *addresscellModel = [[CommonTVDataModel alloc] init];
            addresscellModel.cellIdentify = KCouponStoreAddressTCell;
            CGFloat height = [NSTool getHeightWithContent:model.shopName width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
            addresscellModel.cellHeight = height + 10;
            [sectionArr addObject:addresscellModel];
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;
        [sectionArr removeObjectsInRange:NSMakeRange(1, sectionArr.count - 1)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}


#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData:(NSArray *)dataArr
{
    for (CouponInfoModel *model in dataArr) {
        //地址
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *CouponInfoCellModel = [[CommonTVDataModel alloc] init];
        CouponInfoCellModel.cellIdentify = KCustomerAccountListTCell;
        CouponInfoCellModel.cellHeight = KCustomerAccountListTCellHeight;
        CouponInfoCellModel.cellHeaderHeight = 0.01;
        CouponInfoCellModel.cellFooterHeight = 5;
        [sectionArr addObject:CouponInfoCellModel];
        [self.floorsAarr addObject:sectionArr];
    }
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_couponList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_couponList]) {
                
                CouponListModel *listModel = (CouponListModel *)parserObject;
                if (listModel.couponList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                        [self.floorsAarr removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.couponList];
                    [self handleTableViewFloorsData:listModel.couponList];
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:@"暂无数据"];
                        [self.dataList removeAllObjects];
                        [self.tableview reloadData];
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
        }
    }
}

/**优惠券列表 Api*/
- (void)httpPath_couponList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_couponList;
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



@end
