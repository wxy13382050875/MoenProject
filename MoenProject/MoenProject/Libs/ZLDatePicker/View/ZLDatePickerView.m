//
//  ZLDatePickerView.m
//  ZLAppointment
//
//  Created by ZL on 2017/6/19.
//  Copyright © 2017年 zhangli. All rights reserved.
//

#import "ZLDatePickerView.h"

@interface ZLDatePickerView () 

// 取消按钮
@property (strong, nonatomic) UIButton *cancelBtn;
// 确认按钮
@property (strong, nonatomic) UIButton *sureBtn;
// 时间选择器视图
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *fromView;

@end

@implementation ZLDatePickerView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}
-(void)setupUI{
    [self addSubview:self.datePicker];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    
    self.datePicker.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(210);
    self.cancelBtn.sd_layout.leftSpaceToView(self, 5).topEqualToView(self).bottomSpaceToView(self.datePicker, 0).widthIs(60);
    self.sureBtn.sd_layout.rightSpaceToView(self, 5).topEqualToView(self).bottomSpaceToView(self.datePicker, 0).widthIs(60);
}
+ (instancetype)datePickerView {
    
    ZLDatePickerView *picker = [ZLDatePickerView new];
    picker.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
    picker.maximumDate = [NSDate date];
    picker.backgroundColor = COLOR(@"#ffffff");
    
    return picker;
}
- (void)showFrom:(UIView *)view {
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor lightGrayColor];
    bgView.alpha = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [bgView addGestureRecognizer:tap];
    
    self.fromView = view;
    self.bgView = bgView;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

//- (IBAction)cancel:(id)sender {
//    [self dismiss];
//}
//
//- (IBAction)makeSure:(id)sender {
//
//    [self dismiss];
//
//    NSDate *date = self.datePicker.date;
//
//    if ([self.deleagte respondsToSelector:@selector(datePickerView:backTimeString:To:)]) {
//        [self.deleagte datePickerView:self backTimeString:[self fomatterDate:date] To:self.fromView];
//    }
//}

- (void)setMinimumDate:(NSDate *)minimumDate {
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    self.datePicker.maximumDate = maximumDate;
}

- (void)setDate:(NSDate *)date {
    self.datePicker.date = date;
}

- (void)dismiss {
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (NSString *)fomatterDate:(NSDate *)date {
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    return [fomatter stringFromDate:date];
}


-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.datePickerMode=UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        NSDate*minDate=[[NSDate alloc] initWithTimeIntervalSince1970:60*60];
        NSDate*maxDate=[[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*30];
        _datePicker.minimumDate=minDate;
        _datePicker.maximumDate=maxDate;
        _datePicker.backgroundColor=[UIColor whiteColor];
    }
    return _datePicker;
}
-(UIButton*)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithTitie:@"取消" WithtextColor:COLOR(@"#646464") WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            [self dismiss];
        }];
    }
    return  _cancelBtn;
}
-(UIButton*)sureBtn{
    if(!_sureBtn){
        _sureBtn = [UIButton buttonWithTitie:@"确认" WithtextColor:COLOR(@"#646464") WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            [self dismiss];
            
            NSDate *date = self.datePicker.date;
            
            if ([self.deleagte respondsToSelector:@selector(datePickerView:backTimeString:To:)]) {
                [self.deleagte datePickerView:self backTimeString:[self fomatterDate:date] To:self.fromView];
            }
        }];
    }
    return  _sureBtn;
}
@end
