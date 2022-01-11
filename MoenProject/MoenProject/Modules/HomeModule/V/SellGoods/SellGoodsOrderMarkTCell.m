//
//  SellGoodsOrderMarkTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SellGoodsOrderMarkTCell.h"


@interface SellGoodsOrderMarkTCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mark_Txt;

@property (nonatomic, strong) SalesCounterConfigModel *dataModel;

@property (nonatomic, strong) ReturnOrderCounterModel *model;

@property (nonatomic, strong) ReturnOrderInfoModel *returnOrderModel;

@property (nonatomic, assign) SellGoodsOrderMarkTCellType cellType;



@end
@implementation SellGoodsOrderMarkTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mark_Txt.delegate = self;
    self.mark_Txt.font = FONTLanTingR(14);
    self.mark_Txt.tag = 1001;
//    [self.mark_Txt xw_addPlaceHolder:@"添加备注"];
    self.mark_Txt.block = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
        if (self.orderMarkBlock) {
            self.orderMarkBlock(text);
        }
    };
//    self.mark_Txt.placeholder = @"添加备注";
    // Initialization code
//    [self.mark_Txt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
//
}
-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange");
}
//-(void)textFieldTextChange:(UITextView *)textView{
//    NSLog(@"textField1 - 输入框内容改变,当前内容为: %@",textView.text);
//    if(self.orderMarkBlock){
//        if (self.orderMarkBlock) {
//            self.orderMarkBlock(textView.text);
//        }
//    }
//}

- (void)showDataWithSalesCounterConfigModel:(SalesCounterConfigModel *)model
{
    self.cellType = SellGoodsOrderMarkTCellTypeDefault;
    self.dataModel = model;
    if (model.info.length) {
        self.mark_Txt.text = model.info;
    }
    else
    {
        self.mark_Txt.text = @"添加备注：";
    }
}
- (void)showDataWithString:(NSString *)str
{
    if (str.length == 0) {
        self.mark_Txt.text = @"备注：无";
    }
    else
    {
        self.mark_Txt.text = str;
        
    }
    
    [self.mark_Txt setEditable:NO];
}

-(void)setOrderRemarks:(NSString *)orderRemarks{
    _orderRemarks = orderRemarks;
    if([orderRemarks isEqualToString:@""]||orderRemarks == nil){
        
    }
    
    
    self.mark_Txt.text = _orderRemarks;
    
}
-(void)setDefModel:(XwSystemTCellModel *)defModel{
    if(defModel.isEdit && [defModel.value isEqualToString:@""]){
        [self.mark_Txt xw_addPlaceHolder:@"审核备注"];
        self.mark_Txt.xw_placeHolderTextView.textColor = COLOR(@"#AAB3BA");
    }
    self.mark_Txt.text = defModel.value;
    [self.mark_Txt setEditable:defModel.isEdit];
    [self.mark_Txt setScrollEnabled:defModel.isEdit];
//    CGFloat height = [self.mark_Txt heightForString:defModel.value andWidth:SCREEN_WIDTH-20];
}

- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model
{
    self.cellType = SellGoodsOrderMarkTCellTypeReturn;
    self.model = model;
    if (model.markStr.length) {
        self.mark_Txt.text = model.markStr;
    }
    else
    {
        self.mark_Txt.text = @"请输入退货原因";
    }
}

- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model
{
    self.cellType = SellGoodsOrderMarkTCellTypeReturnAll;
    self.returnOrderModel = model;
    if (model.markStr.length) {
        self.mark_Txt.text = model.markStr;
    }
    else
    {
        self.mark_Txt.text = @"请输入退货原因";
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.cellType == SellGoodsOrderMarkTCellTypeDefault) {
        if ([textView.text isEqualToString:@"添加备注："]) {
            textView.text = @"";
        }
    }
    else
    {
        if ([textView.text isEqualToString:@"请输入退货原因"]) {
            textView.text = @"";
        }
    }
    
    return YES;
}

- (void)showDataWithReturnOrderDetailModel:(ReturnOrderDetailModel *)model
{
    self.mark_Txt.text = model.otherReson;
    [self.mark_Txt setEditable:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (self.cellType == SellGoodsOrderMarkTCellTypeDefault) {
        textView.text = [textView.text noEmoji];
        self.dataModel.info = textView.text;
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"添加备注：";
        }
    }
    else
    {
        textView.text = [textView.text noEmoji];
        self.model.markStr = textView.text;
        self.returnOrderModel.markStr = textView.text;
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"请输入退货原因";
        }
    }
    
    if(self.orderMarkBlock){
        if (self.orderMarkBlock) {
            self.orderMarkBlock(textView.text);
        }
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (textView == self.mark_Txt) {
//        if (textView.text.length >= 100 && ![text isEqualToString:@""]) {
//            return NO;
//        }
//    }
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.mark_Txt) {
        if (textView.text.length >= 100 && ![text isEqualToString:@""]) {
            return NO;
        }
        if ([self stringContainsEmoji:text]) {
            [[NSToastManager manager] showtoast:@"请不要输入表情！"];
//            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

//表情符号的判断
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        if (0x278b <= hs && hs <= 0x2792) {
                                            //自带九宫格拼音键盘
                                            returnValue = NO;;
                                        }else if (0x263b == hs) {
                                            returnValue = NO;;
                                        }else {
                                            returnValue = YES;
                                        }
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
