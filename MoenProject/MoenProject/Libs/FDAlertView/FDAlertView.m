//
//  FDAlertView.m
//  FDAlertViewDemo
//
//  Created by fergusding on 15/5/26.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDAlertView.h"

#define TITLE_FONT_SIZE 17
#define MESSAGE_FONT_SIZE 15
#define BUTTON_FONT_SIZE 17
#define MARGIN_TOP 20
#define MARGIN_LEFT_LARGE 20
#define MARGIN_LEFT_SMALL 15
#define MARGIN_RIGHT_LARGE 20
#define MARGIN_RIGHT_SMALL 15
#define SPACE_LARGE 35
#define SPACE_SMALL 5
#define MESSAGE_LINE_SPACE 5

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

@interface FDAlertView ()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (nonatomic, strong) UITextField *addPriceTxt;
@property (nonatomic, strong) UITextView *goodsCodeTxt;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@property (nonatomic, copy) buttonBlock buttonBlock;

@end

CGFloat contentViewWidth;
CGFloat contentViewHeight;

@implementation FDAlertView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithBlockTItle:(NSString *)title alterType:(FDAltertViewType)alterType message:(NSString *)message block:(buttonBlock)buttonBlock buttonTitles:(NSString *)buttonTitles, ...{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _message = message;
        _buttonBlock = buttonBlock;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        _alterType = alterType;
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self initContentView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title alterType:(FDAltertViewType)alterType message:(NSString *)message delegate:(id<FDAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _message = message;
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        _alterType = alterType;
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self initContentView];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentView];
}


- (void)setMessage:(NSString *)message {
    _message = message;
    [self initContentView];
}

// Init the content of content view
- (void)initContentView {
    contentViewWidth = 288 * self.frame.size.width / 375;
    contentViewHeight = 0;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 12.0;
    _contentView.layer.masksToBounds = YES;
    
    [self initTitleAndIcon];
    
    if (self.alterType == FDAltertViewTypeTips) {
        [self initMessage];
    }
    else
    {
        [self initInputView];
    }
    
    if (self.alterType != FDAltertViewTypeSeeMark) {
        [self initAllButtons];
    }
    else
    {
        self.backgroundView.userInteractionEnabled = YES;
        [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFDAlterView)]];
        
    }
    
    
    _contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
    _contentView.center = self.center;
    [self addSubview:_contentView];
}


// Init the title and icon
- (void)initTitleAndIcon {
    _titleView = [[UIView alloc] init];
    
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.textColor = AppTitleWhiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:TITLE_FONT_SIZE];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.frame = CGRectMake(0, 0, contentViewWidth, 45);
        [_titleView addSubview:_titleLabel];
    }
    
    _titleView.frame = CGRectMake(0, 0, contentViewWidth, 45);
    _titleView.center = CGPointMake(contentViewWidth / 2, 22.5);
    _titleView.backgroundColor = AppTabBarTitleSelected;
    [_contentView addSubview:_titleView];
    contentViewHeight += _titleView.frame.size.height;
}


// Init the message
- (void)initMessage {
    if (_message != nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.textColor = AppTitleBlackColor;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        _messageLabel.attributedText = [[NSAttributedString alloc]initWithString:_message attributes:attributes];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize messageSize = [self getMessageSize];
        _messageLabel.frame = CGRectMake(MARGIN_LEFT_LARGE, _titleView.frame.origin.y + _titleView.frame.size.height + SPACE_LARGE, MAX(contentViewWidth - MARGIN_LEFT_LARGE - MARGIN_RIGHT_LARGE, messageSize.width), messageSize.height);
        [_contentView addSubview:_messageLabel];
        contentViewHeight += SPACE_LARGE + _messageLabel.frame.size.height + 30;
    }
}

#pragma mark -- 初始化输入控件
- (void)initInputView
{
    if (self.alterType == FDAltertViewTypeInputPrice ||
        self.alterType == FDAltertViewTypeInputPriceForGift ||
        self.alterType == FDAltertViewTypeEditInputPrice ||
        self.alterType == FDAltertViewTypeEditInputPriceForGift) {
        UILabel *priceTipLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _titleView.frame.origin.y + _titleView.frame.size.height + 28, 35, 37)];
        priceTipLab.font = FONTSYS(15);
        priceTipLab.textColor = AppTitleBlackColor;
        priceTipLab.text = @"加价";
        [_contentView addSubview:priceTipLab];
        
        
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(60, _titleView.frame.origin.y + _titleView.frame.size.height + 28, contentViewWidth - 120, 37)];
        inputView.clipsToBounds = YES;
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = UIColorFromRGB(0xAAAAAA).CGColor;
        inputView.layer.cornerRadius = 5;
        [_contentView addSubview:inputView];
        
        UITextField *priceInputTxt = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, inputView.frame.size.width - 10, 37)];
        priceInputTxt.font = FONTSYS(15);
        priceInputTxt.textColor = AppTitleBlackColor;
        priceInputTxt.keyboardType = UIKeyboardTypeDecimalPad;
        priceInputTxt.delegate = self;
        if (self.alterType == FDAltertViewTypeEditInputPrice ||
            self.alterType == FDAltertViewTypeEditInputPriceForGift) {
            priceInputTxt.text = self.message;
        }
        self.addPriceTxt = priceInputTxt;
        [inputView addSubview:priceInputTxt];
        
        UILabel *unitTipLab = [[UILabel alloc] initWithFrame:CGRectMake(contentViewWidth - 50, _titleView.frame.origin.y + _titleView.frame.size.height + 28, 35, 37)];
        unitTipLab.font = FONTSYS(15);
        unitTipLab.textColor = AppTitleBlackColor;
        unitTipLab.text = @"元";
        [_contentView addSubview:unitTipLab];
        
        contentViewHeight += 30 + priceTipLab.frame.size.height + 30;
    }
    
    if (self.alterType == FDAltertViewTypeInputCode ||
        self.alterType == FDAltertViewTypeInputCodeForGift ||
        self.alterType == FDAltertViewTypeEditInputCode ||
        self.alterType == FDAltertViewTypeEditInputCodeForGift ||
        self.alterType == FDAltertViewTypeAddMark ||
        self.alterType == FDAltertViewTypeSeeMark) {
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(24, _titleView.frame.origin.y + _titleView.frame.size.height + 15, contentViewWidth - 48, 64)];
        inputView.clipsToBounds = YES;
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = UIColorFromRGB(0xAAAAAA).CGColor;
        inputView.layer.cornerRadius = 5;
        [_contentView addSubview:inputView];
        
        UITextView *priceInputTxt = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, inputView.frame.size.width - 10, 64)];
        priceInputTxt.font = FONTSYS(15);
        priceInputTxt.textColor = AppTitleBlackColor;
        if (self.alterType == FDAltertViewTypeEditInputCode ||
            self.alterType == FDAltertViewTypeEditInputCodeForGift ||
            self.alterType == FDAltertViewTypeSeeMark ||
            self.alterType == FDAltertViewTypeAddMark) {
            if (self.alterType == FDAltertViewTypeSeeMark) {
                [priceInputTxt setEditable:NO];
            }
            priceInputTxt.text = self.message;
        }
        self.goodsCodeTxt = priceInputTxt;
        self.goodsCodeTxt.delegate = self;
        [inputView addSubview:priceInputTxt];
        
        contentViewHeight += 15 + inputView.frame.size.height + 15;
    }
}

// Init all the buttons according to button titles
- (void)initAllButtons {
    if (_buttonTitleArray.count > 0) {
        contentViewHeight += 45 + 25;
        
        CGFloat buttonWidth = (contentViewWidth - 56) / _buttonTitleArray.count;
        for (NSString *buttonTitle in _buttonTitleArray) {
            NSInteger index = [_buttonTitleArray indexOfObject:buttonTitle];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 12;
            if (index == 0) {
                [button setFrame:CGRectMake(24, contentViewHeight - 70, buttonWidth, 45)];
                [button setTitleColor:AppTitleBlackColor forState:UIControlStateNormal];
                button.layer.borderWidth = 1;
                button.tag = 10001;
                button.layer.borderColor = UIColorFromRGB(0xAAAAAA).CGColor;
                if (_buttonTitleArray.count == 1) {
                    [button setTitleColor:AppTabBarTitleSelected forState:UIControlStateNormal];
                    [button setBackgroundColor:UIColorFromRGB(0xB7C9D3)];
                    button.tag = 10002;
                    button.layer.borderColor = UIColorFromRGB(0xB7C9D3).CGColor;
                }
            }
            else if (index == 1)
            {
                [button setFrame:CGRectMake(24 + buttonWidth + 8, contentViewHeight - 70, buttonWidth, 45)];
                [button setTitleColor:AppTabBarTitleSelected forState:UIControlStateNormal];
                [button setBackgroundColor:UIColorFromRGB(0xB7C9D3)];
                button.tag = 10002;
            }
            
            [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_contentView addSubview:button];
        }
    }
}

// Get the size of message
- (CGSize)getMessageSize {
    UIFont *font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_message boundingRectWithSize:CGSizeMake(contentViewWidth - (MARGIN_LEFT_LARGE + MARGIN_RIGHT_LARGE), 2000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (void)buttonWithPressed:(UIButton *)button {
    [self endEditing:YES];
    if (button.tag == 10002) {
        if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:WithInputStr:)]) {
            NSInteger index = [_buttonTitleArray indexOfObject:button.titleLabel.text];
            if (self.alterType == FDAltertViewTypeInputPrice ||
                self.alterType == FDAltertViewTypeInputPriceForGift ||
                self.alterType == FDAltertViewTypeEditInputPrice ||
                self.alterType == FDAltertViewTypeEditInputPriceForGift) {
                [_delegate alertView:self clickedButtonAtIndex:index WithInputStr:self.addPriceTxt.text];
            }
            else if (self.alterType == FDAltertViewTypeInputCode ||
                     self.alterType == FDAltertViewTypeInputCodeForGift ||
                     self.alterType == FDAltertViewTypeEditInputCode ||
                     self.alterType == FDAltertViewTypeEditInputCodeForGift ||
                     self.alterType == FDAltertViewTypeAddMark)
            {
                //备注格式错误
                if ([Utils stringContainsEmoji:self.goodsCodeTxt.text]) {
                    [[NSToastManager manager] showtoast:@"请不要输入表情！"];
                    return;
                }
                
                if (self.goodsCodeTxt.text.length == 0 ||
                    [self.goodsCodeTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
                    [[NSToastManager manager] showtoast:@"请输入内容"];
                    return;
                }
                [_delegate alertView:self clickedButtonAtIndex:index WithInputStr:self.goodsCodeTxt.text];
            }
            else
            {
                [_delegate alertView:self clickedButtonAtIndex:index WithInputStr:nil];
            }
            
        }
        if (self.buttonBlock) {
            NSInteger index = [_buttonTitleArray indexOfObject:button.titleLabel.text];
            self.buttonBlock(index,nil);
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:WithInputStr:)])
        {
            [_delegate alertView:self clickedButtonAtIndex:0 WithInputStr:nil];
        }
        if (self.buttonBlock) {
            self.buttonBlock(0,nil);
        }
    }
    
    [self hide];
}

- (void)closeFDAlterView
{
    [self hide];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    NSArray *windowViews = [window subviews];
//    if(windowViews && [windowViews count] > 0){
//        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
//        for(UIView *aSubView in subView.subviews)
//        {
//            [aSubView.layer removeAllAnimations];
//        }
//
//    }
    [window addSubview:self];
    [self showBackground];
    [self showAlertAnimation];
}

- (void)hide {
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}


- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index {
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark -- UITextFieldDelegate
/**控制金额的输入*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.addPriceTxt == textField) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string] ;
        if (textField.text.length >= 9 && ![string isEqualToString:@""] && [textField.text rangeOfString:@"."].location == NSNotFound && ![string isEqualToString:@"."]) {
            return NO;
        }
        //限制.后面最多有两位，且不能再输入.
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            //有.了 且.后面输入了两位  停止输入
            if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
                return NO;
            }
            //有.了，不允许再输入.
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
        //限制首位0，后面只能输入.
        if ([textField.text isEqualToString:@"0"]) {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            if (![string isEqualToString:@"."]) {
                return NO;
            }
        }
        
        //限制只能输入：1234567890.
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];

    }
    return YES;
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.goodsCodeTxt) {
        if (self.alterType == FDAltertViewTypeInputCode ||
            self.alterType == FDAltertViewTypeInputCodeForGift ||
            self.alterType == FDAltertViewTypeEditInputCode ||
            self.alterType == FDAltertViewTypeEditInputCodeForGift) {
            if (textView.text.length >= 100 && ![text isEqualToString:@""]) {
                return NO;
            }
        }
        if (textView.text.length >= 100 && ![text isEqualToString:@""]) {
            return NO;
        }
        if ([self stringContainsEmoji:text]) {
            [[NSToastManager manager] showtoast:@"请不要输入表情！"];
            //            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = [textView.text noEmoji];
}

//表情符号的判断
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        if (0x278b <= hs && hs <= 0x2792) {
                                            //自带九宫格拼音键盘
                                            returnValue = NO;;
                                        }else if (0x263b == hs) {
                                            returnValue = NO;;
                                        }else {
                                            returnValue = YES;
                                        }
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
