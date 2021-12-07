//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    if (_titleTextAlignment == NSTextAlignmentCenter) {
        _titleLabel.text = title;
        //角标文案处理
//        NSString *title = _titleLabel.text;
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
//        NSRange boldRange = [title rangeOfString:[title substringToIndex:[title rangeOfString:@"/"].location]];
//        [attributeStr yy_setAttribute:NSFontAttributeName value:FONT(12.0f) range:NSMakeRange(0, title.length)];
//        [attributeStr yy_setAttribute:NSForegroundColorAttributeName value:AppTextColorBlack range:NSMakeRange(0, title.length)];
//        [attributeStr yy_setAttribute:NSFontAttributeName value:[UIFont fontWithName:@"system bold" size:16.0f] range:boldRange];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.attributedText = attributeStr;
    }else{
        //滚动条文案处理
        NSString *content = [NSString stringWithFormat:@"%@", title];
        //    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
        [self setLabelSpace:_titleLabel withValue:content withFont:self.titleLabelTextFont];
    }
    
  
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment{
    _titleTextAlignment = titleTextAlignment;
    _titleLabel.textAlignment = titleTextAlignment;
    
    if (_titleTextAlignment == NSTextAlignmentCenter) {
//        NSString *title = _titleLabel.text;
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
//        NSRange boldRange = [title rangeOfString:[title substringToIndex:[title rangeOfString:@"/"].location]];
//        [attributeStr yy_setAttribute:NSFontAttributeName value:FONT(12.0f) range:NSMakeRange(0, title.length)];
//        [attributeStr yy_setAttribute:NSForegroundColorAttributeName value:AppTextColorBlack range:NSMakeRange(0, title.length)];
//        [attributeStr yy_setAttribute:NSFontAttributeName value:[UIFont fontWithName:@"system bold" size:17.0f] range:boldRange];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.attributedText = attributeStr;
    }
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 4; //设置行间距
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    CGFloat kernAttributeValue = 0.0;
    NSDictionary *dic = @{NSFontAttributeName:font?font:FONT(13.0f), NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(kernAttributeValue)
                          };
    
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        
        if (_titleTextAlignment==NSTextAlignmentCenter) {
            _imageView.frame = self.bounds;
            
            CGFloat titleLabelW = 50;
            CGFloat titleLabelH = 20;
            CGFloat titleLabelX = self.sd_width - 12.0f - titleLabelW;
            CGFloat titleLabelY = self.sd_height - titleLabelH - 10;
            _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
//            _titleLabel.backgroundColor = AppBGWhiteColor;
            _titleLabel.layer.cornerRadius = titleLabelH/2.0f;
            _titleLabel.clipsToBounds= YES;
            
        }else{
            _imageView.frame = self.bounds;
            _imageView.clipsToBounds = YES;
            CGFloat titleLabelW = self.sd_width;
            CGFloat titleLabelH = _titleLabelHeight;
            CGFloat titleLabelX = 0;
            CGFloat titleLabelY = self.sd_height - titleLabelH;
            _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        }
        
    }
}

@end
