//
//  PatrolStoreSearchVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PatrolStoreCheckVC.h"
#import "SamplingInputTCell.h"
#import "PatrolStoreCheckDetailVC.h"
#import "PatrolShopModel.h"

@interface PatrolStoreCheckVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) NSInteger yearValue;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation PatrolStoreCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"store_check", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无巡店信息";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
}

- (void)configBaseData
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy";
    NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
    self.yearValue = [dateStr integerValue];
    if (self.yearValue == 2019) {
        [self.tableview hidenRefreshFooter];
    }
    
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_patrolShopList];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy";
        NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
        weakSelf.yearValue = [dateStr integerValue];
        
        //对应接口
        [weakSelf httpPath_patrolShopList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        weakSelf.yearValue -= 1;
        
        if (self.yearValue == 2019) {
            [self.tableview hidenRefreshFooter];
        }
        //对应接口
        [weakSelf httpPath_patrolShopList];
        
    }];
    
}


- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_patrolShopList];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
    cell.cellType = SamplingInputTCellForPatrolShop;
    [cell showDataWithPatrolShopModel:self.dataList[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
    headerView.backgroundColor = AppBgBlueColor;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 36)];
    titleLab.font = FONTSYS(14);
    titleLab.textColor = AppTitleBlackColor;
    titleLab.text = [NSString stringWithFormat:@"%ld",self.yearValue];
    [headerView addSubview:titleLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolShopModel *model = self.dataList[indexPath.row];
    PatrolStoreCheckDetailVC *patrolStoreCheckDetailVC = [[PatrolStoreCheckDetailVC alloc] init];
    patrolStoreCheckDetailVC.patrolShopId = model.ID;
    [self.navigationController pushViewController:patrolStoreCheckDetailVC animated:YES];
}



#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    if (self.yearValue == 2019) {
        [self.tableview hidenRefreshFooter];
    }
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_patrolShopList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_patrolShopList]) {
                PatrolShopListModel *listModel = (PatrolShopListModel *)parserObject;
                if (listModel.patrolShopList.count) {
                    self.isShowEmptyData = NO;
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:listModel.patrolShopList];
                [weakSelf.tableview reloadData];
            }
        
        }
    }
}

/**巡店列表Api*/
- (void)httpPath_patrolShopList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.yearValue) forKey:@"createDate"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_patrolShopList;
}


#pragma mark -- Getter&Setter
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
