//
//  PatrolStoreCheckResultTcell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PatrolStoreCheckResultTcell.h"

@interface PatrolStoreCheckResultTcell()
@property (weak, nonatomic) IBOutlet UIImageView *type_Img;
@property (weak, nonatomic) IBOutlet UILabel *content_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *question_Img;
@property (weak, nonatomic) IBOutlet UILabel *status_Lab;

@end

@implementation PatrolStoreCheckResultTcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)showDataWithPatrolShopDetailModel:(PatrolShopDetailModel *)model
{
    self.content_Lab.text = model.questionName;
    self.status_Lab.text = model.questionStatus.des;
    if ([model.questionStatus.ID isEqualToString:@"QUALIFIED"]) {
        [self.type_Img setImage:ImageNamed(@"p_blue_point_icon")];
        [self.question_Img setHidden:YES];
    }
    else
    {
        [self.type_Img setImage:ImageNamed(@"p_yellow_point_icon")];
        [self.question_Img setHidden:NO];
    }
}

- (void)showDataWithPatrolProblemModel:(PatrolProblemModel *)model
{
    self.content_Lab.text = model.questionName;
    [self.question_Img setHidden:YES];
    [self.status_Lab setHidden:YES];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
