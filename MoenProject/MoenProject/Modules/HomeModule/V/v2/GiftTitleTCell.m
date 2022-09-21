//
//  GiftTitleTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2020/1/2.
//  Copyright © 2020 Kevin Jin. All rights reserved.
//

#import "GiftTitleTCell.h"
@interface GiftTitleTCell ()
@property(nonatomic,weak)IBOutlet UILabel* currentTitleLabel;
@end
@implementation GiftTitleTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCurrentTitle:(NSString *)currentTitle{
    self.currentTitleLabel.text = currentTitle;
}
@end
