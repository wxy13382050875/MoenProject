//
//  PackageDetailInfoTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageDetailInfoTCell.h"
@interface PackageDetailInfoTCell()

@property (weak, nonatomic) IBOutlet UILabel *middle_Lab;


@property (weak, nonatomic) IBOutlet UILabel *top_Lab;

@property (weak, nonatomic) IBOutlet UILabel *bottom_Lab;

@end



@implementation PackageDetailInfoTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithPackageDetailModel:(PackageDetailModel *)model
{
    self.middle_Lab.text = model.comboCode;
    
    self.top_Lab.text = model.comboName;
    self.bottom_Lab.text = model.comboDescribe;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
