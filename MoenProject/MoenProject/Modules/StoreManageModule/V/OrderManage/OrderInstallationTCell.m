//
//  OrderInstallationTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/2/22.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderInstallationTCell.h"
@interface OrderInstallationTCell()

@property (weak, nonatomic) IBOutlet UILabel *left_Lab;

@property (weak, nonatomic) IBOutlet UILabel *right_Lab;


@end


@implementation OrderInstallationTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left_Lab.font = FontBinR(14);
    self.right_Lab.font = FontBinR(14);
    // Initialization code
}

- (void)showDataWithDescription:(NSString *)installation
{
    self.right_Lab.text = installation;
}

- (void)showDataWithTitleAndDsc:(NSString *)leftText rightLab:(NSString *)rightText
{
    self.left_Lab.text = leftText;
    self.right_Lab.text = rightText;
}
-(void)setModel:(XwOrderDetailModel *)model{
    self.left_Lab.text = model.progressName;
    self.right_Lab.text = model.orderStatusText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
