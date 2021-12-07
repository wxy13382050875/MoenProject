//
//  IntentionManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "IntentionManageVC.h"
#import "CommonSearchView.h"
#import "IntentionManageTCell.h"
#import "CustomerIntentModel.h"
#import "FDAlertView.h"

@interface IntentionManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) NSString *searchStr;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL isAgainEnter;


@property (nonatomic, assign) NSInteger deleteIndex;


/**是否删除意向商品 True or False*/
@property (nonatomic, assign) BOOL isDeleteIntentionGoods;
/**删除意向商品ID*/
@property (nonatomic, copy) NSString *deleteIntentionGoodsId;


@end

@implementation IntentionManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAgainEnter) {
        [self handlePageSize];
        [[NSToastManager manager] showprogress];
        [self httpPath_customerIntent];
    }
    self.isAgainEnter = YES;
}
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"intent_manage", nil);
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_customerIntent];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_customerIntent];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_customerIntent];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_customerIntent];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CustomerIntentModel *model = self.dataList[section];
    if (model.isShowDetail) {
        return model.productList.count;
    }
    return model.productList.count > 0 ? 1:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CustomerIntentModel *model = self.dataList[section];
    if (model.productCount > 1) {
        return 50;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    CustomerIntentModel *model = self.dataList[indexPath.section];
    IntentionManageTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntentionManageTCell" forIndexPath:indexPath];
    [cell showDataWithCustomerIntentGoodsModel:model.productList[indexPath.row]];
    cell.deletGoodsBlock = ^(NSString *goodsId) {
        [weakSelf deleteIntentionGoodsWithGoodsId:goodsId];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomerIntentModel *model = self.dataList[section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 38);
    headerView.backgroundColor = AppBgWhiteColor;
    
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 15, 15)];
    [userImg setImage:ImageNamed(@"i_user_icon")];
    [headerView addSubview:userImg];
    
    UILabel *name_Lab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 110, 18)];
    name_Lab.textColor = AppTitleBlackColor;
    name_Lab.font = FontBinB(14);
    name_Lab.text = model.custCode;
    [headerView addSubview:name_Lab];
    
    
    if (model.remark.length) {
        UIImageView *messageImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 68, 10, 20, 20)];
        [messageImg setImage:ImageNamed(@"i_message_icon")];
        messageImg.userInteractionEnabled = YES;
        [messageImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageDetailAction:)]];
        messageImg.tag = 2000 + section;
        [headerView addSubview:messageImg];
    
    }
    UIImageView *trashImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 10, 20, 20)];
    [trashImg setImage:ImageNamed(@"i_trash_icon")];
    trashImg.userInteractionEnabled = YES;
    [trashImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveTrashAction:)]];
    trashImg.tag = 3000 + section;
    [headerView addSubview:trashImg];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    CustomerIntentModel *model = self.dataList[section];
    NSString *goodsCount = [NSString stringWithFormat:@"%ld个商品",(long)model.productCount];
    if (model.productCount > 1) {
        footerView.backgroundColor = AppBgWhiteColor;
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        topLineView.backgroundColor = AppBgBlueGrayColor;
        [footerView addSubview:topLineView];
        
        UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 35)];
        detailBtn.titleLabel.font = FONTSYS(14);
        [detailBtn setTitleColor:AppTitleBlackColor forState:UIControlStateNormal];
        [detailBtn setTitle:goodsCount forState:UIControlStateNormal];
        if (model.isShowDetail) {
            [detailBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        }
        else
        {
            [detailBtn setImage:ImageNamed(@"c_detail_down_icon") forState:UIControlStateNormal];
        }
        
        CGFloat contentWidth = [NSTool getWidthWithContent:goodsCount font:FONT(14)] + 20;
        [detailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, contentWidth, 0, -contentWidth)];
        [detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 25)];
        detailBtn.tag = 4000 + section;
        [detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchDown];
        [footerView addSubview:detailBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 5)];
        lineView.backgroundColor = AppBgBlueGrayColor;
        [footerView addSubview:lineView];
    }
    return footerView;
}






//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WEAKSELF
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示"
////                                                                                 message:@"是否解除绑定当前银行卡"
////                                                                          preferredStyle:UIAlertControllerStyleAlert];
////        UIAlertAction *actionSubmit = [UIAlertAction actionWithTitle:@"立即解绑"
////                                                               style:UIAlertActionStyleDestructive
////                                                             handler:^(UIAlertAction * _Nonnull action) {
////                                                                 [weakSelf deleteBankCardAction:indexPath.row];
////                                                             }];
////        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"暂不解绑"
////                                                               style:UIAlertActionStyleDestructive
////                                                             handler:^(UIAlertAction * _Nonnull action) { }];
//
//
//
//
////        [alterController addAction:actionSubmit];
////        [alterController addAction:actionCancel];
////        [self presentViewController:alterController animated:YES completion:^{}];
//
//    }
//}
//// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    //    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.searchStr = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_customerIntent];
}

- (void)detailAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 4000;
    CustomerIntentModel *model = self.dataList[atIndex];
    if (model.isShowDetail) {
        model.isShowDetail = NO;
    }
    else
    {
        model.isShowDetail = YES;
    }
    [self.tableview reloadData];
}



/**查看备注详情*/
- (void)messageDetailAction:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = [ges view].tag - 2000;
    CustomerIntentModel *model = self.dataList[atIndex];
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"备注信息" alterType:FDAltertViewTypeSeeMark message:model.remark delegate:nil buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
    
}

/**删除用户意向*/
- (void)moveTrashAction:(UIGestureRecognizer *)ges
{
    NSInteger atIndex = [ges view].tag - 3000;
    self.deleteIndex = atIndex;
    self.isDeleteIntentionGoods = NO;
    [self deleteIntentionAction];
}

- (void)deleteIntentionGoodsWithGoodsId:(NSString *)goodsId
{
    self.isDeleteIntentionGoods = YES;
    self.deleteIntentionGoodsId = goodsId;
    [self deleteIntentionAction];
}




- (void)deleteIntentionAction
{
    if (self.isDeleteIntentionGoods) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认要删除意向信息吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
    }
    else
    {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认要删除意向信息吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
    }
   
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        if (self.isDeleteIntentionGoods) {
            [self httpPath_deleteIntentProduct:self.deleteIntentionGoodsId];
        }
        else
        {
            CustomerIntentModel *model = self.dataList[self.deleteIndex];
            [self httpPath_deleteIntentWiht:model.ID];
        }
        
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
        if ([operation.urlTag isEqualToString:Path_customerIntent]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_customerIntent]) {
                CustomerIntentListModel *listModel = (CustomerIntentListModel *)parserObject;
                if (listModel.customerIntentList.count) {
                    self.isShowEmptyData = NO;
                    if (self.pageNumber == 1) {
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:listModel.customerIntentList];
                    [self.tableview reloadData];
                }
                else
                {
                    if (self.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
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
            if ([operation.urlTag isEqualToString:Path_deleteIntent]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"delete_success", nil)];
                    [self handlePageSize];
                    [[NSToastManager manager] showprogress];
                    [self httpPath_customerIntent];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            if ([operation.urlTag isEqualToString:Path_deleteIntentProduct]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"delete_success", nil)];
                    [self handlePageSize];
                    [[NSToastManager manager] showprogress];
                    [self httpPath_customerIntent];
                }
            }
            
        }
    }
}

/**门店人员的会员意向Api*/
- (void)httpPath_customerIntent
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.searchStr forKey:@"phone"];
    [parameters setValue:self.personalId forKey:@"personalId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_customerIntent;
}

/**删除会员意向Api*/
- (void)httpPath_deleteIntentWiht:(NSString *)ID
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:ID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_deleteIntent;
}

/**删除意向商品Api*/
- (void)httpPath_deleteIntentProduct:(NSString *)ID
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:ID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_deleteIntentProduct;
}


#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeIntention;
        
    }
    return _searchView;
}


- (UITableView *)tableview
{
    if (!_tableview) {
        if (self.controllerType == IntentionManageVCTypeWithHeader) {
            _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height - 100) style:UITableViewStyleGrouped];
        }
        else
        {
            _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_NavTop_Height - 50) style:UITableViewStyleGrouped];
        }
        
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"IntentionManageTCell" bundle:nil] forCellReuseIdentifier:@"IntentionManageTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无意向信息";
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
