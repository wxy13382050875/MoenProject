//
//  StoreActivityDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreActivityDetailVC.h"
#import "StoreActivityHeaderTCell.h"
#import "OrderPromotionTCell.h"
#import "StoreActivityDetailModel.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "SearchGoodsVC.h"
#import "CouponActivityTipTCell.h"

#import "CustomerAccountListTCell.h"
#import "couponCategoryTCell.h"
#import "CouponStoreTCell.h"
#import "CouponStoreAddressTCell.h"

@interface StoreActivityDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_Bottom_Constraints;
@property (weak, nonatomic) IBOutlet UILabel *tis_LAb;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) StoreActivityDetailModel *dataModel;

@property (nonatomic, strong) UIButton *searchBtn;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray *comboPromoArr;

@end

@implementation StoreActivityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"sales_activities", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"StoreActivityHeaderTCell" bundle:nil] forCellReuseIdentifier:@"StoreActivityHeaderTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CustomerAccountListTCell" bundle:nil] forCellReuseIdentifier:@"CustomerAccountListTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"couponCategoryTCell" bundle:nil] forCellReuseIdentifier:@"couponCategoryTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponStoreTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponStoreAddressTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreAddressTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponActivityTipTCell" bundle:nil] forCellReuseIdentifier:@"CouponActivityTipTCell"];
    
    
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setImage:ImageNamed(@"s_search_icon") forState:UIControlStateNormal];
    [rightButton setImage:ImageNamed(@"s_search_icon") forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
   
    self.searchBtn = rightButton;
    [self.searchBtn setHidden:YES];
    if ([self.promoType isEqualToString:@"COUPON"]) {
        self.tableview_Bottom_Constraints.constant = 80;
        [self.tis_LAb setHidden:NO];
    }
    else
    {
        self.tableview_Bottom_Constraints.constant = 0;
        [self.tis_LAb setHidden:YES];
    }
    
    
}

- (void)configBaseData
{
    
    if ([self.promoType isEqualToString:@"SET_MEAL"]) {
        [self configPagingData];
        [[NSToastManager manager] showprogress];
        [self httpPath_getPromoDetail];
        WEAKSELF
        [self.tableview addDropDownRefreshWithActionHandler:^{
            [weakSelf handlePageNumber];
            weakSelf.pageNumber = 1;
            
            //对应接口
            [weakSelf httpPath_getPromoDetail];
        }];
        [self.tableview addPullUpRefreshWithActionHandler:^{
            [weakSelf handlePageNumber];
            weakSelf.pageNumber += 1;
            
            //对应接口
            [weakSelf httpPath_getPromoDetail];
        }];
    }
    else
    {
        [[NSToastManager manager] showprogress];
        [self httpPath_getPromoDetail];
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
    
    if ([model.cellIdentify isEqualToString:KStoreActivityHeaderTCell]) {
        StoreActivityHeaderTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreActivityHeaderTCell" forIndexPath:indexPath];
        [cell showDataWtihStoreActivityDetailModel:self.dataModel];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KOrderPromotionTCell]) {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPromotionTCell" forIndexPath:indexPath];
        NSString *activityStr = self.dataModel.orderPromo[indexPath.section - 1];
        [cell showDataWithOrderAcitvitiesString:activityStr WithOrderDerate:@""];
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell])
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithStoreActivityMealModel:self.comboPromoArr[indexPath.section - 1] AtIndex:indexPath.section];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        
        StoreActivityMealModel *goodsModel = self.comboPromoArr[indexPath.section - 1];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithStoreActivityMealProductsModel:goodsModel.products[indexPath.row - 1]];
        return cell;
    }
    
    else if ([model.cellIdentify isEqualToString:KCustomerAccountListTCell]) {
        CustomerAccountListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerAccountListTCell" forIndexPath:indexPath];
        [cell showDataWithStoreActivityCouponInfoModel:self.dataModel.couponPromo[indexPath.section - 1] WithIsEdit:NO AtIndex:indexPath.section];
        cell.selectedActionBlock = ^(NSInteger clickType, NSInteger atIndex, BOOL isShowDetail) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShowDetail WithAtIndex:atIndex];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KcouponCategoryTCell])
    {
        
        couponCategoryTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCategoryTCell" forIndexPath:indexPath];
        StoreActivityCouponInfoModel *couponModel = self.dataModel.couponPromo[indexPath.section - 1];
        [cell showDataWithString:couponModel.couponCategory];
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
        StoreActivityCouponInfoModel *couponModel = self.dataModel.couponPromo[indexPath.section - 1];
        if ([couponModel.couponType isEqualToString:@"订单优惠"]) {
            StoreActivityShopInfo *shopModel = couponModel.couponShops[indexPath.row - 2];
            [cell showDataWithString:shopModel.shopName];
        }
        else
        {
            StoreActivityShopInfo *shopModel = couponModel.couponShops[indexPath.row - 3];
            [cell showDataWithString:shopModel.shopName];
        }
        
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:kCouponActivityTipTCell])
    {
        CouponActivityTipTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponActivityTipTCell" forIndexPath:indexPath];
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
    NSMutableArray *dataArr = self.floorsAarr[section];
    CommonTVDataModel *model = dataArr[0];
    if ([model.cellIdentify isEqualToString:KStoreActivityHeaderTCell]) {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        footerView.backgroundColor = AppBgWhiteColor;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        lineView.backgroundColor = AppBgBlueGrayColor;
        [footerView addSubview:lineView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 35)];
        [titleLab setText:self.dataModel.type];
        titleLab.font = FONTSYS(14);
        [titleLab setTextColor:AppTitleBlackColor];
        [footerView addSubview:titleLab];
        
        if ([self.dataModel.typeId isEqualToString:@"COUPON"]) {
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
            bottomLineView.backgroundColor = AppBgBlueGrayColor;
            [footerView addSubview:bottomLineView];
        }

    }
    return footerView;
}
//#pragma mark -- UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    NSDictionary *itemData = [[NSDictionary alloc] init];
//    //    itemData = self.sectionArr[indexPath.row];
//    //    HelpDetailVC *helpDetailVC = [[HelpDetailVC alloc] init];
//    //    helpDetailVC.title = itemData[@"title"];
//    //    helpDetailVC.infoDic = itemData;
//    //    [self.navigationController pushViewController:helpDetailVC animated:YES];
//}

- (void)searchbuttonClick
{
    SearchGoodsVC *searchGoodsVC = [[SearchGoodsVC alloc] init];
    searchGoodsVC.controllerType = SearchGoodsVCTypePackage;
    searchGoodsVC.promoId = self.dataModel.promoId;
    searchGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchGoodsVC animated:YES];
}

- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    if ([self.dataModel.typeId isEqualToString:@"SET_MEAL"]) {
        NSMutableArray *sectionArr = self.floorsAarr[atIndex];
        StoreActivityMealModel *goodsModel = self.comboPromoArr[atIndex - 1];
        if (isShow) {
            for (StoreActivityMealProductsModel *model in goodsModel.products) {
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
            [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.products.count, goodsModel.products.count)];
        }
        
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
            [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    else if ([self.dataModel.typeId isEqualToString:@"COUPON"])
    {
        NSMutableArray *sectionArr = self.floorsAarr[atIndex];
        StoreActivityCouponInfoModel *couponModel = self.dataModel.couponPromo[atIndex - 1];
        if (isShow) {
            if ([couponModel.couponType isEqualToString:@"品类优惠"]) {
                CommonTVDataModel *categorycellModel = [[CommonTVDataModel alloc] init];
                categorycellModel.cellIdentify = KcouponCategoryTCell;
                CGFloat height = [NSTool getHeightWithContent:[NSString stringWithFormat:@"参与活动的品类：%@",couponModel.couponCategory] width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
                categorycellModel.cellHeight = height + 20;
                [sectionArr addObject:categorycellModel];
            }
            
            CommonTVDataModel *storecellModel = [[CommonTVDataModel alloc] init];
            storecellModel.cellIdentify = KCouponStoreTCell;
            storecellModel.cellHeight = KCouponStoreTCellHeight;
            [sectionArr addObject:storecellModel];
            
            for (StoreActivityShopInfo *model in couponModel.couponShops) {
                CommonTVDataModel *addresscellModel = [[CommonTVDataModel alloc] init];
                addresscellModel.cellIdentify = KCouponStoreAddressTCell;
                CGFloat height = [NSTool getHeightWithContent:model.shopName width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
                addresscellModel.cellHeight = height + 10;
                [sectionArr addObject:addresscellModel];
            }
            couponModel.isShowDetail = YES;
        }
        else
        {
            couponModel.isShowDetail = NO;
            [sectionArr removeObjectsInRange:NSMakeRange(1, sectionArr.count - 1)];
        }
        
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
            [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
}

#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.floorsAarr removeAllObjects];
    //订单总览
    NSMutableArray *orderHeaderArr = [[NSMutableArray alloc] init];
    CommonTVDataModel *orderHeaderCellModel = [[CommonTVDataModel alloc] init];
    orderHeaderCellModel.cellIdentify = KStoreActivityHeaderTCell;
    orderHeaderCellModel.cellHeight = KStoreActivityHeaderTCellHeight;
    if (self.dataModel.activityAbstract.length == 0) {
        orderHeaderCellModel.cellHeight -= 30;
    }
    
    orderHeaderCellModel.cellHeaderHeight = 0.01;
    orderHeaderCellModel.cellFooterHeight = 40;
    [orderHeaderArr addObject:orderHeaderCellModel];
    [self.floorsAarr addObject:orderHeaderArr];
    
    if ([self.dataModel.typeId isEqualToString:@"ORDER"]) {
        
        for (NSString *str in self.dataModel.orderPromo) {
            //订单优惠
            NSMutableArray *orderPromoArr = [[NSMutableArray alloc] init];
            CommonTVDataModel *promotionCellModel = [[CommonTVDataModel alloc] init];
            promotionCellModel.cellIdentify = KOrderPromotionTCell;
            promotionCellModel.cellHeight = KOrderPromotionTCellH;
            promotionCellModel.cellHeaderHeight = 0.01;
            promotionCellModel.cellFooterHeight = 0.01;
            [orderPromoArr addObject:promotionCellModel];
            [self.floorsAarr addObject:orderPromoArr];
        }
    }
    
    if ([self.dataModel.typeId isEqualToString:@"SET_MEAL"]) {
        
        [self.searchBtn setHidden:NO];
        //订单套餐
        for (StoreActivityMealModel *model in self.comboPromoArr) {
            NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
            //当前商品的Cell
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsTCell;
            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
            cellModel.cellHeaderHeight = 1;
            cellModel.cellFooterHeight = 5;
            [sectionArr addObject:cellModel];
            [self.floorsAarr addObject:sectionArr];
        }
    }
    
    if ([self.dataModel.typeId isEqualToString:@"COUPON"]) {
        
        //优惠券促销
        for (StoreActivityCouponInfoModel *model in self.dataModel.couponPromo) {
            NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
            CommonTVDataModel *CouponInfoCellModel = [[CommonTVDataModel alloc] init];
            CouponInfoCellModel.cellIdentify = KCustomerAccountListTCell;
            CouponInfoCellModel.cellHeight = KCustomerAccountListTCellHeight;
            CouponInfoCellModel.cellHeaderHeight = 0.01;
            CouponInfoCellModel.cellFooterHeight = 5;
            [sectionArr addObject:CouponInfoCellModel];
                        
            if ([model.couponType isEqualToString:@"品类优惠"]) {
                CommonTVDataModel *categorycellModel = [[CommonTVDataModel alloc] init];
                categorycellModel.cellIdentify = KcouponCategoryTCell;
                CGFloat height = [NSTool getHeightWithContent:[NSString stringWithFormat:@"参与活动的品类：%@",model.couponCategory] width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
                categorycellModel.cellHeight = height + 20;
                [sectionArr addObject:categorycellModel];
            }
            
            CommonTVDataModel *storecellModel = [[CommonTVDataModel alloc] init];
            storecellModel.cellIdentify = KCouponStoreTCell;
            storecellModel.cellHeight = KCouponStoreTCellHeight;
            [sectionArr addObject:storecellModel];
            
            for (StoreActivityShopInfo *itemModel in model.couponShops) {
                CommonTVDataModel *addresscellModel = [[CommonTVDataModel alloc] init];
                addresscellModel.cellIdentify = KCouponStoreAddressTCell;
                CGFloat height = [NSTool getHeightWithContent:itemModel.shopName width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:5];
                addresscellModel.cellHeight = height + 10;
                [sectionArr addObject:addresscellModel];
            }
            model.isShowDetail = YES;
            
            [self.floorsAarr addObject:sectionArr];
        }
        
//        NSMutableArray *tipsArr = [[NSMutableArray alloc] init];
//        CommonTVDataModel *CouponTipsCellModel = [[CommonTVDataModel alloc] init];
//        CouponTipsCellModel.cellIdentify = kCouponActivityTipTCell;
//        CouponTipsCellModel.cellHeight = kCouponActivityTipTCellH;
//        CouponTipsCellModel.cellHeaderHeight = 0.01;
//        CouponTipsCellModel.cellFooterHeight = 0.01;
//        [tipsArr addObject:CouponTipsCellModel];
//        [self.floorsAarr addObject:tipsArr];
        
        
        
        
        
        
        
//        //订单套餐
//        for (StoreActivityMealModel *model in self.dataModel.comboPromo) {
//            NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
//            //当前商品的Cell
//            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
//            cellModel.cellIdentify = KCommonSingleGoodsTCell;
//            cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
//            cellModel.cellHeaderHeight = 1;
//            cellModel.cellFooterHeight = 5;
//            [sectionArr addObject:cellModel];
//            [self.floorsAarr addObject:sectionArr];
//        }
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
        if ([operation.urlTag isEqualToString:Path_getPromoDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getPromoDetail]) {
                StoreActivityDetailModel *model = (StoreActivityDetailModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    if ([self.promoType isEqualToString:@"SET_MEAL"]) {
                        if (model.comboPromo.count) {
                            if (self.pageNumber == 1) {
                                [self.comboPromoArr removeAllObjects];
                            }
                            self.dataModel = model;
                            [self.comboPromoArr addObjectsFromArray:model.comboPromo];
                            self.isShowEmptyData = NO;
                            [self handleTableViewFloorsData];
                            [self.tableview reloadData];
                        }
                        else
                        {
                            if (self.pageNumber == 1) {
                                self.dataModel = model;
                                [self.comboPromoArr removeAllObjects];
                                self.isShowEmptyData = YES;
                                [self handleTableViewFloorsData];
                                [self.tableview reloadData];
                            }
                            else
                            {
                                self.pageNumber -= 1;
                                [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                            }
                            [self.tableview hidenRefreshFooter];
                        }
                    }
                    else
                    {
                        self.dataModel = model;
                        [self handleTableViewFloorsData];
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
        }
    }
}

/**活动详情 Api*/
- (void)httpPath_getPromoDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.promoId forKey:@"promoId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    if ([self.promoType isEqualToString:@"SET_MEAL"])
    {
         [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
         [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
//         [parameters setValue:@"current" forKey:@"promoType"];
    }
    else
    {
//        [parameters setValue:@"current" forKey:@"promoType"];
    }
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_getPromoDetail;
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
- (StoreActivityDetailModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[StoreActivityDetailModel alloc] init];
    }
    return _dataModel;
}


- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}


- (NSMutableArray *)comboPromoArr
{
    if (!_comboPromoArr) {
        _comboPromoArr = [[NSMutableArray alloc] init];
    }
    return _comboPromoArr;
}


@end
