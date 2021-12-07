//
//  SellGoodsOrderConfigTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SellGoodsOrderConfigTCell.h"

@interface SellGoodsOrderConfigTCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *activity_Lab;
@property (weak, nonatomic) IBOutlet UIButton *isActivity_Btn;


@property (weak, nonatomic) IBOutlet UILabel *gift_Lab;
@property (weak, nonatomic) IBOutlet UIButton *isGift_Btn;

@property (weak, nonatomic) IBOutlet UILabel *pickUp_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *pickUp_Type_Lab;
@property (weak, nonatomic) IBOutlet UIView *pickUp_Type_View;


@property (weak, nonatomic) IBOutlet UILabel *delivery_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *delivery_Type_Lab;
@property (weak, nonatomic) IBOutlet UIView *delivery_Type_View;


@property (weak, nonatomic) IBOutlet UILabel *receivables_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *receivables_Type_Lab;
@property (weak, nonatomic) IBOutlet UIView *receivables_Type_View;


@property (weak, nonatomic) IBOutlet UILabel *coupon_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *coupon_Type_Lab;
@property (weak, nonatomic) IBOutlet UILabel *coupon_Count_Lab;
@property (weak, nonatomic) IBOutlet UIView *coupon_Type_View;


@property (weak, nonatomic) IBOutlet UILabel *store_Coupon_Title_Lab;
@property (weak, nonatomic) IBOutlet UITextField *store_Conpon_Txt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delivery_Type_View_Constraints;



@property (nonatomic, strong) SalesCounterConfigModel *dataModel;
@end



@implementation SellGoodsOrderConfigTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activity_Lab.font = FONTLanTingR(14);
    self.gift_Lab.font = FONTLanTingR(14);
    self.pickUp_Title_Lab.font = FONTLanTingR(14);
    self.pickUp_Type_Lab.font = FONTLanTingR(14);
    self.delivery_Title_Lab.font = FONTLanTingR(14);
    self.delivery_Type_Lab.font = FONTLanTingR(14);
    self.receivables_Title_Lab.font = FONTLanTingR(14);
    self.receivables_Type_Lab.font = FONTLanTingR(14);
    self.coupon_Title_Lab.font = FONTLanTingR(14);
    self.coupon_Type_Lab.font = FONTLanTingR(14);
    self.coupon_Count_Lab.font = FONTLanTingR(13);
    self.store_Coupon_Title_Lab.font = FONTLanTingR(14);
    self.store_Conpon_Txt.font = FontBinB(14);
    
    
    self.pickUp_Type_View.userInteractionEnabled = YES;
    [self.pickUp_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPickUpTypeAction)]];
    
    self.delivery_Type_View.userInteractionEnabled = YES;
    [self.delivery_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDeliveryTypeAction)]];
    
    self.receivables_Type_View.userInteractionEnabled = YES;
    [self.receivables_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectReceivablesTypeAction)]];
    
    self.coupon_Type_View.userInteractionEnabled = YES;
    [self.coupon_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCouponTypeAction)]];
    
    self.store_Conpon_Txt.delegate = self;
    self.store_Conpon_Txt.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)selectPickUpTypeAction
{
    if (self.orderConfigTCellSelectBlock) {
        self.orderConfigTCellSelectBlock(SelectTypePickUp);
    }
}
- (void)selectDeliveryTypeAction
{
    if (self.orderConfigTCellSelectBlock) {
        self.orderConfigTCellSelectBlock(SelectTypeDelivery);
    }
}
- (void)selectReceivablesTypeAction
{
    if (self.orderConfigTCellSelectBlock) {
        self.orderConfigTCellSelectBlock(SelectTypeReceivables);
    }
}
- (void)selectCouponTypeAction
{
    if (self.orderConfigTCellSelectBlock) {
        self.orderConfigTCellSelectBlock(SelectTypeCoupon);
    }
}


- (void)showDataWithSalesCounterConfigModel:(SalesCounterConfigModel *)model WithUsableCount:(NSInteger)usableCount WithUnUsableCount:(NSInteger)unUsableCount WithCouponAmount:(NSString *)couponAmount;
{
    
    self.dataModel = model;
    [self.isActivity_Btn setSelected:model.isMoen];
    [self.isGift_Btn setSelected:model.isFreeGift];
    
    if (model.pickUpStatus.length) {
        self.pickUp_Type_Lab.text = model.pickUpStatus;
    }
    else
    {
        self.pickUp_Type_Lab.text = NSLocalizedString(@"please_choose_pickup", nil);
    }
    
    if (![model.pickUpStatus isEqualToString:@"全部已提"]) {
        self.delivery_Type_View_Constraints.constant = 41;
    }
    else
    {
        self.delivery_Type_View_Constraints.constant = 0.01;
    }
    
    if (model.shoppingMethod.length) {
        self.delivery_Type_Lab.text = model.shoppingMethod;
    }
    else
    {
        self.delivery_Type_Lab.text = NSLocalizedString(@"please_choose_delivery", nil);
    }
    
    if (model.paymentMethod.length) {
        self.receivables_Type_Lab.text = model.paymentMethod;
    }
    else
    {
        self.receivables_Type_Lab.text = NSLocalizedString(@"please_choose_payment", nil);
    }
    
    if (model.shopDerate.length) {
        self.store_Conpon_Txt.text = model.shopDerate;
    }
    else
    {
        self.store_Conpon_Txt.text = @"";
    }
    
    
    //优惠券的使用情况
    if (usableCount == 0 &&
        unUsableCount == 0) {
        self.coupon_Type_Lab.text = NSLocalizedString(@"no_coupons", nil);
        self.coupon_Type_Lab.font = FONTLanTingR(14);
        self.coupon_Type_Lab.userInteractionEnabled = NO;
        [self.coupon_Count_Lab setHidden:YES];
    }
    else
    {
        if (usableCount == 0) {
            self.coupon_Type_Lab.text = NSLocalizedString(@"no_available", nil);
            self.coupon_Type_Lab.font = FONTLanTingR(14);
            [self.coupon_Count_Lab setHidden:YES];
        }
        else
        {
            [self.coupon_Count_Lab setHidden:NO];
            if (couponAmount.length && ![couponAmount isEqualToString:@"0"]) {
                self.coupon_Type_Lab.text = [NSString stringWithFormat:@"¥%@",couponAmount];
                self.coupon_Type_Lab.font = FontBinB(14);
                self.coupon_Count_Lab.text = [NSString stringWithFormat:NSLocalizedString(@"chosen_one", nil)];
            }
            else
            {
                self.coupon_Type_Lab.text = NSLocalizedString(@"not_used", nil);
                self.coupon_Type_Lab.font = FONTLanTingR(14);
                self.coupon_Count_Lab.text = [NSString stringWithFormat:@"%ld%@",usableCount,NSLocalizedString(@"_available", nil)];
            }
        }
    }
}


#pragma mark -- UITextFieldDelegate
/**控制金额的输入*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.store_Conpon_Txt == textField) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
        //限制.后面最多有两位，且不能再输入.
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            //有.了 且.后面输入了两位  停止输入
            if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
                return NO;
            }
            //有.了，不允许再输入.
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
        //限制首位0，后面只能输入.
        if ([textField.text isEqualToString:@"0"]) {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            if (![string isEqualToString:@"."]) {
                return NO;
            }
        }
        //限制只能输入：1234567890.
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] > ([self.dataModel.payAmount floatValue] + [self.dataModel.shopDerate floatValue])) {
        [[NSToastManager manager] showtoast:NSLocalizedString(@"store_discount_check", nil)];
        textField.text = self.dataModel.shopDerate;
    }
    else
    {
        self.dataModel.shopDerate = textField.text;
        if (self.orderConfigTCellSelectBlock) {
            self.orderConfigTCellSelectBlock(SelectTypeStoreDiscount);
        }
    }
}



- (IBAction)isActivityAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.dataModel.isMoen = sender.isSelected;
}

- (IBAction)isGiftAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.dataModel.isFreeGift = sender.isSelected;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
