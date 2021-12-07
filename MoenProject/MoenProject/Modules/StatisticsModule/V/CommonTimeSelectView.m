//
//  CommonTimeSelectView.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonTimeSelectView.h"

@interface CommonTimeSelectView()<UITextFieldDelegate>

@property (nonatomic, strong)  UITextField *startTime;

@property (nonatomic, strong)  UITextField *endTime;

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIDatePicker *dataStartPicker;

@property (nonatomic, strong) UIDatePicker *dataEndPicker;
@end

@implementation CommonTimeSelectView

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = AppBgWhiteColor;
        [self configBaseUI];
    }
    return self;
}


- (void)configBaseUI
{
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 45)];
    leftLab.text = @"起止时间";
    leftLab.font = FONTSYS(13);
    leftLab.textColor = AppTitleBlackColor;
    
    [self addSubview:leftLab];
    
    
    UILabel *middleLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 15, 45)];
    middleLab.text = @"至";
    middleLab.font = FONTSYS(13);
    middleLab.textColor = AppTitleBlackColor;
    [self addSubview:middleLab];
    
    
    [self addSubview:self.startTime];
    [self.startTime setFrame:CGRectMake(80, 0, 80, 45)];
    
    [self addSubview:self.endTime];
    [self.endTime setFrame:CGRectMake(190, 0, 80, 45)];
    
    [self addSubview:self.selectedBtn];
    [self.selectedBtn setFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 30, 45)];
    
    //设置时间输入框的键盘框样式为时间选择器
    self.startTime.inputView = self.dataStartPicker;
    self.endTime.inputView = self.dataEndPicker;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [formatter  stringFromDate:[NSDate date]];
    self.startTime.text = [date getMonthFirstAndLastDayWith].firstObject;
    self.endTime.text = dateStr;
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

- (void)searchAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(SearchClickDelegate:WithEndTime:)]) {
        [self.delegate SearchClickDelegate:self.startTime.text WithEndTime:self.endTime.text];
    }
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
    }
    return _endTime;
}


- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.titleLabel.font = FONTSYS(14);
        [_selectedBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [_selectedBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_selectedBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _selectedBtn;
}

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

@end
