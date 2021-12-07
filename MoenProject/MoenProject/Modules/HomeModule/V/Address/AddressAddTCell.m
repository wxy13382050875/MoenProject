//
//  AddressAddTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddressAddTCell.h"
#import "NSString+CheckFormat.h"
@interface AddressAddTCell()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *name_Lab;
@property (weak, nonatomic) IBOutlet UITextField *name_Txt;


@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;

@property (weak, nonatomic) IBOutlet UILabel *province_Lab;
@property (weak, nonatomic) IBOutlet UITextField *province_Txt;


@property (weak, nonatomic) IBOutlet UILabel *city_Lab;
@property (weak, nonatomic) IBOutlet UITextField *city_Txt;


@property (weak, nonatomic) IBOutlet UILabel *district_Lab;
@property (weak, nonatomic) IBOutlet UITextField *district_Txt;

@property (weak, nonatomic) IBOutlet UILabel *street_Lab;
@property (weak, nonatomic) IBOutlet UITextField *street_Txt;


@property (weak, nonatomic) IBOutlet UILabel *address_Lab;
@property (weak, nonatomic) IBOutlet UITextField *address_Txt;
@property (weak, nonatomic) IBOutlet UIButton *save_Btn;

@property (nonatomic, strong) AddressInfoModel *dataModel;

@end

@implementation AddressAddTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.name_Txt.delegate = self;
    self.phone_Txt.delegate = self;
    self.phone_Txt.keyboardType = UIKeyboardTypePhonePad;
    self.province_Txt.delegate = self;
    self.city_Txt.delegate = self;
    self.district_Txt.delegate = self;
    self.street_Txt.delegate = self;
    self.address_Txt.delegate = self;
    
    
    self.name_Lab.font = FONTLanTingR(14);
    self.name_Txt.font = FONTLanTingR(14);
    
    self.phone_Lab.font = FONTLanTingR(14);
    self.phone_Txt.font = FONTLanTingR(14);
    
    self.province_Lab.font = FONTLanTingR(14);
    self.province_Txt.font = FONTLanTingR(14);
    
    self.city_Lab.font = FONTLanTingR(14);
    self.city_Txt.font = FONTLanTingR(14);
    
    self.district_Lab.font = FONTLanTingR(14);
    self.district_Txt.font = FONTLanTingR(14);
    
    self.street_Txt.font = FONTLanTingR(14);
    self.street_Lab.font = FONTLanTingR(14);
    
    self.address_Lab.font = FONTLanTingR(14);
    self.address_Txt.font = FONTLanTingR(14);
    
    self.name_Lab.font = FONTLanTingR(14);
    
    self.save_Btn.titleLabel.font = FONTLanTingB(17);
    
}

- (void)showDataWithAddressInfoModel:(AddressInfoModel *)model
{
    self.dataModel = model;
    self.name_Txt.text = model.shipPerson;
    self.phone_Txt.text = model.shipMobile;
    
    self.province_Txt.text = model.shipProvince;
    self.city_Txt.text = model.shipCity;
    self.district_Txt.text = model.shipDistrict;
    self.street_Txt.text = model.shipStreet;
    self.address_Txt.text = model.shipAddress;
}





- (IBAction)SaveBtnAction:(UIButton *)sender {
    if (self.saveBlock) {
        self.saveBlock(AddressAddTCellActionTypeSave);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.province_Txt ||
        textField == self.city_Txt ||
        textField == self.district_Txt ||
        textField == self.street_Txt) {
        if (textField == self.province_Txt) {
            if (self.saveBlock) {
                self.saveBlock(AddressAddTCellActionTypeProvince);
            }
        }
        if (textField == self.city_Txt) {
            if (self.saveBlock) {
                self.saveBlock(AddressAddTCellActionTypeCity);
            }
        }
        if (textField == self.district_Txt) {
            if (self.saveBlock) {
                self.saveBlock(AddressAddTCellActionTypeDistrict);
            }
        }
        if (textField == self.street_Txt) {
            if (self.saveBlock) {
                self.saveBlock(AddressAddTCellActionTypeStreet);
            }
        }
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name_Txt) {
        textField.text = [textField.text noEmoji];
        self.dataModel.shipPerson = textField.text;
    }
    if (textField == self.phone_Txt) {
        self.dataModel.shipMobile = textField.text;
    }
    if (textField == self.address_Txt) {
        textField.text = [textField.text noEmoji];
        self.dataModel.shipAddress = textField.text;
    }
}

#pragma Mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_Txt) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    if (textField == self.name_Txt) {
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) {
            return NO;
        }
        if ([self stringContainsEmoji:string]) {
            [[NSToastManager manager] showtoast:@"请不要输入表情！"];
            //            [textView resignFirstResponder];
            return NO;
        }
    }
    if (textField == self.address_Txt) {
        if (textField.text.length >= 50 && ![string isEqualToString:@""]) {
            return NO;
        }
        if ([self stringContainsEmoji:string]) {
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
