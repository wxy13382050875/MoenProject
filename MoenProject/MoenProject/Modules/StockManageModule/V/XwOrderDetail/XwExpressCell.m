//
//  XwExpressCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/22.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwExpressCell.h"
@interface XwExpressCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *expressTextField;

@property (nonatomic, strong) UIImageView *expressImageView;
@end
@implementation XwExpressCell
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
    [self.contentView addSubview:self.expressTextField];
    
    [self.contentView addSubview:self.expressImageView];
    
    
    
    
}
-(void)xw_updateConstraints{
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs(100);
    
    self.expressImageView.sd_layout.rightSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(60).heightIs(60);
    self.expressTextField.sd_layout.leftSpaceToView(self.nameLabel, 5).topEqualToView(self.contentView).rightSpaceToView(self.expressImageView, 5).bottomEqualToView(self.contentView);
    
}
-(void)setExpressIMG:(NSString *)expressIMG{
    [self.expressImageView sd_setImageWithURL:[NSURL URLWithString:expressIMG] placeholderImage:ImageNamed(@"defaultImage")];
}
-(UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel labelWithText:@"录入快递单号" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLabel;
}

-(UITextField*)expressTextField{
    if(!_expressTextField){
        _expressTextField = [UITextField textFieldWithtext:@"" WithTextColor:COLOR(@"#646464") WithFont:14 WithTextAlignment:NSTextAlignmentLeft WithPlaceholder:@"请输入快递单号" WithKeyWord:UIKeyboardTypeDefault WithDelegate:self];
        [_expressTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _expressTextField;
}
-(UIImageView*)expressImageView{
    if(!_expressImageView){
        _expressImageView = [[UIImageView alloc] init];
//        _expressImageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _expressImageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        _expressImageView.contentMode = UIViewContentModeScaleToFill;
        //为imageView添加点击事件：
        _expressImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpenCamera)];
        [_expressImageView addGestureRecognizer:tap];
    }
    return _expressImageView;
}
-(void)textFieldTextChange:(UITextField *)textView{
    NSLog(@"textField1 - 输入框内容改变,当前内容为: %@",textView.text);
    if (self.inputBlock) {
        self.inputBlock(textView.text);
    }
}
-(void)tapOpenCamera{
    
    if (self.openBlock) {
        self.openBlock();
    }
}

@end
