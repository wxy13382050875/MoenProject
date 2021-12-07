//
//  SelectStoreVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/12/30.
//  Copyright © 2019 Kevin Jin. All rights reserved.
//

#import "SelectStoreVC.h"
#import "ChangeStoreTCell.h"
#import "CommonSkipHelper.h"
#import "LoginInfoModel.h"
#import "StockSearchGoodsVC.h"

@interface SelectStoreVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UserLoginInfoModel *selectedModel;

@end

@implementation SelectStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
//    self.title = @"门店选择";
   self.view.backgroundColor = AppTitleBlueColor;
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"门店选择";

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 100, SCREEN_WIDTH - 160, 40)];
    imageView.image = ImageNamed(@"l_application_name_icon");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.confirmBtn];
    
}



- (void)configBaseData
{
    [self httpPath_dallot_storeList];
}

/**订单列表Api*/
- (void)httpPath_dallot_storeList
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
   
    
   
    
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_dallot_storeList;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (self.dataArr.count - 1)) {
        return 80;
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeStoreTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeStoreTCell" forIndexPath:indexPath];
    UserLoginInfoModel *model = (UserLoginInfoModel *)self.dataArr[indexPath.section];
//    [cell showDataWithUserLoginInfoModel:model];
    cell.model = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == (self.dataArr.count - 1)) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        footerView.backgroundColor = AppBgWhiteColor;
        return footerView;
    }
    return [[UIView alloc] init];
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UserLoginInfoModel *model in self.dataArr) {
        model.isSelected = NO;
    }
    UserLoginInfoModel *selectedModel = (UserLoginInfoModel *)self.dataArr[indexPath.section];
    selectedModel.isSelected = YES;
    self.selectedModel = selectedModel;
    [self.tableView reloadData];
}



- (void)confirmAction:(UIButton *)sender
{
    if (self.selectedModel.storeID.length == 0) {
        [[NSToastManager manager] showtoast:@"请选择门店"];
        return;
    }
    else {
        StockSearchGoodsVC *sellGoodsScanVC = [[StockSearchGoodsVC alloc] init];
        sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
        sellGoodsScanVC.storeID = self.selectedModel.storeID;
        sellGoodsScanVC.controllerType = SearchGoodsVCType_Transfers;
        [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
    }

}


#pragma mark -- Getter&Setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 250, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 380) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = AppBgWhiteColor;
        _tableView.layer.cornerRadius = 3;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"ChangeStoreTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStoreTCell"];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
//        self.comScrollerView = _tableView;
//        self.noDataDes = @"暂无可退订单";
    }
    return _tableView;
}



- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(25, SCREEN_HEIGHT - 180, SCREEN_WIDTH - 50, 40);
        _confirmBtn.titleLabel.font = FONTSYS(14);
        _confirmBtn.clipsToBounds = YES;
        _confirmBtn.layer.cornerRadius = 20;
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:AppTitleBlueColor];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}


- (void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    if ([QZLUserConfig sharedInstance].shopId.length > 0) {
        for (UserLoginInfoModel *model in self.dataArr) {
            model.isSelected = NO;
            if ([model.shopId isEqualToString:[QZLUserConfig sharedInstance].shopId]) {
                model.isSelected = YES;
                self.selectedModel = model;
                break;
            }
        }
    }
    
}
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_dallot_storeList]) {
                    
                
                
                if ([parserObject.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.dataArr = [UserLoginInfoModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"storeList"]];
                    [self.tableView reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }
        }
    }
}
@end
