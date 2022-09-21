//
//  SellGoodsScanVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/13.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SellGoodsScanVC.h"
#import "ZFMaskView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <ImageIO/ImageIO.h>
#import "SearchGoodsVC.h"
#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderPromotionTCell.h"
#import "CommonGoodsModel.h"
#import "SalesCounterVC.h"
#import "FDAlertView.h"

@interface SellGoodsScanVC ()<UITableViewDelegate, UITableViewDataSource, SearchGoodsVCDelegate,AVCaptureMetadataOutputObjectsDelegate, FDAlertViewDelegate, ZFMaskViewStartDelete>

/**扫描视图 高度*/
@property (nonatomic, assign) CGFloat scanViewHeight;

@property (nonatomic, strong) UITableView *tableview;

/** 遮罩层 */
@property (nonatomic, strong) ZFMaskView * maskView;

/** 展开按钮*/
@property (nonatomic, strong) UIButton * displayBtn;

/** 确认信息*/
@property (nonatomic, strong) NSDampButton * confirmBtn;

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;

/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;

/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

/**扫描视图 是否隐藏*/
@property (nonatomic, assign) BOOL isScanViewHidden;

/**删除商品临时位置变量*/
@property (nonatomic, assign) NSInteger tempDeleteIndex;

@property (nonatomic, assign) BOOL isControllerBack;

@property (nonatomic, copy) NSString *searchSKUCode;




@end

@implementation SellGoodsScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scanViewHeight = SCREEN_WIDTH * 0.67;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self capture];
    [self configBaseUI];
    [self configBaseData];
    
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    
}


#pragma mark -键盘监听方法
- (void)keyboardWillShown:(NSNotification *)notification
{
    if (self.isViewLoaded && self.view.window) {
        if (!self.isScanViewHidden) {
            self.isScanViewHidden = YES;
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.maskView stopToScanAction];
    [self.session stopRunning];
}

- (void)configBaseUI
{
//    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.view.backgroundColor = AppBgBlueGrayColor;
    if (self.controllerType == SellGoodsScanVCIntention) {
        self.title = NSLocalizedString(@"add_intent_goods", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"sale", nil);
    }
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateNormal];
    [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateSelected];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setImage:ImageNamed(@"s_search_icon") forState:UIControlStateNormal];
    [rightButton setImage:ImageNamed(@"s_search_icon") forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(searchbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.displayBtn];
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.confirmBtn];
    
    if (self.controllerType == SellGoodsScanVCSell) {
        [self.confirmBtn setTitle:NSLocalizedString(@"confirm_info", nil) forState:UIControlStateNormal];
    }
    else if (self.controllerType == SellGoodsScanVCIntention)
    {
        [self.confirmBtn setTitle:NSLocalizedString(@"confirm_add", nil) forState:UIControlStateNormal];
    }
}

- (void)configBaseData
{
    if(self.selectedDataArr.count > 0){
        [self SearchGoodsVCSelectedDelegate:_selectedDataArr];
    }
}

- (void)navLeftBarButtonClick
{
    if (self.controllerType == SellGoodsScanVCIntention) {
        BOOL isNeedSave = NO;
        if (self.dataList.count) {
            isNeedSave = YES;
        }
        if (isNeedSave) {
            self.isControllerBack = YES;
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"意向商品未保存，是否确认返回？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        BOOL isNeedSave = NO;
        if (self.dataList.count) {
            isNeedSave = YES;
        }
        if (isNeedSave) {
            self.isControllerBack = YES;
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"返回后，已添加商品则不再保留，确认返回吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}



#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.floorsAarr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataArr = self.floorsAarr[section];
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    return model.cellHeight;
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
    WEAKSELF
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell]) {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        BOOL isEditNumber = self.controllerType == SellGoodsScanVCSell ? YES:NO;
        [cell showDataWithCommonGoodsModelForSell:self.dataList[indexPath.section] AtIndex:indexPath.section WithIsEditNumberType:isEditNumber];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        cell.goodsDeleteBlock = ^(NSInteger atIndex) {
            weakSelf.tempDeleteIndex = atIndex;
            [weakSelf deleteGoodsTipsMethod];
        };
        return cell;
    }
    else if ([model.cellIdentify isEqualToString:KCommonSingleGoodsDarkTCell])
    {
        CommonGoodsModel *goodsModel = self.dataList[indexPath.section];
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithCommonProdutcModelForCommonSearch:goodsModel.productList[indexPath.row - 1]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return YES;
    }
    return NO;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    
    WEAKSELF
    if (@available(iOS 11.0, *)) {
        if (indexPath.row == 0)
        {
            UIContextualAction *deleteAction = [UIContextualAction  contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(@"c_delete", nil) handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                                {
                                                    [tableView setEditing:NO animated:NO];// 这句很重要，退出编辑模式，隐藏左滑菜单
                                                    weakSelf.tempDeleteIndex = indexPath.section;
                                                    [weakSelf deleteGoodsTipsMethod];
//                                                    [weakSelf handleGoodsDeleteActionWithAtIndex:indexPath.section];
                                                    /*这中间为代码删除的具体逻辑实现*/
//                                                    completionHandler(true);
                                                }];
            UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
            actions.performsFirstActionWithFullSwipe = NO;
            return actions;
        }
        else
        {
            [tableView setEditing:NO animated:NO];
        }
        return nil;
    }
    else
    {
        return nil;
    }
}

- (void)deleteGoodsTipsMethod
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:NSLocalizedString(@"is_delete_this_goods", nil) delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (self.isControllerBack) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            [self handleGoodsDeleteActionWithAtIndex:self.tempDeleteIndex];
        }
        else
        {
//            [self.tableview setEditing:NO animated:YES];
        }
    }
    
    self.isControllerBack = NO;
    
}

#pragma mark -- SearchGoodsVCDelegate
- (void)SearchGoodsVCSelectedDelegate:(id)goodsModel
{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:goodsModel];
    [self.floorsAarr removeAllObjects];
    for (id model in goodsModel) {
        [self handleTableViewFloorsData:model];
    }
    [self.tableview reloadData];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        [[NSToastManager manager] showtoast:metadataObject.stringValue];
        [self httpPath_selectProductWithSKUCode:metadataObject.stringValue];
    }
}

#pragma mark - ZFMaskViewStartDelete
- (void)ZFMaskViewStartScan
{
    [self.session startRunning];
}

- (void)searchbuttonClick
{
    SearchGoodsVC *searchGoodsVC = [[SearchGoodsVC alloc] init];
    searchGoodsVC.delegate = self;
    if (self.dataList.count) {
        searchGoodsVC.selectedDataArr = [self.dataList mutableCopy];
    }
    searchGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchGoodsVC animated:YES];
}


- (void)ConfirmBtnAction:(UIButton *)sender
{
    if (self.dataList.count == 0) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"please_add_goods", nil)];
        return;
    }
    if (self.controllerType == SellGoodsScanVCIntention) {
        [self AddIntentProductAction];
    }
    else
    {
        SalesCounterVC *salesCounterVC = [[SalesCounterVC alloc] init];
        salesCounterVC.dataArr = [self.dataList mutableCopy];
        salesCounterVC.customerId = self.customerId;
        salesCounterVC.type = SalesCounterTypeNone;
        salesCounterVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:salesCounterVC animated:YES];
    }
}

- (void)AddIntentProductAction
{
    NSMutableArray *productsArr = [[NSMutableArray alloc] init];
    for (CommonGoodsModel *singleModel in self.dataList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:singleModel.ID forKey:@"dealerProductId"];
        [dic setValue:[NSNumber numberWithBool:singleModel.isSetMeal] forKey:@"isSetMeal"];
        [productsArr addObject:dic];
    }
    [self httpPath_addIntentProduct:[productsArr copy]];
}

- (void)displayBtnAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.isScanViewHidden) {
        self.isScanViewHidden = NO;
    }
    else
    {
        self.isScanViewHidden = YES;
    }
}

- (void)handleGoodsDeleteActionWithAtIndex:(NSInteger)atIndex
{
    [self.dataList removeObjectAtIndex:atIndex];
    [self.floorsAarr removeObjectAtIndex:atIndex];
    [self.tableview reloadData];
}






#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_selectProduct]) {
            [self.session startRunning];
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_selectProduct]) {
                CommonGoodsListModel *listModel = (CommonGoodsListModel *)parserObject;
                if ([listModel.code isEqualToString:@"200"]) {
                    if (listModel.selectProducts.count > 1) {
                        SearchGoodsVC *searchGoodsVC = [[SearchGoodsVC alloc] init];
                        searchGoodsVC.delegate = self;
//                        searchGoodsVC.dataArr = [listModel.selectProducts mutableCopy];
                        searchGoodsVC.searchSKUCode = self.searchSKUCode;
                        if (self.dataList.count) {
                            searchGoodsVC.selectedDataArr = [self.dataList mutableCopy];
                        }
                        searchGoodsVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:searchGoodsVC animated:YES];
                    }
                    else if (listModel.selectProducts.count == 1)
                    {
                        [self handleGoodsNumberWithGoodsModel:listModel.selectProducts[0]];
                        [self.tableview reloadData];
                        [self.maskView stopToScanAction];
//                        [self.session startRunning];
                    }
                    else
                    {
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [self.tableview reloadData];
                        [self.maskView stopToScanAction];
//                        [self.session startRunning];
                    }
                }
                else
                {
                    [[NSToastManager manager] showtoast:listModel.message];
                    [self.session startRunning];
                }
            }
            if ([operation.urlTag isEqualToString:Path_addIntentProduct]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:model.message];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            
        }
    }
    
}

- (void)handleGoodsNumberWithGoodsModel:(CommonGoodsModel *)goodsModel
{
    //是否是新的商品 如果是新的商品就要新增cell模型
    BOOL isNewGoods = YES;
    for (CommonGoodsModel *singleModel in self.dataList) {
        if ([singleModel.ID isEqualToString:goodsModel.ID]) {
            if (self.controllerType == SellGoodsScanVCIntention) {
                [[NSToastManager manager] showtoast:NSLocalizedString(@"goods_added", nil)];
                isNewGoods = NO;
                break;
            }
            if (singleModel.isSpecial) {
//                卖货柜台多次扫描相同淋浴房时，初始化到最小销售单位，不加数量与平方
//                singleModel.kGoodsArea += [goodsModel.minNum floatValue];
                singleModel.kGoodsArea = [goodsModel.minNum floatValue];
                isNewGoods = YES;
            }
            else
            {
                singleModel.kGoodsCount += 1;
                isNewGoods = NO;
            }
            
            
            break;
        }
    }
    if (isNewGoods) {
        if (goodsModel.isSpecial) {
            goodsModel.kGoodsArea = [goodsModel.minNum floatValue];
            goodsModel.kGoodsCount = 1;
        }
        else
        {
            goodsModel.kGoodsCount = 1;
        }
        
        [self.dataList addObject:goodsModel];
        [self handleTableViewFloorsData:goodsModel];
    }
}

- (void)handleTableViewFloorsData:(CommonGoodsModel *)dataModel
{
    NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
    //当前商品的Cell
    CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
    if (!dataModel.isSetMeal) {
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellSingleH;
    }
    else
    {
        cellModel.cellIdentify = KCommonSingleGoodsTCell;
        cellModel.cellHeight = KCommonSingleGoodsTCellPackageH;
    }
    [sectionArr addObject:cellModel];
    
    [self.floorsAarr addObject:sectionArr];
}


- (void)handleGoodsShowOrHiddenDetailWith:(BOOL)isShow WithAtIndex:(NSInteger)atIndex
{
    NSMutableArray *sectionArr = self.floorsAarr[atIndex];
    CommonGoodsModel *goodsModel = self.dataList[atIndex];
    if (isShow) {
        for (CommonProdutcModel *model in goodsModel.productList) {
            CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
            cellModel.cellIdentify = KCommonSingleGoodsDarkTCell;
            cellModel.cellHeight = KCommonSingleGoodsDarkTCellH;
            [sectionArr addObject:cellModel];
        }
        goodsModel.isShowDetail = YES;
    }
    else
    {
        goodsModel.isShowDetail = NO;
        [sectionArr removeObjectsInRange:NSMakeRange(sectionArr.count - goodsModel.productList.count, goodsModel.productList.count)];
    }
    
    [UIView performWithoutAnimation:^{
        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:atIndex];
        [self.tableview reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

/**查询套餐或商品Api*/
- (void)httpPath_selectProductWithSKUCode:(NSString *)code
{
    self.searchSKUCode = code;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:code forKey:@"code"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue:@(1) forKey:@"pageNum"];
    [parameters setValue:@(10) forKey:@"pageSize"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_selectProduct;
}


/**添加意向商品Api*/
- (void)httpPath_addIntentProduct:(NSArray *)productsArr
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:productsArr forKey:@"intentProducts"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_addIntentProduct;
}

#pragma mark -- Getter&Setter

- (UITableView *)tableview
{
    if (!_tableview) {
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.scanViewHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - self.scanViewHeight - SCREEN_NavTop_Height - btnHeight - 50) style:UITableViewStyleGrouped];
        [_tableview setBackgroundColor:AppBgBlueGrayColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
        
    }
    return _tableview;
}

- (ZFMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[ZFMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scanViewHeight)];
        _maskView.delegate = self;
    }
    return _maskView;
}

- (UIButton *)displayBtn
{
    if (!_displayBtn) {
        _displayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_displayBtn setFrame:CGRectMake(0, self.scanViewHeight, SCREEN_WIDTH, 45)];
        [_displayBtn setBackgroundColor:AppBgWhiteColor];
        [_displayBtn setTitle:NSLocalizedString(@"up_area", nil) forState:UIControlStateNormal];
        [_displayBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        [_displayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
        [_displayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_displayBtn addTarget:self action:@selector(displayBtnAction:) forControlEvents:UIControlEventTouchDown];
        [_displayBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
        [_displayBtn setTitleColor:AppTitleBlackColor forState:UIControlStateNormal];
        _displayBtn.titleLabel.font = FONTLanTingR(14);
    }
    return _displayBtn;
}

- (NSDampButton *)confirmBtn
{
    if (!_confirmBtn) {
        CGFloat btnHeight = kIs_iPhoneX == true ? 55:45;
        _confirmBtn = [NSDampButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_NavTop_Height - btnHeight, SCREEN_WIDTH, btnHeight)];
        [_confirmBtn setBackgroundColor:AppBtnDeepBlueColor];
        _confirmBtn.titleLabel.font = FONTLanTingB(17);
        [_confirmBtn setTitle:NSLocalizedString(@"confirm_info", nil) forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(ConfirmBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}



- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}


/**
 *  扫描初始化
 */
- (void)capture{
//    return;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"t_no_camera_access", nil)];
        return ;
    } else {
        //获取摄像设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        //设置代理 在主线程里刷新
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc] init];
        //高质量采集率
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        
        [self.session addInput:input];
        [self.session addOutput:metadataOutput];
        
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scanViewHeight);
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.backgroundColor = [UIColor yellowColor].CGColor;
        [self.view.layer addSublayer:self.previewLayer];
        
        //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
        metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
        
        //开始捕获
//        [self.session startRunning];
    }
    
}

- (void)setIsScanViewHidden:(BOOL)isScanViewHidden
{
    _isScanViewHidden = isScanViewHidden;
    if (_isScanViewHidden) {
//        [self.session startRunning];
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scanViewHeight);
            self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scanViewHeight);
            self.displayBtn.frame = CGRectMake(0, self.scanViewHeight, SCREEN_WIDTH, 45);
            self.tableview.frame = CGRectMake(0, self.scanViewHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 50 - self.scanViewHeight);
        } completion:^(BOOL finished) {
            [self.displayBtn setImage:ImageNamed(@"s_up_pull_btn_icon") forState:UIControlStateNormal];
            [self.displayBtn setTitle:NSLocalizedString(@"up_area", nil) forState:UIControlStateNormal];
        }];
        
    }
    else
    {
        [self.maskView stopToScanAction];
        [self.session stopRunning];
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            self.displayBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
            self.tableview.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 50);
        } completion:^(BOOL finished) {
            [self.displayBtn setImage:ImageNamed(@"c_detail_down_icon") forState:UIControlStateNormal];
            [self.displayBtn setTitle:NSLocalizedString(@"down_area", nil) forState:UIControlStateNormal];
        }];
//        _isScanViewHidden = isScanViewHidden;
    }
}
//- (void)setSelectedDataArr:(NSMutableArray *)selectedDataArr
//{
//    _selectedDataArr = selectedDataArr;
////    for (CommonGoodsModel *model in _selectedDataArr) {
////        CommonGoodsModel *copyModel = [model copy];
////        copyModel.isShowDetail = NO;
////        [self.dataList addObject:copyModel];
////
////    }
//    self.isScanViewHidden = NO;
//    [self SearchGoodsVCSelectedDelegate:_selectedDataArr];
//}

@end
