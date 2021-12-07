//
//  YFMPaymentView.m
//  YFMBottomPayView
//
//  Created by YFM on 2018/8/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YFMPaymentView.h"

#import "CommonSingleGoodsTCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "FDAlertView.h"
#import <Masonry.h>

@interface YFMPaymentView ()<UITableViewDelegate,UITableViewDataSource,FDAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic ,strong) NSMutableArray *floorsAarr;
/**删除商品临时位置变量*/
@property (nonatomic, assign) NSInteger tempDeleteIndex;

@property (nonatomic ,strong) UITableView *tableView;
//@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *shoppingCarView;

@property (nonatomic, strong) UIButton *shoppingCarBtn;

@property (nonatomic, strong) UILabel *shoppingCarNumberLab;

@property (nonatomic, strong) UIButton *shoppingCarConfirmBtn;

@property (nonatomic, assign) NSInteger alertType;

@end

@implementation YFMPaymentView
- (instancetype)initDataSource:(NSMutableArray *)dataSource FloorArr:(NSMutableArray *)floorArr{
    if (self = [super init]) {
        self.dataList = dataSource;
        self.floorsAarr = floorArr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.currentIndex = 0;
    [self initPop];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self updateShoppingCarStatus];
}

- (void)initPop {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = SCREEN_HEIGHT - 200;
    if (KWIs_iPhoneX) {
        height = SCREEN_HEIGHT - 300;
    }
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, height);
    self.popupController.navigationBarHidden = YES;
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
}

- (void)setUpUI {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headerView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15,10,100,25);
    label.text = @"已选商品";
    label.textColor = UIColor.blackColor;
    label.font = FONTLanTingR(17);
    label.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:label];
    
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setImage:[UIImage imageNamed:@"s_trash_icon"] forState:UIControlStateNormal];
    [xButton setTitle:@"清空" forState:UIControlStateNormal];
    [xButton setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
    xButton.frame = CGRectMake(SCREEN_WIDTH - 90, 9, 80, 30);
    [headerView addSubview:xButton];
    [xButton addTarget:self action:@selector(clearShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shoppingCarView];
}

-(void)closeBlockView {
    [self backgroundTap];
}

- (void)backgroundTap  {
    [self.popupController dismiss];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    NSMutableArray *dataArr = self.floorsAarr[indexPath.section];
    CommonTVDataModel *model = dataArr[indexPath.row];
    
    if ([model.cellIdentify isEqualToString:KCommonSingleGoodsTCell]) {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithCommonGoodsModelForSell:self.dataList[indexPath.section] AtIndex:indexPath.section WithIsEditNumberType:YES];
        cell.goodsShowDetailBlock = ^(BOOL isShow, NSInteger atIndex) {
            [weakSelf handleGoodsShowOrHiddenDetailWith:isShow WithAtIndex:atIndex];
        };
        cell.goodsDeleteBlock = ^(NSInteger atIndex) {
            weakSelf.tempDeleteIndex = atIndex;
            [weakSelf deleteGoodsTipsMethod];
        };
        cell.goodsNumberChangeBlock = ^{
            [weakSelf updateShoppingCarStatus];
            if (weakSelf.dateChangeActionBlock) {
                weakSelf.dateChangeActionBlock();
            }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.currentIndex = indexPath.row;
//    [self.tableView reloadData];
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
    self.alertType = 0;
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);

    if (self.alertType == 0) {
        if (buttonIndex == 1) {
            [self handleGoodsDeleteActionWithAtIndex:self.tempDeleteIndex];
        }
        else
        {
        }
    }
    else
    {
        if (buttonIndex == 1) {
           [self.dataList removeAllObjects];
            [self.floorsAarr removeAllObjects];
            [self.tableView reloadData];
            [self updateShoppingCarStatus];
            if (self.dateChangeActionBlock) {
                self.dateChangeActionBlock();
            }
        }
        else
        {
        }
        
    }
        

    
}

- (void)handleGoodsDeleteActionWithAtIndex:(NSInteger)atIndex
{
    [self.dataList removeObjectAtIndex:atIndex];
    [self.floorsAarr removeObjectAtIndex:atIndex];
    [self.tableView reloadData];
    [self updateShoppingCarStatus];
    
}

//根据数据模型生成楼层数据
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
        [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}


#pragma mark -- 清空购物车操作
- (void)clearShoppingCar
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:NSLocalizedString(@"is_delete_shopping_car", nil) delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
    self.alertType = 1;
    
}

#pragma mark -- 更新购物车状态
- (void)updateShoppingCarStatus
{
    if (self.dataList.count) {
        NSInteger goodsCount = 0;
        for (CommonGoodsModel *singleModel in self.dataList) {
            goodsCount += singleModel.kGoodsCount;
        }
        self.shoppingCarNumberLab.hidden = NO;
//        self.shoppingCarNumberLab.text = [NSString stringWithFormat:@"%ld",goodsCount];
        if (goodsCount > 99) {
            self.shoppingCarNumberLab.text = @"99+";
            self.shoppingCarNumberLab.sd_width = 30;
        }
        else
        {
            self.shoppingCarNumberLab.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
            self.shoppingCarNumberLab.sd_width = 18;
        }
        [self.shoppingCarConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setBackgroundColor:AppBtnDeepBlueColor];
        [self.shoppingCarConfirmBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
    }
    else
    {
        self.shoppingCarNumberLab.hidden = YES;
        self.shoppingCarNumberLab.text = @"0";
        [self.shoppingCarConfirmBtn setTitle:@"未选择商品" forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [self.shoppingCarConfirmBtn setBackgroundColor:AppBgShoppingCarColor];
    }
}


#pragma mark -- 确认购物车操作
- (void)confirmAction
{
    [self closeBlockView];
    if (self.dateConfirmActionBlock) {
        self.dateConfirmActionBlock();
    }
}



- (UIView *)shoppingCarView
{
    if (!_shoppingCarView) {
        _shoppingCarView = [[UIView alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height - 70, SCREEN_WIDTH - 30, 50)];
        _shoppingCarView.backgroundColor = AppBgShoppingCarColor;
        _shoppingCarView.clipsToBounds = YES;
        _shoppingCarView.layer.cornerRadius = 25;
        
        UIButton *shoppingCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        [shoppingCarBtn setImage:ImageNamed(@"s_shoppingcar_deep_icon") forState:UIControlStateNormal];
        [shoppingCarBtn addTarget:self action:@selector(closeBlockView) forControlEvents:UIControlEventTouchDown];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 18, 18)];
        numberLab.text = @"0";
        numberLab.hidden = YES;
        numberLab.textColor = AppTitleWhiteColor;
        numberLab.font = FONTSYS(12);
        numberLab.backgroundColor = AppTitleGoldenColor;
        numberLab.clipsToBounds = YES;
        numberLab.layer.cornerRadius = 9;
        numberLab.textAlignment = NSTextAlignmentCenter;
        self.shoppingCarNumberLab = numberLab;
        [shoppingCarBtn addSubview:numberLab];
        
        
        [_shoppingCarView addSubview:shoppingCarBtn];
        
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(_shoppingCarView.sd_width - 125, 0, 125, 50)];
        confirmBtn.titleLabel.font = FontBinB(15);
        [confirmBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [confirmBtn setTitle:@"未选择商品" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchDown];
        self.shoppingCarConfirmBtn = confirmBtn;
        [_shoppingCarView addSubview:confirmBtn];
        
    }
    return _shoppingCarView;
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

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, self.view.frame.size.height - 125) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = AppBgBlueGrayColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
