//
//  MineAwardsTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "MineAwardsTCell.h"
#import "AwardsOverviewModel.h"
#import "AwardsStatisticsModel.h"

@interface MineAwardsTCell()

@property (weak, nonatomic) IBOutlet UILabel *title_Lab;
@property (weak, nonatomic) IBOutlet UIButton *hidden_Btn;


@property (weak, nonatomic) IBOutlet UILabel *left_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *left_Amount_Lab;


@property (weak, nonatomic) IBOutlet UILabel *right_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *right_Amount_Lab;

@property (nonatomic, strong) RewardInfoModel *dataModel;

@end

@implementation MineAwardsTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.hidden_Btn addTarget:self action:@selector(hideBtnClickAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)hideBtnClickAction:(UIButton *)sender
{
    [QZLUserConfig sharedInstance].isShowAwards = ![QZLUserConfig sharedInstance].isShowAwards;
    if ([QZLUserConfig sharedInstance].isShowAwards) {
        self.left_Amount_Lab.text = @"*****";
        self.right_Amount_Lab.text = @"*****";
        [self.hidden_Btn setImage:ImageNamed(@"m_notsee_icon") forState:UIControlStateNormal];
    }
    else
    {
        self.left_Amount_Lab.text = self.dataModel.totalReward;
        self.right_Amount_Lab.text = self.dataModel.monthReward;
        [self.hidden_Btn setImage:ImageNamed(@"m_see_icon") forState:UIControlStateNormal];
    }
}

- (void)showDataWithRewardInfoModel:(id)data
{
    RewardInfoModel *model = (RewardInfoModel *)data;
    self.dataModel = model;
//    self.left_Amount_Lab.text = model.totalReward;
//    self.right_Amount_Lab.text = model.monthReward;
//
    self.left_Title_Lab.text = @"累积奖励";
    self.right_Title_Lab.text = @"本月奖励";
    
    if ([QZLUserConfig sharedInstance].isShowAwards) {
        self.left_Amount_Lab.text = @"*****";
        self.right_Amount_Lab.text = @"*****";
        [self.hidden_Btn setImage:ImageNamed(@"m_notsee_icon") forState:UIControlStateNormal];
    }
    else
    {
        self.left_Amount_Lab.text = self.dataModel.totalReward;
        self.right_Amount_Lab.text = self.dataModel.monthReward;
        [self.hidden_Btn setImage:ImageNamed(@"m_see_icon") forState:UIControlStateNormal];
    }
}

- (void)showDataWithAwardsStatisticsModel:(id)data
{
    AwardsStatisticsModel *model = (AwardsStatisticsModel *)data;
    self.left_Amount_Lab.text = model.moenReward.length ? model.moenReward:@"0.00";
    self.right_Amount_Lab.text = model.dealerReward.length ? model.dealerReward:@"0.00";
    
    self.left_Title_Lab.text = @"本月奖励";
    self.right_Title_Lab.text = @"当日奖励";
    
    [self.hidden_Btn setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
