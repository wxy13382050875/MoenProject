//
//  ReturnGoodsAmountTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/25.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsAmountTCell.h"
@interface ReturnGoodsAmountTCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *amount_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *amount_Lab;

@property (weak, nonatomic) IBOutlet UILabel *actual_Title_Lab;

@property (weak, nonatomic) IBOutlet UITextField *amount_Txt;

@property (nonatomic, strong) ReturnOrderSingleGoodsModel *singleModel;

@property (nonatomic, strong) ReturnOrderMealGoodsModel *mealModel;

@property (nonatomic, strong) ReturnOrderCounterGoodsModel *counterModel;

@property (nonatomic, assign) NSInteger handleType;
@end


@implementation ReturnGoodsAmountTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.amount_Title_Lab.font = FONTLanTingR(14);
     self.amount_Lab.font = FontBinB(14);
     self.actual_Title_Lab.font = FONTLanTingR(14);
     self.amount_Txt.font = FontBinB(14);
    
    
    self.amount_Txt.delegate = self;
    self.amount_Txt.keyboardType = UIKeyboardTypeNumberPad;
    // Initialization code
}

- (void)showDataWithReturnOrderSingleGoodsModel:(ReturnOrderSingleGoodsModel *)model
{
    self.handleType = 1;
    self.singleModel = model;
    if ([model.refundAmount isEqualToString:@"0"]) {
        self.amount_Lab.text = @"";
    }
    else
    {
        self.amount_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    }
//    self.amount_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    self.amount_Txt.text = model.actualRefundAmount;
}

- (void)showDataWithReturnOrderMealGoodsModel:(ReturnOrderMealGoodsModel *)model
{
    self.handleType = 2;
    self.mealModel = model;
    if ([model.refundAmount isEqualToString:@"0"]) {
        self.amount_Lab.text = @"";
    }
    else
    {
        self.amount_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    }
    
    self.amount_Txt.text = model.actualRefundAmount;
}

- (void)showDataWithReturnOrderCounterGoodsModel:(ReturnOrderCounterGoodsModel *)model
{
    self.handleType = 3;
    self.counterModel = model;
    if ([model.refundAmount isEqualToString:@"0"]) {
        self.amount_Lab.text = @"";
    }
    else
    {
        self.amount_Lab.text = [NSString stringWithFormat:@"¥%@",model.refundAmount];
    }
    self.amount_Txt.text = model.actualRefundAmount;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        textField.text = @"";
    }
    if (self.handleType == 1) {
        if ([textField.text integerValue] > [self.singleModel.refundAmount integerValue]) {
            textField.text = self.singleModel.refundAmount;
            self.singleModel.actualRefundAmount = self.singleModel.refundAmount;
            [[NSToastManager manager] showtoast:@"实际金额不能大于退货金额"];
        }
        else
        {
            if ([textField.text isEqualToString:@""]) {
                self.singleModel.actualRefundAmount = @"0";
            }
            else
            {
                self.singleModel.actualRefundAmount = textField.text;
            }
            
        }
    }
    else if (self.handleType == 2)
    {
        if ([textField.text integerValue] > [self.mealModel.refundAmount integerValue]) {
            textField.text = self.mealModel.refundAmount;
            self.mealModel.actualRefundAmount = self.mealModel.refundAmount;
            [[NSToastManager manager] showtoast:@"实际金额不能大于退货金额"];
        }
        else
        {
            if ([textField.text isEqualToString:@""]) {
                self.mealModel.actualRefundAmount = @"0";
            }
            else
            {
                self.mealModel.actualRefundAmount = textField.text;
            }
        }
    }
    else
    {
        if ([textField.text integerValue] > [self.counterModel.refundAmount integerValue]) {
            textField.text = self.counterModel.refundAmount;
            self.counterModel.actualRefundAmount = self.counterModel.refundAmount;
            [[NSToastManager manager] showtoast:@"实际金额不能大于退货金额"];
        }
        else
        {
            if ([textField.text isEqualToString:@""]) {
                self.counterModel.actualRefundAmount = @"0";
            }
            else
            {
                self.counterModel.actualRefundAmount = textField.text;
            }
        }
    }
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.amount_Txt) {
        if (textField.text.length >= 9 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
