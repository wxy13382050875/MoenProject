//
//  AddressAddVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddressAddVC.h"
#import "AddressAddTCell.h"
#import "KWCommonPickView.h"
#import "AddressInfoModel.h"
#import "FDAlertView.h"

#import "AddressSelectedModel.h"


@interface AddressAddVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) KWCommonPickView *kwPickView;

@property (nonatomic, strong) AddressInfoModel *dataModel;

/**是否可以操作*/
@property (nonatomic, assign) BOOL isCanOperation;

@end

@implementation AddressAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
//    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateNormal];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateSelected];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    self.title = NSLocalizedString(@"add_address", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgWhiteColor;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"AddressAddTCell" bundle:nil] forCellReuseIdentifier:@"AddressAddTCell"];
}

- (void)navLeftBarButtonClick
{
    BOOL isNeedSave = NO;
    if (self.dataModel.shipPerson.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipMobile.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipProvinceID.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipCityID.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipDistrictID.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipStreetID.length > 0) {
        isNeedSave = YES;
    }
    else if (self.dataModel.shipAddress.length > 0) {
        isNeedSave = YES;
    }
    if (isNeedSave) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"地址信息未保存，是否确认返回？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
       [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configBaseData
{
    
    self.isCanOperation = YES;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    AddressAddTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressAddTCell" forIndexPath:indexPath];
    [cell showDataWithAddressInfoModel:self.dataModel];
    cell.saveBlock = ^(AddressAddTCellActionType actionType) {
        [weakSelf handleActionWithType:actionType];
    };
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


- (void)handleActionWithType:(AddressAddTCellActionType)actionType
{
    if (actionType == AddressAddTCellActionTypeSave) {
        [self httpPath_save_customerAddress];
    }
    else if (actionType == AddressAddTCellActionTypeProvince)
    {
        [self.view endEditing:YES];
        [self httpPath_getProvince];
    }
    else if (actionType == AddressAddTCellActionTypeCity)
    {
        [self.view endEditing:YES];
        if (self.dataModel.shipProvinceID.length == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_province", nil)];
            return;
        }
        [self httpPath_getCity];
    }
    else if (actionType == AddressAddTCellActionTypeDistrict)
    {
        [self.view endEditing:YES];
        if (self.dataModel.shipCityID.length == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_city", nil)];
            return;
        }
        [self httpPath_getDistricts];
    }
    else if (actionType == AddressAddTCellActionTypeStreet)
    {
        [self.view endEditing:YES];
        if (self.dataModel.shipDistrictID.length == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_district", nil)];
            return;
        }
        [self httpPath_getStreet];
    }
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_save_customerAddress]) {
            self.isCanOperation = YES;
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_save_customerAddress]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"address_add_success", nil)];
                    if ([self.delegate respondsToSelector:@selector(AddressAddVCSelectedDelegate:)]) {
                        [self.delegate AddressAddVCSelectedDelegate:nil];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [[NSToastManager manager] showtoast:model.message];
                }
                self.isCanOperation = YES;
            }
            if ([operation.urlTag isEqualToString:Path_getProvince]) {
                AddressSelectedListModel *listModel = (AddressSelectedListModel *)parserObject;
                [self handleProvinceData:listModel.provinceList];
            }
            if ([operation.urlTag isEqualToString:Path_getCity]) {
                AddressSelectedListModel *listModel = (AddressSelectedListModel *)parserObject;
                [self handleCityData:listModel.cityList];
            }
            if ([operation.urlTag isEqualToString:Path_getDistricts]) {
                AddressSelectedListModel *listModel = (AddressSelectedListModel *)parserObject;
                [self handleDistrictsData:listModel.districtList];
            }
            if ([operation.urlTag isEqualToString:Path_getStreet]) {
                AddressSelectedListModel *listModel = (AddressSelectedListModel *)parserObject;
                [self handleStreetData:listModel.streetList];
            }
            
        }
    }
}

- (void)handleProvinceData:(NSArray *)dataArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (AddressSelectedModel *model in dataArr) {
        KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
        model_1.titleName = model.pvceName;
        model_1.ID = model.ID;
        [arr addObject:model_1];
    }
    if (arr.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
    }
    else
    {
        WEAKSELF
        [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
            weakSelf.dataModel.shipProvince = model.titleName;
            weakSelf.dataModel.shipProvinceID = model.ID;
            
            weakSelf.dataModel.shipCity = @"";
            weakSelf.dataModel.shipCityID = @"";
            weakSelf.dataModel.shipDistrict = @"";
            weakSelf.dataModel.shipDistrictID = @"";
            weakSelf.dataModel.shipStreet = @"";
            weakSelf.dataModel.shipStreetID = @"";
            [weakSelf.tableview reloadData];
        }];
    }
}


- (void)handleCityData:(NSArray *)dataArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (AddressSelectedModel *model in dataArr) {
        KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
        model_1.titleName = model.ctName;
        model_1.ID = model.ID;
        [arr addObject:model_1];
    }
    if (arr.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
    }
    else
    {
        WEAKSELF
        [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
            weakSelf.dataModel.shipCity = model.titleName;
            weakSelf.dataModel.shipCityID = model.ID;
            
            weakSelf.dataModel.shipDistrict = @"";
            weakSelf.dataModel.shipDistrictID = @"";
            weakSelf.dataModel.shipStreet = @"";
            weakSelf.dataModel.shipStreetID = @"";
            [weakSelf.tableview reloadData];
        }];
    }
}

- (void)handleDistrictsData:(NSArray *)dataArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (AddressSelectedModel *model in dataArr) {
        KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
        model_1.titleName = model.disName;
        model_1.ID = model.ID;
        [arr addObject:model_1];
    }
    if (arr.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
    }
    else
    {
        WEAKSELF
        [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
            weakSelf.dataModel.shipDistrict = model.titleName;
            weakSelf.dataModel.shipDistrictID = model.ID;
            
            weakSelf.dataModel.shipStreet = @"";
            weakSelf.dataModel.shipStreetID = @"";
            [weakSelf.tableview reloadData];
        }];
    }
}

- (void)handleStreetData:(NSArray *)dataArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (AddressSelectedModel *model in dataArr) {
        KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
        model_1.titleName = model.stName;
        model_1.ID = model.ID;
        [arr addObject:model_1];
    }
    if (arr.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"data_empty", nil)];
    }
    else
    {
        WEAKSELF
        [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
            weakSelf.dataModel.shipStreet = model.titleName;
            weakSelf.dataModel.shipStreetID = model.ID;
            [weakSelf.tableview reloadData];
        }];
    }
}



/**新增地址Api*/
- (void)httpPath_save_customerAddress
{
    if (self.dataModel.shipPerson.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_name", nil)];
        return;
    }
    //备注格式错误
    if ([Utils stringContainsEmoji:self.dataModel.shipPerson]) {
        [[NSToastManager manager] showtoast:@"请不要输入表情"];
        return;
    }
    if (self.dataModel.shipMobile.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"t_please_enter_phone_number", nil)];
        return;
    }
    if (![Utils checkTelNumber:self.dataModel.shipMobile]) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"t_incorrect_format_phone", nil)];
        return;
    }
    if (self.dataModel.shipProvinceID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_province", nil)];
        return;
    }
    if (self.dataModel.shipCityID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_city", nil)];
        return;
    }
    if (self.dataModel.shipDistrictID.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_district", nil)];
        return;
    }
//    if (self.dataModel.shipStreetID.length == 0) {
//        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_choose_street", nil)];
//        return;
//    }
    if (self.dataModel.shipAddress.length == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_input_detail_address", nil)];
        return;
    }
    //备注格式错误
    if ([Utils stringContainsEmoji:self.dataModel.shipAddress]) {
        [[NSToastManager manager] showtoast:@"请不要输入表情"];
        return;
    }
    if (!self.isCanOperation) {
        return;
    }
    self.isCanOperation = NO;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.dataModel.shipPerson forKey:@"shipPerson"];
    [parameters setValue:self.dataModel.shipMobile forKey:@"shipMobile"];
    [parameters setValue:self.dataModel.shipProvinceID forKey:@"shipProvince"];
    [parameters setValue:self.dataModel.shipCityID forKey:@"shipCity"];
    [parameters setValue:self.dataModel.shipDistrictID forKey:@"shipDistrict"];
    [parameters setValue:self.dataModel.shipStreetID forKey:@"shipStreet"];
    [parameters setValue:self.dataModel.shipAddress forKey:@"shipAddress"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_save_customerAddress;
}

/**获取省Api*/
- (void)httpPath_getProvince
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getProvince;
}

/**获取市Api*/
- (void)httpPath_getCity
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.dataModel.shipProvinceID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getCity;
}

/**获取区县Api*/
- (void)httpPath_getDistricts
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.dataModel.shipCityID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getDistricts;
}

/**获取街道Api*/
- (void)httpPath_getStreet
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.dataModel.shipDistrictID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getStreet;
}


#pragma mark -- Getter&Setter
- (KWCommonPickView *)kwPickView
{
    if (!_kwPickView) {
        _kwPickView = [[KWCommonPickView alloc] initWithType:1];
    }
    return _kwPickView;
}


- (AddressInfoModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[AddressInfoModel alloc] init];
    }
    return _dataModel;
}


@end
