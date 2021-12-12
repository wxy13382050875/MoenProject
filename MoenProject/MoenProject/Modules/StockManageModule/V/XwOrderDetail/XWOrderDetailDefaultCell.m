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
@property (strong, nonatomic) UIImageView *arrowImg;
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
    [self.contentView addSubview:self.arrowImg];
}
-(void)xw_updateConstraints{
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs((SCREEN_WIDTH -20)/2);
    self.valueLabel.sd_layout.topEqualToView(self.contentView).rightSpaceToView(self.contentView, 25).leftSpaceToView(self.titleLabel, 5).bottomEqualToView(self.contentView);
    self.arrowImg.sd_layout.rightSpaceToView(self.contentView, 5).centerYEqualToView(self.contentView).widthIs(10).heightIs(15);
    
    
}
-(void)setModel:(XwSystemTCellModel *)model{
    self.titleLabel.text = model.title;
    self.valueLabel.text = model.value;
    if(model.showArrow){
        self.arrowImg.hidden = NO;
    } else {
        self.arrowImg.hidden = NO;
    }
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
-(UIImageView*)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [UIImageView new];
        _arrowImg.image =[UIImage imageNamed:@"c_detail_right_icon"];
    }
    return _arrowImg;
}
@end
