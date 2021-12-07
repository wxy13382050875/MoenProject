//
//  SamplingInputVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingInputVC.h"
#import "SamplingInputTCell.h"
#import "SamplingSingleModel.h"
#import "FDAlertView.h"

@interface SamplingInputVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_Bottom;

@property (weak, nonatomic) IBOutlet UIButton *submit_Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtnHeight;


@property (nonatomic, strong) NSMutableArray *firstArr;

@property (nonatomic, strong) NSMutableArray *secondArr;


@property (nonatomic, strong) NSMutableArray *firstArrCompare;

@property (nonatomic, strong) NSMutableArray *secondArrCompare;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, assign) BOOL isJudge;

@property (nonatomic, assign) BOOL isEditStatus;

@end

@implementation SamplingInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
//    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"sampling_info", nil);
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateNormal];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateSelected];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    [rightButton setTitle:NSLocalizedString(@"c_edit", nil) forState:UIControlStateNormal];
    [rightButton setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONTSYS(17);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = rightButton;
    [self.editBtn setHidden:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    
    CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
    self.submitBtnHeight.constant = btnHeight;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
    
    [self handleViewEditStatus];
}


- (void)configBaseData
{
    [self httpPath_getProductSample];
    
}
- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_getProductSample];
}

- (void)navLeftBarButtonClick
{
    BOOL isDefferent = false;
    for (int i = 0; i < self.firstArr.count; i++) {
        SamplingSingleModel *firstModel = self.firstArr[i];
        SamplingSingleModel *secondModel = self.firstArrCompare[i];
        if (firstModel.sampleQuantity != secondModel.sampleQuantity) {
            isDefferent = YES;
            break;
        }
    }
    if (isDefferent) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"出样数量未保存，是否确认返回？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
        return;
    }
    for (int i = 0; i < self.secondArr.count; i++) {
        SamplingSingleModel *firstModel = self.secondArr[i];
        SamplingSingleModel *secondModel = self.secondArrCompare[i];
        if (firstModel.sampleQuantity != secondModel.sampleQuantity) {
            isDefferent = YES;
            break;
        }
    }
    if (isDefferent) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"出样数量未保存，是否确认返回？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.firstArr.count > 0) {
        return 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.firstArr.count;
    }
    else if (section == 1)
    {
        return self.secondArr.count;
    }
    return 0;
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
    if (indexPath.section == 0) {
        [cell showDataWithSamplingSingleModel:self.firstArr[indexPath.row] WithEditStatus:self.isEditStatus];
    }
    else
    {
        [cell showDataWithSamplingSingleModel:self.secondArr[indexPath.row] WithEditStatus:self.isEditStatus];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
    headerView.backgroundColor = AppBgBlueColor;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 36)];
    titleLab.font = FONTLanTingR(14);
    titleLab.textColor = AppTitleBlackColor;
    if (section == 0) {
        titleLab.text = @"出样信息";
    }
    else
    {
        titleLab.text = @"试水台信息";
    }
    [headerView addSubview:titleLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}




- (void)editAction:(UIButton *)sender
{
    if (self.isEditStatus) {
        self.isEditStatus = NO;
        [self httpPath_getProductSample];
    }
    else
    {
        self.isEditStatus = YES;
    }
    
    [self handleViewEditStatus];
    [self.tableview reloadData];
}
- (IBAction)SubmitAction:(UIButton *)sender {
    [self httpPath_updateProductSample];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getProductSample]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getProductSample]) {
                SamplingListModel *listModel = (SamplingListModel *)parserObject;
                if ([listModel.code isEqualToString:@"200"]) {
                    if (!listModel.judge) {
                        self.isEditStatus = YES;
                        [self handleViewEditStatus];
                    }
                    [weakSelf handleSectionDataWithArr:listModel.sampleSingleDataList];
                    [weakSelf.tableview reloadData];
                    if (listModel.sampleSingleDataList.count == 0) {
                        [self.editBtn setHidden:YES];
                        [self.submit_Btn setHidden:YES];
                        self.tableview_Bottom.constant = 0;
                         self.isShowEmptyData = YES;
                        
                    }
                    else
                    {
                         self.isShowEmptyData = NO;
                    }
                }
                else
                {
                    [self.editBtn setHidden:YES];
                    [self.submit_Btn setHidden:YES];
                    self.tableview_Bottom.constant = 0;
                    self.isShowEmptyData = YES;
                    
                    [[NSToastManager manager] showtoast:listModel.message];
                }
            }
            
            if ([operation.urlTag isEqualToString:Path_updateProductSample]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"submit_success", nil)];
                    self.isEditStatus = NO;
                    [self handleViewEditStatus];
                    [self httpPath_getProductSample];
                    
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            
        }
    }
}

- (void)handleViewEditStatus
{
    if (self.isEditStatus) {
        [self.editBtn setHidden:NO];
        [self.editBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.submit_Btn setHidden:NO];
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        self.tableview_Bottom.constant = btnHeight;
    }
    else
    {
        [self.editBtn setHidden:NO];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.submit_Btn setHidden:YES];
        self.tableview_Bottom.constant = 0;
    }
}

- (void)handleSectionDataWithArr:(NSArray<SamplingSingleModel *> *)dataList
{
    [self.firstArr removeAllObjects];
    [self.secondArr removeAllObjects];
    
    [self.firstArrCompare removeAllObjects];
    [self.secondArrCompare removeAllObjects];
    
    for (SamplingSingleModel *model in dataList) {
        if ([model.sampleType isEqualToString:@"出样信息"]) {
            [self.firstArr addObject:model];
            
            [self.firstArrCompare addObject:[model copy]];
        }
        else
        {
            [self.secondArr addObject:model];
            [self.secondArrCompare addObject:[model copy]];
        }
    }
}

/**商品出样填报详情Api*/
- (void)httpPath_getProductSample
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_getProductSample;
}


/**修改商品出样填报数量Api*/
- (void)httpPath_updateProductSample
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (SamplingSingleModel *model in self.firstArr) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(model.sampleId) forKey:@"sampleId"];
        [dic setValue:@(model.sampleQuantity) forKey:@"sampleQuantity"];
        [dataArr addObject:dic];
    }
    for (SamplingSingleModel *model in self.secondArr) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@(model.sampleId) forKey:@"sampleId"];
        [dic setValue:@(model.sampleQuantity) forKey:@"sampleQuantity"];
        [dataArr addObject:dic];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:dataArr forKey:@"productSampleData"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_updateProductSample;
}


#pragma mark -- Getter&Setter

- (NSMutableArray *)firstArr
{
    if (!_firstArr) {
        _firstArr = [[NSMutableArray alloc] init];
    }
    return _firstArr;
}

- (NSMutableArray *)secondArr
{
    if (!_secondArr) {
        _secondArr = [[NSMutableArray alloc] init];
    }
    return _secondArr;
}

- (NSMutableArray *)firstArrCompare
{
    if (!_firstArrCompare) {
        _firstArrCompare = [[NSMutableArray alloc] init];
    }
    return _firstArrCompare;
}

- (NSMutableArray *)secondArrCompare
{
    if (!_secondArrCompare) {
        _secondArrCompare = [[NSMutableArray alloc] init];
    }
    return _secondArrCompare;
}



@end
