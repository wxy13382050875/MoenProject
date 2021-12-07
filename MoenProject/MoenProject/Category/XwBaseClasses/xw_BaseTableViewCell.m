//
//  xw_BaseTableViewCell.m
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import "xw_BaseTableViewCell.h"

@implementation xw_BaseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xw_setupUI];
        [self xw_updateConstraints];
        [self xw_bindViewModel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)xw_setupUI{
    
}
-(void)xw_updateConstraints{
}
-(void)xw_bindViewModel{
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, self.xw_height);
}
@end
