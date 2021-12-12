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
    [self xw_layoutNavigation];
    [self xw_loadDataSource];
}
-(void)xw_layoutNavigation{
    self.title = @"选择发货信息";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.orderProductInfoDataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    xwDeliveryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([xwDeliveryInfoCell class])];
//    [cell showDataWithOrderManageModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if(indexPath.row % 2 == 0){
//        cell.deliveryType = DeliveryActionTypeFirst;
//    } else {
//        cell.deliveryType = DeliveryActionTypeOther;
//    }
    cell.controllerType = self.controllerType;
    cell.model = self.model.orderProductInfoDataList[indexPath.row];
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KXwDeliveryInfoCellH;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
//    footer.backgroundColor = [UIColor whiteColor];
//    UILabel* appointmentlab = [UILabel labelWithText:@"预约发货时间" WithTextColor:AppTitleGoldenColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentRight WithFont:15];
//    UILabel* warehouselab = [UILabel labelWithText:@"总仓发货时间" WithTextColor:AppTitleGoldenColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentRight WithFont:15];
//    [footer addSubview:appointmentlab];
//    appointmentlab.sd_layout.leftSpaceToView(footer, 10).topSpaceToView(footer, 5).widthIs(100).heightIs(30);
//    [footer addSubview:self.startTime];
//    self.startTime.sd_layout.leftSpaceToView(appointmentlab, 10).topSpaceToView(footer, 5).rightSpaceToView(footer, 10).heightIs(30);
//
//    [footer addSubview:warehouselab];
//    warehouselab.sd_layout.leftSpaceToView(footer, 10).topSpaceToView(appointmentlab, 5).widthIs(100).heightIs(30);
//    [footer addSubview:self.endTime];
//    self.endTime.sd_layout.leftSpaceToView(warehouselab, 10).topSpaceToView(appointmentlab, 5).rightSpaceToView(footer, 10).heightIs(30);
//
//    UITextView *textview = [UITextView new];
//    textview.backgroundColor=[UIColor whiteColor]; //设置背景色
//        textview.scrollEnabled = NO;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
//        textview.editable = YES;        //设置是否允许编辑内容，默认为“YES”
////        textview.delegate = self;       //设置代理方法的实现类
//        textview.font=[UIFont fontWithName:@"Arial" size:12.0]; //设置字体名字和字体大小;
//        textview.returnKeyType = UIReturnKeyDefault;//设置return键的类型
//        textview.keyboardType = UIKeyboardTypeDefault;//设置键盘类型一般为默认
//        textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
//        textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
//        textview.textColor = [UIColor blackColor];// 设置显示文字颜色
//        textview.text = @"UITextView详解";//设置显示的文本内容
//
//    [footer addSubview:textview];
//    ViewBorderRadius(textview, 3, 1, AppBgBlueGrayColor)
//    textview.sd_layout.leftSpaceToView(footer, 10).topSpaceToView(warehouselab, 5).rightSpaceToView(footer, 10).heightIs(45);
//    return footer;
//}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [UIView new];
        kRegistCell(_tableView,@"xwDeliveryInfoCell",@"xwDeliveryInfoCell")
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
            
          
            
            
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:@"确认要提交自提商品吗？确认后，商品自动门店出库" block:^(NSInteger buttonIndex, NSString *inputStr) {
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
        if(model.inputCount > 0){
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:model.goodsSKU forKey:@"goodsSKU"];
            if(self.controllerType == DeliveryWayTypeStocker ){
                [dict setObject:model.inputCount forKey:@"appointmentNum"];
            } else {
                [dict setObject:model.inputCount forKey:@"selfNum"];
            }
            [array addObject:dict];
        }
        
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(array.count > 0) {
        [parameters setValue:array forKey:@"confirmSendProductList"];
    } else {
        [[NSToastManager manager] showtoast:@"请输入数量"];
        return;
    }
    
    [parameters setValue:self.orderID forKey:@"orderID"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_confirmSend;
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
                    [self.tableView reloadData];
                } else if ([operation.urlTag isEqualToString:Path_stores_confirmSend]) {
                    OrderManageVC *orderManageVC = [[OrderManageVC alloc] init];
                    orderManageVC.isIdentifion = YES;
                    orderManageVC.customerId = [QZLUserConfig sharedInstance].customerId;
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
@end
