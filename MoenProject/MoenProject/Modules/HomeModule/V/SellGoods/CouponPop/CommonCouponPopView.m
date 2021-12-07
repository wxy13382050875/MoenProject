//
//  CommonCouponPopView.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/3.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "CommonCouponPopView.h"
#import "KSegmentMenuView.h"
#import "CustomerAccountListTCell.h"
#import "CouponInfoModel.h"
#import "couponCategoryTCell.h"
#import "CouponStoreTCell.h"
#import "CouponStoreAddressTCell.h"

#import "UIScrollView+EmptyDataSet.h"

@interface CommonCouponPopView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger _selectdIndex;
}

//底部view
@property (nonatomic,strong) UIView *bottomPopView;

@property (nonatomic,assign) CGFloat bottomPopViewHeight;//分享视图的高度

@property (nonatomic, strong) KSegmentMenuView *menuView;

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UITableView *useTableview;

@property (nonatomic, strong) UITableView *unavailableTableview;

@property (nonatomic, strong) NSMutableArray *rightFloorsAarr;
@property (nonatomic, strong) NSMutableArray *leftFloorsAarr;

@end

@implementation CommonCouponPopView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.delegate = self;
        [tapGestureRecognizer addTarget:self action:@selector(closeShareView)];
        [self addGestureRecognizer:tapGestureRecognizer];
        self.bottomPopViewHeight = SCREEN_HEIGHT - 160;
        
        UIView *topView = [[UIView alloc] init];
        topView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 45);
        topView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        [self.bottomPopView addSubview:topView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = AppTitleBlackColor;
        titleLab.font = FONTSYS(18);
        titleLab.frame = CGRectMake(80, 0, SCREEN_WIDTH - 160, 45);
        titleLab.text = @"优惠券";
        titleLab.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLab];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(SCREEN_WIDTH - 46, 5, 36, 36);
        [closeBtn setImage:ImageNamed(@"s_close_btn_icon") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:closeBtn];
        
        [self setMainScrollView];
        
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(0, self.bottomPopViewHeight - 45, SCREEN_WIDTH, 45);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setBackgroundColor:UIColorFromRGB(0x19355C)];
        [confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = FONTSYS(17);
        
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchDown];
        [self.bottomPopView addSubview:confirmBtn];
        
        [self addSubview:self.bottomPopView];
    }
    return self;
}


- (void)setMainScrollView{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,90 , SCREEN_WIDTH, self.bottomPopViewHeight - 135)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    [self.bottomPopView addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.useTableview];
    [self.mainScrollView addSubview:self.unavailableTableview];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.useTableview) {
        return self.leftFloorsAarr.count;
    }
    else
    {
        return self.rightFloorsAarr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.useTableview) {
        NSMutableArray *dataArr = self.leftFloorsAarr[section];
        return dataArr.count;
    }
    else
    {
        NSMutableArray *dataArr = self.rightFloorsAarr[section];
        return dataArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.useTableview) {
        NSMutableArray *dataArr = self.leftFloorsAarr[indexPath.section];
        CommonTVDataModel *model = dataArr[indexPath.row];
        return model.cellHeight;
    }
    else
    {
        NSMutableArray *dataArr = self.rightFloorsAarr[indexPath.section];
        CommonTVDataModel *model = dataArr[indexPath.row];
        return model.cellHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.useTableview) {
        NSMutableArray *dataArr = self.leftFloorsAarr[section];
        CommonTVDataModel *model = dataArr[0];
        return model.cellHeaderHeight;
    }
    else
    {
        NSMutableArray *dataArr = self.rightFloorsAarr[section];
        CommonTVDataModel *model = dataArr[0];
        return model.cellHeaderHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.useTableview) {
        NSMutableArray *dataArr = self.leftFloorsAarr[section];
        CommonTVDataModel *model = dataArr[0];
        return model.cellFooterHeight;
    }
    else
    {
        NSMutableArray *dataArr = self.rightFloorsAarr[section];
        CommonTVDataModel *model = dataArr[0];
        return model.cellFooterHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.useTableview) {
        WEAKSELF
        NSMutableArray *dataArr = self.leftFloorsAarr[indexPath.section];
        CommonTVDataModel *model = dataArr[indexPath.row];
        if ([model.cellIdentify isEqualToString:KCustomerAccountListTCell]) {
            CustomerAccountListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerAccountListTCell" forIndexPath:indexPath];
            
            [cell showDataWithCouponInfoModel:self.usableArr[indexPath.section] WithIsEdit:YES AtIndex:indexPath.section IsShowRef:NO];
            cell.selectedActionBlock = ^(NSInteger clickType, NSInteger atIndex, BOOL isShowDetail) {
                [weakSelf handleSelectedActionWithType:0 WithCickType:clickType AtIndex:atIndex WithIsShow:isShowDetail];
            };
            return cell;
        }
        else if ([model.cellIdentify isEqualToString:KcouponCategoryTCell])
        {
            couponCategoryTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCategoryTCell" forIndexPath:indexPath];
            CouponInfoModel *goodsModel = self.usableArr[indexPath.section];
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
            CouponInfoModel *goodsModel = self.usableArr[indexPath.section];
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
    }
    else
    {
        WEAKSELF
        NSMutableArray *dataArr = self.rightFloorsAarr[indexPath.section];
        CommonTVDataModel *model = dataArr[indexPath.row];
        if ([model.cellIdentify isEqualToString:KCustomerAccountListTCell]) {
            CustomerAccountListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerAccountListTCell" forIndexPath:indexPath];
            
            [cell showDataWithCouponInfoModel:self.unavailableArr[indexPath.section] WithIsEdit:NO AtIndex:indexPath.section IsShowRef:YES];
            cell.selectedActionBlock = ^(NSInteger clickType, NSInteger atIndex, BOOL isShowDetail) {
                [weakSelf handleSelectedActionWithType:1 WithCickType:clickType AtIndex:atIndex WithIsShow:isShowDetail];
            };
            return cell;
        }
        else if ([model.cellIdentify isEqualToString:KcouponCategoryTCell])
        {
            couponCategoryTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCategoryTCell" forIndexPath:indexPath];
            CouponInfoModel *goodsModel = self.unavailableArr[indexPath.section];
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
            CouponInfoModel *goodsModel = self.unavailableArr[indexPath.section];
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

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.useTableview) {
        [self handleSelectedActionWithType:0 WithCickType:0 AtIndex:indexPath.section WithIsShow:NO];
    }
    
}


#pragma  mark -- 配置楼层信息
- (void)handleTableViewFloorsData
{
    [self.leftFloorsAarr removeAllObjects];
    [self.rightFloorsAarr removeAllObjects];
    for (CouponInfoModel *model in self.usableArr) {
        //地址
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *CouponInfoCellModel = [[CommonTVDataModel alloc] init];
        CouponInfoCellModel.cellIdentify = KCustomerAccountListTCell;
        CouponInfoCellModel.cellHeight = KCustomerAccountListTCellHeight;
        CouponInfoCellModel.cellHeaderHeight = 0.01;
        CouponInfoCellModel.cellFooterHeight = 5;
        [sectionArr addObject:CouponInfoCellModel];
        [self.leftFloorsAarr addObject:sectionArr];
    }
    
    for (CouponInfoModel *model in self.unavailableArr) {
        //地址
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        CommonTVDataModel *CouponInfoCellModel = [[CommonTVDataModel alloc] init];
        CouponInfoCellModel.cellIdentify = KCustomerAccountListTCell;
        CouponInfoCellModel.cellHeight = KCustomerAccountListRefTCellHeight;
        CouponInfoCellModel.cellHeaderHeight = 0.01;
        CouponInfoCellModel.cellFooterHeight = 5;
        [sectionArr addObject:CouponInfoCellModel];
        [self.rightFloorsAarr addObject:sectionArr];
    }
}

- (void)handleSelectedActionWithType:(NSInteger)dataType WithCickType:(NSInteger)clickType AtIndex:(NSInteger)atIndex WithIsShow:(BOOL)isShow
{
    //选择事件
    if (clickType == 0) {
        if (dataType == 0) {
            NSString *selectedId = @"";
            for (CouponInfoModel *model in self.usableArr) {
                if (model.isSelected) {
                    selectedId = model.assetId;
                }
                model.isSelected = NO;
            }
            
            CouponInfoModel *model = self.usableArr[atIndex];
            model.isSelected = YES;
            if (selectedId.length > 0 && [model.assetId isEqualToString:selectedId]) {
                model.isSelected = NO;
            }
            [self.useTableview reloadData];
        }
    }
    //展示详情事件
    else
    {
        if (dataType == 0) {
            NSMutableArray *sectionArr = self.leftFloorsAarr[atIndex];
            CouponInfoModel *goodsModel = self.usableArr[atIndex];
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
                [self.useTableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        else
        {
            NSMutableArray *sectionArr = self.rightFloorsAarr[atIndex];
            CouponInfoModel *goodsModel = self.unavailableArr[atIndex];
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
                [self.unavailableTableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }
}

-(void)showShareViewWithDXShareModel
{
    for (CouponInfoModel *model in self.usableArr) {
        if ([model.assetId isEqualToString:self.currentSelectId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    [self handleTableViewFloorsData];
    WEAKSELF
    NSString *firstStr = [NSString stringWithFormat:@"可使用(%lu)",(unsigned long)self.usableArr.count];
    
    NSString *secondStr = [NSString stringWithFormat:@"不可使用(%lu)",(unsigned long)self.unavailableArr.count];
    
    self.menuView = [[KSegmentMenuView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 45) titles:@[firstStr,secondStr] titleFont:FONTSYS(14) selectedColor:AppTitleBlackColor normalColor:AppTitleBlackColor lineColor:UIColorFromRGB(0x19355C) selectedIndex:0 selectBlock:^(NSInteger menuIndex) {
                    [weakSelf setSelectedIndex:menuIndex];
        
    }];
    
    [self.bottomPopView addSubview:self.menuView];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.bottomPopView.frame = CGRectMake(0, SCREEN_HEIGHT - self.bottomPopViewHeight, SCREEN_WIDTH, self.bottomPopViewHeight);
    }];
    [self.useTableview reloadData];
    [self.useTableview reloadEmptyDataSet];
    [self.unavailableTableview reloadData];
    [self.unavailableTableview reloadEmptyDataSet];
}


- (void)confirmAction
{
    NSString *assetId = @"";
    for (CouponInfoModel *model in self.usableArr) {
        if (model.isSelected) {
            assetId = model.assetId;
            break;
        }
    }
//    if (assetId.length == 0) {
//        [[NSToastManager manager] showtoast:@"请选择使用的优惠券"];
//    }
//    else
//    {
        if ([self.delegate respondsToSelector:@selector(selectedCouponDelegate:)]) {
            [self.delegate selectedCouponDelegate:assetId];
        }
        [self closeShareView];
//    }
}


#pragma mark - 点击背景关闭视图
-(void)closeShareView
{
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomPopView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.bottomPopViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}

//点击回调
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    self.menuView.selectedIndex = selectedIndex;
    
    CGFloat offsetX = selectedIndex * self.mainScrollView.frame.size.width;
    CGFloat offsetY = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.mainScrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.useTableview ||
        scrollView == self.unavailableTableview) {
        return;
    }
    NSUInteger index = scrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    //设置被选中位置
    if (_selectdIndex == index) {
        return;
    }
    _selectdIndex = index;
    self.menuView.selectedIndex = index;
    
}


/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}


-(UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.bottomPopViewHeight)];
        _bottomPopView.backgroundColor = UIColorFromRGB(0xF3F3FC);
    }
    return _bottomPopView;
}

- (UITableView *)useTableview
{
    if (!_useTableview) {
        _useTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bottomPopViewHeight - 135) style:UITableViewStyleGrouped];
        _useTableview.backgroundColor = AppBgBlueGrayColor;
        _useTableview.delegate = self;
        _useTableview.dataSource = self;
        _useTableview.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_useTableview registerNib:[UINib nibWithNibName:@"CustomerAccountListTCell" bundle:nil] forCellReuseIdentifier:@"CustomerAccountListTCell"];
        [_useTableview registerNib:[UINib nibWithNibName:@"couponCategoryTCell" bundle:nil] forCellReuseIdentifier:@"couponCategoryTCell"];
        [_useTableview registerNib:[UINib nibWithNibName:@"CouponStoreTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreTCell"];
        [_useTableview registerNib:[UINib nibWithNibName:@"CouponStoreAddressTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreAddressTCell"];
        _useTableview.emptyDataSetSource = self;
        _useTableview.emptyDataSetDelegate = self;
//        self.comScrollerView = _tableview;
    }
    return _useTableview;
}

- (UITableView *)unavailableTableview
{
    if (!_unavailableTableview) {
        _unavailableTableview = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.bottomPopViewHeight - 135) style:UITableViewStyleGrouped];
        _unavailableTableview.backgroundColor = AppBgBlueGrayColor;
        _unavailableTableview.delegate = self;
        _unavailableTableview.dataSource = self;
        _unavailableTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_unavailableTableview registerNib:[UINib nibWithNibName:@"CustomerAccountListTCell" bundle:nil] forCellReuseIdentifier:@"CustomerAccountListTCell"];
        [_unavailableTableview registerNib:[UINib nibWithNibName:@"couponCategoryTCell" bundle:nil] forCellReuseIdentifier:@"couponCategoryTCell"];
        [_unavailableTableview registerNib:[UINib nibWithNibName:@"CouponStoreTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreTCell"];
        [_unavailableTableview registerNib:[UINib nibWithNibName:@"CouponStoreAddressTCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreAddressTCell"];
        _unavailableTableview.emptyDataSetSource = self;
        _unavailableTableview.emptyDataSetDelegate = self;
    }
    return _unavailableTableview;
}

- (NSMutableArray *)leftFloorsAarr
{
    if (!_leftFloorsAarr) {
        _leftFloorsAarr = [[NSMutableArray alloc] init];
    }
    return _leftFloorsAarr;
}

- (NSMutableArray *)rightFloorsAarr
{
    if (!_rightFloorsAarr) {
        _rightFloorsAarr = [[NSMutableArray alloc] init];
    }
    return _rightFloorsAarr;
}


- (void)dealloc
{
    NSLog(@"优惠券视图释放");
}

#pragma mark -- DZNEmptyDataSetSource DZNEmptyDataSetDelegate

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return ImageNamed(@"c_no_data_icon");
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"";
    if (scrollView == _useTableview) {
        text = @"您暂无可用优惠券\n";
    }
    else
    {
        text = @"无数据\n";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: AppTitleBlackColor};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (scrollView == _useTableview) {
        if (self.usableArr.count) {
            return NO;
        }
        return YES;
    }
    else
    {
        if (self.unavailableArr.count) {
            return NO;
        }
        return YES;
    }
    return NO;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -20;
}


@end
