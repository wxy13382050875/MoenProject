//
//  AddressListVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddressListVC.h"
#import "AddressListItemTCell.h"
#import "AddressAddVC.h"
#import "AddressInfoModel.h"

@interface AddressListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBtnHeight;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation AddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSToastManager manager] showprogress];
    [self httpPath_customerAddress];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"address_manage", nil);
    
    if (!self.isDefault) {
        //设置导航栏
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
        [rightButton setTitle:NSLocalizedString(@"no_use_address", nil) forState:UIControlStateNormal];
        [rightButton setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        rightButton.titleLabel.font = FONTSYS(17);
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton addTarget:self action:@selector(noUseAddressAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    
    CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
    self.addressBtnHeight.constant = btnHeight;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无收货地址";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"AddressListItemTCell" bundle:nil] forCellReuseIdentifier:@"AddressListItemTCell"];
    
    self.addNewAddressBtn.titleLabel.font = FONTLanTingB(17);
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_customerAddress];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_customerAddress];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_customerAddress];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_customerAddress];
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
    return 75;
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
    AddressListItemTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListItemTCell" forIndexPath:indexPath];
    [cell showDataWithAddressInfoModel:self.dataList[indexPath.section]];
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
    if (!self.isDefault) {
        AddressInfoModel *model = self.dataList[indexPath.section];
        if ([self.delegate respondsToSelector:@selector(AddressListVCSelectedDelegate:)]) {
            [self.delegate AddressListVCSelectedDelegate:model.addressId];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)addNewAddressAction:(UIButton *)sender {
    
    AddressAddVC *addressAddVC = [[AddressAddVC alloc] init];
    addressAddVC.customerId = self.customerId;
//    addressAddVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressAddVC animated:YES];
}

- (void)noUseAddressAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(AddressListVCSelectedDelegate:)]) {
        [self.delegate AddressListVCSelectedDelegate:@"0"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_customerAddress]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_customerAddress]) {

                AddressListModel *listModel = (AddressListModel *)parserObject;
                if (listModel.addressList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.addressList];
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

/**地址管理列表Api*/
- (void)httpPath_customerAddress
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_customerAddress;
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
