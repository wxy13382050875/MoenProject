//
//  StoreActivityVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreActivityVC.h"
#import "StoreActivityListTCell.h"
#import "StoreActivityDetailVC.h"
#import "StoreActivityDetailModel.h"

@interface StoreActivityVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation StoreActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    if (self.controllerType == StoreActivityVCCurrent) {
        //设置导航栏
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        leftButton.titleLabel.font = FONTLanTingB(17);
        [leftButton setTitle:NSLocalizedString(@"history_info", nil) forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(historyInfoAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    
    
    if (self.controllerType == StoreActivityVCPersonal) {
        self.title = NSLocalizedString(@"customer_activities", nil);
    }
    else if (self.controllerType == StoreActivityVCHistory)
    {
        self.title = NSLocalizedString(@"store_history_activities", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"store_activities", nil);
    }
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无促销活动信息";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"StoreActivityListTCell" bundle:nil] forCellReuseIdentifier:@"StoreActivityListTCell"];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_getPromoList];
}

- (void)configBaseData
{
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_getPromoList];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_getPromoList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_getPromoList];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataList.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreActivityListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreActivityListTCell" forIndexPath:indexPath];
    [cell showDataWithStoreActivityDetailModel:self.dataList[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
    headerView.backgroundColor = AppBgWhiteColor;
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
    StoreActivityDetailModel *model = self.dataList[indexPath.row];
    StoreActivityDetailVC *storeActivityDetailVC = [[StoreActivityDetailVC alloc] init];
    storeActivityDetailVC.promoId = model.promoId;
    storeActivityDetailVC.promoType = model.proType;
    storeActivityDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeActivityDetailVC animated:YES];
}



- (void)historyInfoAction
{
    StoreActivityVC *storeActivityVC = [[StoreActivityVC alloc] init];
    storeActivityVC.controllerType = StoreActivityVCHistory;
    storeActivityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeActivityVC animated:YES];
}


#pragma mark -- HTTP
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [self.tableview cancelRefreshAction];
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getPromoList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getPromoList]) {

                StoreActivityListModel *listModel = (StoreActivityListModel *)parserObject;
                if (listModel.getPromoList.count) {
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.getPromoList];
                    self.isShowEmptyData = NO;
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [self.dataList removeAllObjects];
                        self.isShowEmptyData = YES;
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

        }
    }
}

/**门店活动列表Api*/
- (void)httpPath_getPromoList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    if (self.controllerType == StoreActivityVCCurrent) {
        [parameters setValue:@"current" forKey:@"promoType"];
    }
    else if (self.controllerType == StoreActivityVCHistory)
    {
        [parameters setValue:@"history" forKey:@"promoType"];
    }
    else if (self.controllerType == StoreActivityVCPersonal)
    {
        [parameters setValue:@"current" forKey:@"promoType"];
        [parameters setValue:@([self.customerId integerValue]) forKey:@"customerId"];
    }
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_getPromoList;
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



@end
