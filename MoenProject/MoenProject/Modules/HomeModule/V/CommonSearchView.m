//
//  CommonSearchView.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonSearchView.h"
@interface CommonSearchView()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *input_Txt;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *container_view_Right;

@property (weak, nonatomic) IBOutlet UIView *time_Select_View;


@end

@implementation CommonSearchView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.input_Txt.delegate = self;
    self.input_Txt.font = FONTLanTingR(13);
    self.input_Txt.clearsOnBeginEditing = NO;
    
}

- (IBAction)searchBtnAction:(id)sender {
    
    if (self.input_Txt.text.length == 0) {
        if (_viewType == CommonSearchViewTypePackage) {
            [[NSToastManager manager] showtoast:@"请输入商品SKU/套餐号"];
        }
        if (_viewType == CommonSearchViewTypeGoods) {
            [[NSToastManager manager] showtoast:@"请输入商品SKU/套餐号"];
        }
        if (_viewType == CommonSearchViewTypeCustomer) {
            [[NSToastManager manager] showtoast:@"请输入客户手机号"];
        }
        if (_viewType == CommonSearchViewTypeOrder) {
            [[NSToastManager manager] showtoast:@"请输入订单编号"];
        }
        if (_viewType == CommonSearchViewTypeIntention) {
            [[NSToastManager manager] showtoast:@"请输入客户手机号码"];
        }
        if (_viewType == CommonSearchViewTypeGoodsList) {
            [[NSToastManager manager] showtoast:@"请输入商品SKU"];
        }
        if (_viewType == CommonSearchViewTypeOrderReturn) {
            [[NSToastManager manager] showtoast:@"请输入退货单编号"];
        }
        if (_viewType == CommonSearchViewTypeCheckStockOrder) {
            [[NSToastManager manager] showtoast:@"请输入盘库单编号"];
        }
        return;
    }
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(completeInputAction:)]) {
        [self.delegate completeInputAction:self.input_Txt.text];
    }
}


- (void)setViewType:(CommonSearchViewType)viewType
{
    _viewType = viewType;
    if (_viewType == CommonSearchViewTypePackage) {
        self.input_Txt.placeholder = @"输入商品SKU/套餐号";
    }
    if (_viewType == CommonSearchViewTypeGoods) {
        self.input_Txt.placeholder = @"输入商品SKU/套餐号";
    }
    if (_viewType == CommonSearchViewTypeCustomer) {
        self.input_Txt.placeholder = @"输入客户手机号,识别后进入快速服务";
        self.input_Txt.keyboardType = UIKeyboardTypePhonePad;
    }
    if (_viewType == CommonSearchViewTypeOrder) {
        self.input_Txt.placeholder = @"搜索订单编号";
        self.container_view_Right.constant = 55;
        [self.time_Select_View setHidden:NO];
        self.time_Select_View.userInteractionEnabled = YES;
        [self.time_Select_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(time_Select_ViewAction)]];
    }
    if (_viewType == CommonSearchViewTypeIntention) {
        self.input_Txt.placeholder = @"搜索客户手机号码";
    }
    
    if (_viewType == CommonSearchViewTypeGoodsList) {
        self.input_Txt.placeholder = @"输入商品SKU";
    }
    
    if (_viewType == CommonSearchViewTypeOrderReturn) {
         self.input_Txt.placeholder = @"搜索退货单编号";
        self.container_view_Right.constant = 55;
        [self.time_Select_View setHidden:NO];
        self.time_Select_View.userInteractionEnabled = YES;
        [self.time_Select_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(time_Select_ViewAction)]];
    }
    
    if (_viewType == CommonSearchViewTypeCheckStockOrder) {
        self.input_Txt.placeholder = @"搜索盘库单编号";
        self.container_view_Right.constant = 55;
        [self.time_Select_View setHidden:NO];
        self.time_Select_View.userInteractionEnabled = YES;
        [self.time_Select_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(time_Select_ViewAction)]];
    }
    if (_viewType == CommonSearchViewTypeChangeStockOrder) {
        self.input_Txt.placeholder = @"搜索调库单编号";
        self.container_view_Right.constant = 55;
        [self.time_Select_View setHidden:NO];
        self.time_Select_View.userInteractionEnabled = YES;
        [self.time_Select_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(time_Select_ViewAction)]];
    }
    
}

- (void)time_Select_ViewAction
{
    
    if ([self.delegate respondsToSelector:@selector(selectedTimeAction)]) {
        [self.delegate selectedTimeAction];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.input_Txt &&
        self.viewType == CommonSearchViewTypeCustomer) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    if (textField.text.length == 1 &&
        [string isEqualToString:@""]) {
        if (_viewType != CommonSearchViewTypeCustomer) {
            textField.text = @"";
            if ([self.delegate respondsToSelector:@selector(completeInputAction:)]) {
                [self.delegate completeInputAction:@""];
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_viewType != CommonSearchViewTypeCustomer) {
        if ([self.delegate respondsToSelector:@selector(completeInputAction:)]) {
            [self.delegate completeInputAction:@""];
        }
    }
    
    return YES;
}

- (void)setInputTxtStr:(NSString *)inputTxtStr
{
    self.input_Txt.text = inputTxtStr;
}

- (void)clearContent
{
    self.input_Txt.text = @"";
}
@end
