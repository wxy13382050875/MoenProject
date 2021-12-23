//
//  XwOrderDetailAuditMarkCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailAuditMarkCell.h"
@interface XwOrderDetailAuditMarkCell ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView* textView;
@end
@implementation XwOrderDetailAuditMarkCell

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
    [self.contentView addSubview:self.textView];
}
-(void)xw_updateConstraints{
    self.textView.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 15).bottomSpaceToView(self.contentView, 5);
    
}
-(UITextView*)textView{
    if(!_textView){
        _textView = [UITextView new];
        _textView.textColor = COLOR(@"#646464");//设置textview里面的字体颜色
        _textView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
//        _textView.delegate = self;//设置它的委托方法
        _textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _textView.scrollEnabled = YES;//是否可以拖动
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        _textView.text =@"";
        [_textView xw_addPlaceHolder:@"添加备注"];
        _textView.xw_placeHolderTextView.textColor = COLOR(@"#AAB3BA");
        ViewBorderRadius(_textView, 5, 1, [UIColor groupTableViewBackgroundColor])
    }
    return _textView;
}

//- (void)textViewDidEndEditing:(UITextView *)textView {
// 
// 
//}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
@end
