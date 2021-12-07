//
//  AwardsDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "AwardsDetailVC.h"
#import "CouponRecordDetailTCell.h"
#import "AwardsDetailVC.h"
#import "AwardsDetailModel.h"

@interface AwardsDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation AwardsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    self.title = @"奖励详情";
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    //    self.title = NSLocalizedString(@"select_order", nil);
    
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_GetRewardList];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_GetRewardList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_GetRewardList];
    }];
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
    
    return 120;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CouponRecordDetailTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponRecordDetailTCell" forIndexPath:indexPath];
    [cell showDataWithAwardsDetailItemModel:self.dataList[indexPath.section]];
        //                [cell showDataWithOrderManageModel:model];
        return cell;
    
    
    //    OrderManageModel *model = self.dataList[indexPath.section];
    //    if (model.orderItemInfos.count > 1) {
    //        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
    //        [cell showDataWithOrderManageModel:model];
    //        return cell;
    //    }
    //    else
    //    {
    //        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
    //        [cell showDataWithOrderManageModel:model];
    //        return cell;
    //    }
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    footerView.backgroundColor = AppBgBlueGrayColor;
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AwardsDetailVC *awardsDetailVC = [[AwardsDetailVC alloc] init];
//
//    [self.navigationController pushViewController:awardsDetailVC animated:YES];
    
}

#pragma mark -- Private Method

/**部分退货*/
//- (void)ReturnPartGoodsAction:(UIButton *)sender
//{
    //    NSInteger atIndex = sender.tag - 10000;
    //    OrderManageModel *model = self.dataList[atIndex];
    //    ReturnGoodsSelectVC *returnGoodsSelectVC = [[ReturnGoodsSelectVC alloc] init];
    //    returnGoodsSelectVC.controllerType = ReturnGoodsSelectVCTypePart;
    //    returnGoodsSelectVC.orderID = model.ID;
    //    [self.navigationController pushViewController:returnGoodsSelectVC animated:YES];
//}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_GetRewardList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_GetRewardList]) {
                AwardsDetailModel *listModel = (AwardsDetailModel *)parserObject;
                if (listModel.rewardList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.rewardList];
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
        }
    }
}

/**奖励明细 Api*/
- (void)httpPath_GetRewardList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.month forKey:@"month"];
    [parameters setValue:self.employeeId forKey:@"employeeId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_GetRewardList;
}


#pragma mark -- Getter&Setter
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CouponRecordDetailTCell" bundle:nil] forCellReuseIdentifier:@"CouponRecordDetailTCell"];
//        [_tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
        //        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无奖励详情";
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
