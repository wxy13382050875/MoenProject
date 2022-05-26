//
//  xw_AttentionItemCell.m
//  MoenProject
//
//  Created by wuxinyi on 2022/3/22.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "xw_AttentionItemCell.h"
@interface xw_AttentionItemCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *textField;
@end
@implementation xw_AttentionItemCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.textField];
    
    
    
}
-(void)xw_updateConstraints{
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs(100);
  
    
    self.textField.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).widthIs(100).heightIs(30);
}
-(void)setModel:(XwActivityModel *)model{
    _model = model;
    self.nameLabel.text = model.activityIndexName;
    self.textField.text = model.num;
    
}

-(void)setIsEnabled:(BOOL)isEnabled{
    self.textField.enabled = isEnabled;
}
-(UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel labelWithText:@"重点关注项目" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLabel;
}

-(UITextField*)textField{
    if(!_textField){
        _textField = [UITextField textFieldWithtext:@"" WithTextColor:COLOR(@"#646464") WithFont:14 WithTextAlignment:NSTextAlignmentCenter WithPlaceholder:@"请输入数量" WithKeyWord:UIKeyboardTypeNumberPad WithDelegate:self];
        
        
        [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            NSLog(@"4567 %@",x);
            if([x integerValue] > 99){
                x = @"99";
            }
            self.model.num = x;
            self.textField.text = x;
        }];
        ViewBorderRadius(_textField, 5, 1, AppLineGrayColor)
    }
    return _textField;
}

@end
