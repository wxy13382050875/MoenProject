//
//  UserIdentifySuccessCCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "UserIdentifySuccessCCell.h"
@interface UserIdentifySuccessCCell()

@property (weak, nonatomic) IBOutlet UILabel *status_Lab;

@property (weak, nonatomic) IBOutlet UILabel *phone_Lab;

@property (weak, nonatomic) IBOutlet UILabel *recommend_Lab;


@end

@implementation UserIdentifySuccessCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.status_Lab.font = FONTLanTingB(17);
    self.phone_Lab.font = FONTLanTingR(15);
    self.recommend_Lab.font = FONTLanTingR(15);
    // Initialization code
}


- (void)showDataWithMembershipInfoModel:(MembershipInfoModel *)model WithControllerType:(NSInteger)controllerType
{
    if (controllerType == 0) {
        self.status_Lab.text = NSLocalizedString(@"register_success", nil);
    }
    else
    {
        self.status_Lab.text = NSLocalizedString(@"identify_success", nil);
    }
    self.phone_Lab.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"phone_number_t", nil) ,[NSTool handlePhoneNumberFormatWithNumberString:model.account]];
    if (model.referee.length > 0) {
        self.recommend_Lab.text = [NSString stringWithFormat:@"%@     %@",NSLocalizedString(@"recommender_t", nil) ,model.referee];
    }
    else if (model.identity.length > 0)
    {
        self.recommend_Lab.text = [NSString stringWithFormat:@"%@         %@",NSLocalizedString(@"identity_t", nil) ,model.identity];
    }
    else
    {
        [self.recommend_Lab setHidden:YES];
    }
    
}
@end
