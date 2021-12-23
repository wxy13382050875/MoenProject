//
//  XwSubscribeTakeVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/12.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwSubscribeTakeVC.h"
#import "OrderManageVC.h"
@interface XwSubscribeTakeVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIDatePicker *dataPicker;

@property (nonatomic, strong) UITextField *startTime;

@property (nonatomic, strong) UITextView* textView;

@property (nonatomic, strong) UIButton* submitBtn;
@end

@implementation XwSubscribeTakeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"填写预约自提信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configBaseUI];
    [self configBaseData];
}
-(void)configBaseUI{
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.startTime];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitBtn];
    
    self.dateLabel.sd_layout.leftSpaceToView(self.view, 10).topEqualToView(self.view).widthIs(100).heightIs(40);
    self.startTime.sd_layout.rightSpaceToView(self.view, 10).topSpaceToView(self.view, 5).leftSpaceToView(self.dateLabel, 0).heightIs(30);
    
    self.textView.sd_layout.topSpaceToView(self.dateLabel, 5).leftSpaceToView(self.view, 10).rightSpaceToView(self.view, 10).heightIs(120);
    self.submitBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
}
-(void)configBaseData{
    [self httpPath_stores_selfInfo];
}
//订单预约自提信息
-(void)httpPath_stores_selfInfo{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_selfInfo;
}
//预约自提确认保存
-(void)httpPath_stores_selfSave{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue:self.textView.text forKey:@"remarks"];
    [parameters setValue:self.startTime.text forKey:@"appointmentDate"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_selfSave;
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
                if ([operation.urlTag isEqualToString:Path_stores_selfInfo]) {
                    self.textView.text = parserObject.datas[@"remarks"];
                    self.startTime.text = parserObject.datas[@"appointmentDate"];
                } else if ([operation.urlTag isEqualToString:Path_stores_selfSave]) {

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
-(UILabel*)dateLabel{
    if(!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"预约提货时间" WithTextColor:COLOR(@"646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _dateLabel;
}
- (UITextField *)startTime
{
    if (!_startTime) {
        _startTime = [[UITextField alloc] init];
//        _startTime.text = @"2018/10/01";
        _startTime.textColor = AppTitleGoldenColor;
        _startTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _startTime.delegate = self;
        _startTime.inputView = self.dataPicker;
        _startTime.placeholder=@"请选择预约时间";
        ViewBorderRadius(_startTime, 3, 1, AppBgBlueGrayColor)
    }
    return _startTime;
}
-(UITextView*)textView{
    if(!_textView){
        _textView = [UITextView new];
        _textView.backgroundColor=[UIColor whiteColor]; //设置背景色
        _textView.scrollEnabled = NO;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
        _textView.editable = YES;        //设置是否允许编辑内容，默认为“YES”
    //        textview.delegate = self;       //设置代理方法的实现类
        _textView.font=[UIFont fontWithName:@"Arial" size:12.0]; //设置字体名字和字体大小;
        _textView.returnKeyType = UIReturnKeyDefault;//设置return键的类型
        _textView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型一般为默认
        _textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        _textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        _textView.textColor = [UIColor blackColor];// 设置显示文字颜色
        _textView.text = @"";//设置显示的文本内容
        [_textView xw_addPlaceHolder:@"添加备注"];
        _textView.xw_placeHolderTextView.textColor = COLOR(@"#AAB3BA");
        ViewBorderRadius(_textView, 3, 1, AppBgBlueGrayColor)
    }
    return _textView;
}
- (UIDatePicker *)dataPicker
{
    if (!_dataPicker) {
        _dataPicker = [[UIDatePicker alloc] init];
        //设置地区: zh-中国
        _dataPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        
        if (@available(iOS 13.4, *)) {
            _dataPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        // 设置当前显示时间
        [_dataPicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_dataPicker setMinimumDate:[NSDate date]];
        
        //设置时间格式
        //监听DataPicker的滚动
        [_dataPicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _dataPicker;
}
-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"确定" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:@"确认要提交预约自提信息吗？" block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    [self httpPath_stores_selfSave];
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
        }];
    }
    return _submitBtn;
}
- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    self.startTime.text = dateStr;
}
@end
