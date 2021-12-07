//
//  ProfessionalCustomerVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ProfessionalCustomerVC.h"
#import "CStatisticsNumberTCell.h"
#import "CommonSaleasTCell.h"
#import "MajorCustomerModel.h"
#import "AddProfessionalCustomerVC.h"

@interface ProfessionalCustomerVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) NSString *countStr;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;


@property (nonatomic, assign) BOOL isAgainEnter;


@end

@implementation ProfessionalCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgainEnter = NO;
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAgainEnter) {
        [self handlePageSize];
        [[NSToastManager manager] showprogress];
        [self httpPath_specialtyCustomer];
    }
    self.isAgainEnter = YES;
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"专业客户";
    
    //设置导航栏
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftButton setImage:ImageNamed(@"c_add_white_btn_icon") forState:UIControlStateNormal];
    [leftButton setImage:ImageNamed(@"c_add_white_btn_icon") forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSaleasTCell" bundle:nil] forCellReuseIdentifier:@"CommonSaleasTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CStatisticsNumberTCell" bundle:nil] forCellReuseIdentifier:@"CStatisticsNumberTCell"];
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无专业客户信息";
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_specialtyCustomer];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_specialtyCustomer];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_specialtyCustomer];
    }];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_specialtyCustomer];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 105;
    }
    return 70;
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
    if (indexPath.section == 0) {
        CStatisticsNumberTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CStatisticsNumberTCell" forIndexPath:indexPath];
        [cell showDataWithCountStr:self.countStr];
        return cell;
    }
    
    CommonSaleasTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSaleasTCell" forIndexPath:indexPath];
    cell.cellType = CommonSaleasTCellCustomerInfo;
    [cell showDataWithMajorCustomerModel:self.dataList[indexPath.row]];
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

- (void)addAction:(UIButton *)sender
{
    AddProfessionalCustomerVC *addProfessionalCustomerVC = [[AddProfessionalCustomerVC alloc] init];
//    addProfessionalCustomerVC.productID = model.ID;
    [self.navigationController pushViewController:addProfessionalCustomerVC animated:YES];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_specialtyCustomer]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_specialtyCustomer]) {
                MajorCustomerListModel *listModel = (MajorCustomerListModel *)parserObject;
                self.countStr = [NSString stringWithFormat:@"%ld",(long)listModel.count];
                if (listModel.specialtyCustomerList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.specialtyCustomerList];
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

/**门店专业客户Api*/
- (void)httpPath_specialtyCustomer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_specialtyCustomer;
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
