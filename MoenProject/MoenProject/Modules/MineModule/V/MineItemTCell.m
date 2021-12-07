//
//  MineItemTCell.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/10.
//

#import "MineItemTCell.h"

@interface MineItemTCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon_img;
@property (weak, nonatomic) IBOutlet UILabel *title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *right_Lab;
@property (weak, nonatomic) IBOutlet UIImageView *right_Icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_Lab_Constraints;

@end

@implementation MineItemTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title_Lab.font = FONTLanTingR(15);
    // Initialization code
}

- (void)showDataWithDic:(NSDictionary *)dataDic
{
    [self.icon_img setImage:[UIImage imageNamed:dataDic[@"img"]]];
    self.title_Lab.text = dataDic[@"title"];
    self.right_Lab.text = dataDic[@"desc"];
    if ([dataDic[@"title"] isEqualToString:@"关于"]) {
        [self.right_Icon setHidden:YES];
        self.right_Lab_Constraints.constant = 15;
    }
    else
    {
        [self.right_Icon setHidden:NO];
        self.right_Lab_Constraints.constant = 40;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
