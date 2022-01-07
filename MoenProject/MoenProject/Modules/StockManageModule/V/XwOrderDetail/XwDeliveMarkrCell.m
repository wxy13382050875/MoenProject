//
//  XwDeliveMarkrCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/22.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwDeliveMarkrCell.h"
@interface XwDeliveMarkrCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextView* textView;
@end
@implementation XwDeliveMarkrCell
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
    [self.contentView addSubview:self.textView];
    
    
    
    
}
-(void)xw_updateConstraints{
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs(100);
    self.textView.sd_layout.leftSpaceToView(self.nameLabel, 5).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 15).bottomSpaceToView(self.contentView, 5);
    
}
-(UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel labelWithText:@"发货备注信息" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLabel;
}

-(UITextView*)textView{
    if(!_textView){
        _textView = [UITextView new];
        _textView.backgroundColor=[UIColor whiteColor]; //设置背景色
        _textView.scrollEnabled = NO;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
        _textView.editable = YES;        //设置是否允许编辑内容，默认为“YES”
    //        textview.delegate = self;       //设置代理方法的实现类
        _textView.font=[UIFont fontWithName:@"Arial" size:12.0]; //设置字体名字和字体大小;
        _textView.returnKeyType = UIReturnKeyDefault;//设置return键的类型
        _textView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型一般为默认
        _textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        _textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        _textView.textColor = [UIColor blackColor];// 设置显示文字颜色
//        _textView.text = @"UITextView详解";//设置显示的文本内容
        [_textView xw_addPlaceHolder:@"添加备注"];
        _textView.xw_placeHolderTextView.textColor = COLOR(@"#AAB3BA");
        ViewBorderRadius(_textView, 3, 1, AppBgBlueGrayColor)
        WEAKSELF
        _textView.block = ^(NSString * _Nonnull text) {
            NSLog(@"%@",text);
            if (weakSelf.inputBlock) {
                weakSelf.inputBlock(text);
            }
        };
    }
    return _textView;
}
@end
