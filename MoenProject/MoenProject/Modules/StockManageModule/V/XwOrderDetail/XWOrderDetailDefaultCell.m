//
//  XWOrderDetailDefaultCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XWOrderDetailDefaultCell.h"
@interface XWOrderDetailDefaultCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;
@end
@implementation XWOrderDetailDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xw_setupUI];
        [self xw_updateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
}
-(void)xw_updateConstraints{
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).widthIs((SCREEN_WIDTH -20)/2).heightIs(30);
    self.valueLabel.sd_layout.topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).leftSpaceToView(self.titleLabel, 5).heightIs(30);
    
    
}
-(void)setModel:(XwSystemTCellModel *)model{
    self.titleLabel.text = model.title;
    self.valueLabel.text = model.value;
}
-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}
-(UILabel*)valueLabel{
    if(!_valueLabel){
        _valueLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _valueLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _valueLabel;
}

@end
