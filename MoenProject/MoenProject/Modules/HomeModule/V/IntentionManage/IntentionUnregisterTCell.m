//
//  IntentionUnregisterTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "IntentionUnregisterTCell.h"

@interface IntentionUnregisterTCell()
@property (weak, nonatomic) IBOutlet UILabel *time_Lab;

@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UILabel *type_Lab;

@property (weak, nonatomic) IBOutlet UIButton *add_Btn;




@end

@implementation IntentionUnregisterTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)showDataWithUnLabelUserInfoModel:(UnLabelUserInfoModel *)model
{
    self.time_Lab.text = model.createDate;
    self.phone_Lab.text = model.custCode;
    self.type_Lab.text = model.channel;
}


- (IBAction)AddAction:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
