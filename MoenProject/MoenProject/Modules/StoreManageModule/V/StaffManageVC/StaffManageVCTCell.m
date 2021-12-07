//
//  StaffManageVCTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StaffManageVCTCell.h"
@interface StaffManageVCTCell()
@property (weak, nonatomic) IBOutlet UIImageView *role_Img;
@property (weak, nonatomic) IBOutlet UILabel *role_Lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *user_Img;
@property (weak, nonatomic) IBOutlet UILabel *name_Lab;
@property (weak, nonatomic) IBOutlet UIButton *stop_Btn;
@property (weak, nonatomic) IBOutlet UIImageView *tip_Img;

@property (nonatomic, copy) StaffManageVCTCellStopBlock stopBlock;

@property (nonatomic, assign) NSInteger userID;
@end





@implementation StaffManageVCTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.role_Lab.font = FONTLanTingR(14);
    self.phone_Lab.font = FONTLanTingR(14);
    self.name_Lab.font = FONTLanTingR(14);
    // Initialization code
}

- (void)showDataWithShopStaffModel:(ShopStaffModel *)model WithStopBlock:(nonnull StaffManageVCTCellStopBlock)stopBlock
{
    self.stopBlock = stopBlock;
    self.userID = model.ID;
    
    self.phone_Lab.text = [NSTool handlePhoneNumberFormatWithNumberString:model.phone ];
    self.name_Lab.text = model.name;
    ShopStaffTypeModel *businessRole = model.businessRole;
    self.role_Lab.text = businessRole.des;
    if ([businessRole.ID isEqualToString:@"SHOPKEEPER"]) {
        [self.role_Img setImage:ImageNamed(@"s_blue_point_icon")];
    }
    else
    {
        [self.role_Img setImage:ImageNamed(@"s_yellow_point_icon")];
    }
    ShopStaffTypeModel *status = model.status;
    if ([status.ID isEqualToString:@"Use"]) {
        [self.stop_Btn setHidden:NO];
        [self.tip_Img setHidden:YES];
        if ([model.phone isEqualToString:[QZLUserConfig sharedInstance].loginPhone]) {
            [self.stop_Btn setHidden:YES];
        }
        if ([businessRole.ID isEqualToString:@"SHOPKEEPER"]) {
            [self.stop_Btn setHidden:YES];
        }
    }
    else
    {
        [self.stop_Btn setHidden:YES];
        [self.tip_Img setHidden:NO];
    }
}


- (IBAction)stopActin:(UIButton *)sender {
    if (self.stopBlock) {
        self.stopBlock(self.userID);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
