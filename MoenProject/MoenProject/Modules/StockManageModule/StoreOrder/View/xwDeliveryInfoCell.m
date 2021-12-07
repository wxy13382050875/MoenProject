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
@property (weak, nonatomic) IBOutlet UITextField *takeTextField;//自提
@property (weak, nonatomic) IBOutlet UITextField *appointmentsTextField;//预约
@property (weak, nonatomic) IBOutlet UITextField *warehouseTextField;//总仓
@property (weak, nonatomic) IBOutlet UILabel *takeValueLabel;//自提
@property (weak, nonatomic) IBOutlet UILabel *appointmentsValueLabel;//预约
@property (weak, nonatomic) IBOutlet UILabel *warehouseValueLabel;//总仓
@property (weak, nonatomic) IBOutlet RadioButton *radioBtn;
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
-(IBAction)onRadioBtn:(RadioButton*)sender
{
//    _statusLabel.text = [NSString stringWithFormat:@"Selected: %@", sender.titleLabel.text];
    NSLog(@"%@",sender.titleLabel.text);
}
-(void)setDeliveryType:(DeliveryActionType)deliveryType{
    NSLog(@"%ld",deliveryType);
    if (deliveryType == DeliveryActionTypeFirst) {
        self.statisticsLabel.hidden = YES;
        self.bgView.sd_layout.topSpaceToView(self.goodsImage,0);
        [self.bgView updateLayout];
    } else {
        self.statisticsLabel.hidden = NO;
        self.bgView.sd_layout.topSpaceToView(self.statisticsLabel, 0);
        [self.bgView updateLayout];
    }
}
@end
