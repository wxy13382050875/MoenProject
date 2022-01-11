//
//  xw_DeliveryInfoVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_DeliveryInfoVC.h"
#import "xw_StoreOrderViewModel.h"
#import "XwUpdateDeliveryModel.h"
#import "OrderManageVC.h"
#import "XwSystemTCellModel.h"
#import "XWOrderDetailDefaultCell.h"
#import "SellGoodsOrderMarkTCell.h"
@interface xw_DeliveryInfoVC ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBth;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) xw_StoreOrderViewModel *viewModel;
@property (nonatomic, strong) XwUpdateDeliveryModel *model;

@property (nonatomic, strong) UIDatePicker *dataStartPicker;

@property (nonatomic, strong) UIDatePicker *dataEndPicker;
@property (nonatomic, strong)  UITextField *startTime;

@property (nonatomic, strong)  UITextField *endTime;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) NSString *sendGoodsDate;

@property (nonatomic, strong) NSString *orderRemarks;

@end

@implementation xw_DeliveryInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    [self xw_setupUI];
    [self xw_bindViewModel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    if (marr.count > 1) {
//        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
//        if ([vc isKindOfClass:[OrderManageVC class]]) {
//            [marr removeObject:vc];
//        }
//        self.navigationController.viewControllers = marr;
//    }
    [self xw_layoutNavigation];
    [self xw_loadDataSource];
}
-(void)xw_layoutNavigation{
    if(self.controllerType == DeliveryWayTypeStocker){
        self.title = @"选择总仓商品";
    } else {
        self.title = @"选择发货商品";
        
    }
    self.sendGoodsDate =@"";
    
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0)) ;
    [self.view addSubview:self.confirmBth];
    self.confirmBth.sd_layout
    .leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
}
-(void)xw_loadDataSource{
    
    
//    kSetMJRefresh(self.tableView);
    [self httpPath_stores_getOrderProductInfo];
    
}
//-(void)xw_loadNewData{
//
////    [self.dataSource removeAllObjects];
////    self.page = 1;
////    [self getData];
//}
//-(void)xw_loadMoreData{
//    if ([self.tableView.mj_header isRefreshing]) {
//        return;
//    }
////    self.page ++;
//    [self getData];
//}
//-(void)getData{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
//
////            [[self.viewModel.requestCommand execute: nil] subscribeNext:^(id x) {;
////                [self.tableView.mj_header endRefreshing];
////
//////                if (array.count < 10) {
//////
//////                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//////                }
//////                [self.dataSource addObjectsFromArray:array];
//////                [self.tableView reloadData];
////
////            } error:^(NSError *error) {
//////                Dialog().wTypeSet(DialogTypeAuto).wMessageSet(error.localizedDescription).wDisappelSecondSet(1).wStart();
////                [self.tableView.mj_header endRefreshing];
////            }];
//    //
//        });
//}

-(void)xw_bindViewModel{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.floorsAarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    
    
    if ([model.cellIdentify isEqualToString:@"xwDeliveryInfoCell"]){
        xwDeliveryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([xwDeliveryInfoCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.controllerType = self.controllerType;
        cell.model = model.Data;
        return cell;
    } else if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        
        
        XWOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWOrderDetailDefaultCell" forIndexPath:indexPath];
//        XwSystemTCellModel* tmModel = model.Data;
        XwSystemTCellModel* tmModel = model.Data;
        tmModel.value = self.sendGoodsDate;
        cell.model = tmModel;
        return cell;
    } else if ([model.cellIdentify isEqualToString:KSellGoodsOrderMarkTCell])
    {
        SellGoodsOrderMarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellGoodsOrderMarkTCell" forIndexPath:indexPath];
        UITextView* textview = (UITextView*)[self.view viewWithTag:1001];
        [textview xw_addPlaceHolder:@"添加备注"];
//        cell.defModel = model.Data;
        cell.orderMarkBlock = ^(NSString *text) {
            self.orderRemarks = text;
        };
        
        return cell;
    }
    return nil;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    return model.cellHeight;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    if ([model.cellIdentify isEqualToString:@"XWOrderDetailDefaultCell"]){
        XwSystemTCellModel* tm = model.Data;
        if([tm.type isEqualToString:@"select"]){
            Dialog()
                .wEventOKFinishSet(^(id anyID, id otherData) {
                    NSLog(@"选中 %@ %@",anyID,otherData);
                    self.sendGoodsDate =[NSString stringWithFormat:@"%@-%@-%@",anyID[0],anyID[1],anyID[2]];
                    [self.tableView reloadData];
                })
                .wDateTimeTypeSet(@"yyyy年MM月dd日")
                .wDefaultDateSet([NSDate date])
                .wTypeSet(DialogTypeDatePicker)
                .wStart();
            
        }
    }
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [UIView new];
        kRegistCell(_tableView,@"xwDeliveryInfoCell",@"xwDeliveryInfoCell")
//        kRegistCell(_tableView,@"XWOrderDetailDefaultCell",@"XWOrderDetailDefaultCell")
        [_tableView registerClass:[XWOrderDetailDefaultCell class] forCellReuseIdentifier:@"XWOrderDetailDefaultCell"];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SellGoodsOrderMarkTCell" bundle:nil] forCellReuseIdentifier:@"SellGoodsOrderMarkTCell"];
    }
    return _tableView;
}
-(xw_StoreOrderViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[xw_StoreOrderViewModel alloc] init];
    }
    return _viewModel;
}
//-(NSMutableArray*)dataSource{
// 
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray new];
//    }
//    return _dataSource;
//}
- (UIDatePicker *)dataStartPicker
{
    if (!_dataStartPicker) {
        _dataStartPicker = [[UIDatePicker alloc] init];
        //设置地区: zh-中国
        _dataStartPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _dataStartPicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_dataStartPicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_dataStartPicker setMaximumDate:[NSDate date]];
        
        //设置时间格式
        //监听DataPicker的滚动
        [_dataStartPicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _dataStartPicker;
}

- (UIDatePicker *)dataEndPicker
{
    if (!_dataEndPicker) {
        _dataEndPicker = [[UIDatePicker alloc] init];
        //设置地区: zh-中国
        _dataEndPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _dataEndPicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_dataEndPicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_dataEndPicker setMaximumDate:[NSDate date]];
        
        //设置时间格式
        //监听DataPicker的滚动
        [_dataEndPicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _dataEndPicker;
}
- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    if (datePicker == self.dataStartPicker) {
        self.startTime.text = dateStr;
    }
    else
    {
        self.endTime.text = dateStr;
    }
    
//    self.timeTextField.text = dateStr;
}
#pragma Mark- getters and setters
- (UITextField *)startTime
{
    if (!_startTime) {
        _startTime = [[UITextField alloc] init];
//        _startTime.text = @"2018/10/01";
        _startTime.textColor = AppTitleGoldenColor;
        _startTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _startTime.delegate = self;
        _startTime.inputView = self.dataStartPicker;
        ViewBorderRadius(_startTime, 3, 1, AppBgBlueGrayColor)
    }
    return _startTime;
}


- (UITextField *)endTime
{
    if (!_endTime) {
        _endTime = [[UITextField alloc] init];
//        _endTime.text = @"2018/10/10";
        _endTime.textColor = AppTitleGoldenColor;
        _endTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _endTime.delegate = self;
        _endTime.inputView = self.dataEndPicker;
        ViewBorderRadius(_endTime, 3, 1, AppBgBlueGrayColor)
    }
    return _endTime;
}
//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.inputView isKindOfClass:NSClassFromString(@"UIDatePicker")]) {
        UIDatePicker *datePick = (UIDatePicker *)textField.inputView;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:datePick.date];
        textField.text = dateStr;
    }
}
-(UIButton*)confirmBth{
    if(!_confirmBth){
        _confirmBth = [UIButton buttonWithTitie:@"确认" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"确认");
            
            NSString* message ;
            if(self.controllerType == DeliveryWayTypeStocker){
                message = @"确认要提交总仓任务吗?确认后，任务提交至AD进行后续发货";
            } else {
                message = @"确认要提交自提商品吗？确认后，商品自动门店出库";
                
            }
            
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:message block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    [self httpPath_stores_confirmSend];
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
        }];
        
    }
    return  _confirmBth;
}
//库存参考信息
-(void)httpPath_stores_getOrderProductInfo{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_getOrderProductInfo;
}
-(void)httpPath_stores_confirmSend{
    
    NSMutableArray* array = [NSMutableArray array];
    for (Orderproductinfodatalist* model in self.model.orderProductInfoDataList) {
        if([model.inputCount integerValue]> 0){
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:model.goodsSKU forKey:@"goodsSKU"];
            if(self.controllerType == DeliveryWayTypeStocker ){
                [dict setObject:model.inputCount forKey:@"appointmentNum"];
            } else {
                [dict setObject:model.inputCount forKey:@"selfNum"];
            }
            [dict setObject:model.setMealId!=nil ? model.setMealId:@"" forKey:@"setMealId"];
            [dict setObject:model.type forKey:@"type"];
            
            [array addObject:dict];
        }
        
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(array.count > 0) {
        
//        if(self.controllerType == DeliveryWayTypeStocker ){
//            if([self.sendGoodsDate isEqualToString:@""]|| self.sendGoodsDate == nil){
//                [[NSToastManager manager] showtoast:@"请选择期望收货时间"];
//                return;
//            }
//
//        }
        [parameters setValue:array forKey:@"confirmSendProductList"];
        [parameters setObject:self.sendGoodsDate forKey:@"sendGoodsDate"];
        [parameters setValue:self.orderID forKey:@"orderID"];
        [parameters setValue:self.orderRemarks forKey:@"remarks"];
        
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        self.requestType = NO;
        self.requestParams = parameters;
        [[NSToastManager manager] showprogress];
    //
        self.requestURL = Path_stores_confirmSend;
    } else {
        
        
        if(self.controllerType == DeliveryWayTypeStocker){
            [[NSToastManager manager] showtoast:@"请输入总仓发货数量"];
        } else {
            [[NSToastManager manager] showtoast:@"请输入自提数量"];
            
        }
        return;
    }
    
    
}
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
//    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_stores_getOrderProductInfo]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([parserObject.code isEqualToString:@"200"]) {
                if ([operation.urlTag isEqualToString:Path_stores_getOrderProductInfo]) {
                    self.model = [XwUpdateDeliveryModel mj_objectWithKeyValues:parserObject.datas[@"orderProductData"]];
                    [self.floorsAarr removeAllObjects];
                    [self handleTableViewFloorsData];
                    
                    if(self.controllerType != DeliveryWayTypeShopSelf){
                        [self handleTabWishReceivekData];
                        [self handleTabMarkData];
                    }
                    
                    [self.tableView reloadData];
                } else if ([operation.urlTag isEqualToString:Path_stores_confirmSend]) {
                    OrderManageVC *orderManageVC = [[OrderManageVC alloc] init];
                    orderManageVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderManageVC animated:YES];
                }
                
            }
            else
            {
                self.isShowEmptyData = YES;
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}

- (void)handleTableViewFloorsData
{
    
    
    for (XwUpdateDeliveryModel *model in self.model.orderProductInfoDataList) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = @"xwDeliveryInfoCell";
        cellModel.cellHeight = KXwDeliveryInfoCellH;
        cellModel.cellHeaderHeight = 0.01;
        cellModel.cellFooterHeight =  0.01;
        cellModel.Data = model;
        [sectionArr addObject:cellModel];
        
        [self.floorsAarr addObject:sectionArr];
    }
    
}
//期望收货时间
-(void)handleTabWishReceivekData{
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
    tmModel.title =@"期望收货时间";
    tmModel.value =@"请填写";
    tmModel.type =@"select";
    tmModel.showArrow = YES;
    NSMutableArray *section4Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *delivereModel = [[CommonTVDataModel alloc] init];
    delivereModel.cellIdentify = @"XWOrderDetailDefaultCell";
    delivereModel.cellHeight = 30;
    delivereModel.cellHeaderHeight = 0.01;
    delivereModel.cellFooterHeight =  5;
    delivereModel.Data = tmModel;
    [section4Arr addObject:delivereModel];
    [self.floorsAarr addObject:section4Arr];
}
//备注
-(void)handleTabMarkData{
    
//    if(self.orderRemarks.length > 0){
//        CGFloat height = [UITextView hig]
//    }
    
//    CGSize size = [[NSString stringWithFormat:@"审核备注:%@",self.orderRemarks] sizeWithFont:FONT(14) Size:CGSizeMake((SCREEN_WIDTH -30 -16), 2000)];
//    CGFloat height = 80;
//    if(size.height  > 80){
//        height  = size.height + 40;
//    }
//    NSString * msg = @"备注：";
    
    
    XwSystemTCellModel* tmModel = [XwSystemTCellModel new];
//    tmModel.value =[self.orderRemarks isEqualToString:@""]?[NSString stringWithFormat:@"%@无",msg]:[NSString stringWithFormat:@"%@:%@",msg,self.orderRemarks];;
    tmModel.isEdit = YES;
    
    NSMutableArray *section6Arr = [[NSMutableArray alloc] init];
    CommonTVDataModel *markCellModel = [[CommonTVDataModel alloc] init];
    markCellModel.cellIdentify = KSellGoodsOrderMarkTCell;
    markCellModel.cellHeight = 80;
    markCellModel.cellHeaderHeight = 0.01;
    markCellModel.cellFooterHeight = 5;
    markCellModel.Data =tmModel;
    [section6Arr addObject:markCellModel];
    [self.floorsAarr addObject:section6Arr];
}
#pragma mark -- Getter&Setter
- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}
@end
