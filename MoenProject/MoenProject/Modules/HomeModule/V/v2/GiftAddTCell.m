//
//  GiftAddTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2020/1/2.
//  Copyright © 2020 Kevin Jin. All rights reserved.
//

#import "GiftAddTCell.h"

@implementation GiftAddTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSelfAction)]];
}


- (void)selectSelfAction
{
    if (self.cellSelectedActionBlock) {
        self.cellSelectedActionBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
