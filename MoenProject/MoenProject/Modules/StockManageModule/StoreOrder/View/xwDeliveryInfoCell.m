//
//  xwDeliveryInfoCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xwDeliveryInfoCell.h"
#import "RadioButton.h"
@interface xwDeliveryInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statisticsLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UITextField *TextField;//自提
//@property (weak, nonatomic) IBOutlet UITextField *appointmentsTextField;//预约
//@property (weak, nonatomic) IBOutlet UITextField *warehouseTextField;//总仓
@property (weak, nonatomic) IBOutlet UILabel *ValueLabel;//自提
//@property (weak, nonatomic) IBOutlet UILabel *appointmentsValueLabel;//预约
//@property (weak, nonatomic) IBOutlet UILabel *warehouseValueLabel;//总仓
//@property (weak, nonatomic) IBOutlet RadioButton *radioBtn;
@end
@implementation xwDeliveryInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(IBAction)onRadioBtn:(RadioButton*)sender
//{
////    _statusLabel.text = [NSString stringWithFormat:@"Selected: %@", sender.titleLabel.text];
//    NSLog(@"%@",sender.titleLabel.text);
//}
//-(void)setDeliveryType:(DeliveryActionType)deliveryType{
//    NSLog(@"%ld",deliveryType);
//    self.deliveryType = deliveryType;
//    
//}
//-(void)setControllerType:(DeliveryWayType)controllerType{
//    if(controllerType == DeliveryWayTypeShopSelf){
//        self.titleLab.text = @"当场自提数量";
//        sefl.value
//    } else {
//
//        self.titleLab.text = @"总仓发货数量";
//    }
//}
-(void)setModel:(Orderproductinfodatalist *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:ImageNamed(@"defaultImage")];
    self.skuLabel.text = model.goodsSKU;
    self.goodsNameLabel.text = model.goodsName;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"X%@",model.notIssuedNum];
    
    if(_controllerType == DeliveryWayTypeShopSelf){
        self.titleLab.text = @"当场自提数量";
        self.ValueLabel.text = model.shopNum;
        self.TextField.placeholder = @"请输入自提数量";
    } else {
        self.titleLab.text = @"总仓发货数量";
        self.TextField.placeholder = @"请输入发货数量";
        self.ValueLabel.text = model.dealerNum;
    }
    self.statisticsLabel.text = [NSString stringWithFormat:@"未发%@个 已发%@个 总仓预约%@个",model.notIssuedNum,model.sendNum,model.appointmentNum];
    
    if (self.deliveryType == DeliveryActionTypeFirst) {
        self.statisticsLabel.hidden = YES;
        self.bgView.sd_layout.topSpaceToView(self.goodsImage,0);
        [self.bgView updateLayout];
    } else {
        self.statisticsLabel.hidden = NO;
        self.bgView.sd_layout.topSpaceToView(self.statisticsLabel, 0);
        [self.bgView updateLayout];
    }
    self.TextField.text  = self.model.inputCount;
    [self.TextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldTextChange:(UITextField *)textField{
    NSLog(@"textField1 - 输入框内容改变,当前内容为: %@",textField.text);
//
    NSString* stockNum = @"";
    if(_controllerType == DeliveryWayTypeShopSelf){
        stockNum = self.model.shopNum;
    } else {
        stockNum = self.model.dealerNum;
    }
    if(![[QZLUserConfig sharedInstance].storeTypeKey isEqualToString:@"Showroom-Dealer"]){//直营
        if([stockNum integerValue] <= 0){
            textField.text = @"0";
        } else if([stockNum integerValue] > [self.model.notIssuedNum integerValue]){//若库存数量大于门店下单数量最多只能输入到下单数量
            if([textField.text integerValue] > [self.model.notIssuedNum integerValue]){
                textField.text = self.model.notIssuedNum;
            }
        } else {//若库存数量小于门店下单数量，最多只能输入库存数量
            if([textField.text integerValue] > [stockNum integerValue]){
                textField.text = stockNum;
            }
        }
    }else {//分销
        if([textField.text integerValue] > [self.model.notIssuedNum integerValue]){
            textField.text = self.model.notIssuedNum;
        }
    }
//    if(_controllerType == DeliveryWayTypeShopSelf){
////        notIssuedNum下单数量
////        shopNum 库存数量
//        
//        if([self.model.notIssuedNum integerValue] > [self.model.shopNum integerValue]){
//            if([textField.text integerValue] > [self.model.shopNum integerValue]){
//                textField.text = self.model.shopNum;
//            }
//        } else {
//            if([self.model.notIssuedNum integerValue] <= 0){
//                textField.text = @"0";
//            } else if([textField.text integerValue] > [self.model.notIssuedNum integerValue]){
//                textField.text = self.model.notIssuedNum;
//            }
//        }
//
//    } else {
//        
//        if([self.model.notIssuedNum integerValue]> [self.model.dealerNum integerValue]){
//            if([textField.text integerValue] > [self.model.dealerNum integerValue]){
//                textField.text = self.model.dealerNum;
//            }
//        } else {
//            if([self.model.notIssuedNum integerValue] <= 0){
//                textField.text = @"0";
//            } else if([textField.text integerValue] > [self.model.notIssuedNum integerValue]){
//                textField.text = self.model.notIssuedNum;
//            }
//        }
//
//    }
    if([textField.text integerValue] <= 0){
        textField.text = @"0";
    }
    self.model.inputCount =textField.text;
}
@end
