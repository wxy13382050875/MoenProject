//
//  KSegmentMenuView.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/19.
//

#import "KSegmentMenuView.h"

static NSInteger const kBaseButtonTag = 600;
static CGFloat const kLeadingSpace = 10.0f;
static CGFloat const kBetweenSpace = 30.0f;
static CGFloat const kLineHeight = 2.0f;

@interface KSegmentMenuView ()<UIScrollViewDelegate>
{
    UIButton *_currentButton;
    MenuViewSelectBlock _selectBlock;
}
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *titlesArr;

@property (nonatomic,strong) UIFont *titleFont;

@property (nonatomic,strong) UIColor *titleColor;

//滑动条
@property (nonatomic,strong) UILabel *bottomLine;

@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic,assign) CGFloat menuHeight;

//被选中颜色
@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) UIColor *normalColor;

@end

@implementation KSegmentMenuView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)titleFont
                selectedColor:(UIColor *)selectedColor
                  normalColor:(UIColor *)normalColor
                    lineColor:(UIColor *)lineColor
                selectedIndex:(NSInteger)selectdIndex
                  selectBlock:(MenuViewSelectBlock)selectBlock{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        _selectBlock = selectBlock;
        self.menuHeight = frame.size.height;
        self.titleFont = titleFont;
        self.titlesArr = [NSMutableArray arrayWithArray:titles];
        self.lineColor = lineColor;
        self.selectedColor = selectedColor;
        self.normalColor = normalColor;
        
        
        /**添加ScrollView*/
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        
        CGFloat totalWidth = [self createSubItemsWithTitles:titles];
        self.scrollView.contentSize = CGSizeMake(totalWidth, CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        
        [self createBottomLine];
        
        [self addSubview:self.scrollView];
        
        
        
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectedIndex:selectdIndex];
    }
    return self;
}


- (CGFloat)createSubItemsWithTitles:(NSArray *)titles{
    
    //创建Menu按钮 不固定屏宽
    if (titles.count > 5) {
        CGFloat totalWidth = kLeadingSpace;
        for (NSInteger i = 0; i < titles.count; i++) {
            
            NSString *titleStr = titles[i];
            CGFloat titleWidth = [self getWidthWithContent:titleStr font:self.titleFont];
            
            if ([titleStr isEqualToString:@"价格"]) {
//                ClassifySortButton *button = [[ClassifySortButton alloc] initWithFrame:CGRectMake(totalWidth, 0, titleWidth, CGRectGetHeight(self.scrollView.frame) - kLineHeight)];
//                button.backgroundColor = [UIColor whiteColor];
//                //设置字体信息
//                button.titleLabel.font = self.titleFont;
//                [button setTitle:titles[i] forState:UIControlStateNormal];
//                [button setTitleColor:self.normalColor forState:UIControlStateNormal];
//                [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
//                button.tag = kBaseButtonTag + i;
//                button.titleLabel.font = self.titleFont;
//                button.upSelectedIconStr = @"btn_up";
//                button.downSelectedIconStr = @"btn_down";
//                button.normalSelectedIconStr = @"btn_choose";
//                button.selectState = 0;
//                [button addTarget:self action:@selector(itemSelectedPrice:) forControlEvents:UIControlEventTouchUpInside];
//                [self.scrollView addSubview:button];
                
            }else {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalWidth, 0, titleWidth, CGRectGetHeight(self.scrollView.frame))];
                [button setTitle:titles[i] forState:UIControlStateNormal];
                [button setTitleColor:self.normalColor forState:UIControlStateNormal];
                [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
                [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = kBaseButtonTag + i;
                button.titleLabel.font = self.titleFont;
                [self.scrollView addSubview:button];
                
                if (i == self.selectedIndex) {
                    _currentButton = button;
                }
                
                
            }
            totalWidth += titleWidth + kBetweenSpace + ((i == (titles.count - 1))?1:0) *(kLeadingSpace - kBetweenSpace );//最后一次不用kBetweenSpace
        }
        return totalWidth;
    }
    
    else
    {
        
        CGFloat totalWidth = 0;
        CGFloat leftMargin = 0;
        CGFloat itemWidth = 0;
        CGFloat spaaceWidth = 0;
        if (titles.count == 4) {
            leftMargin = 15;
            totalWidth = leftMargin;
            spaaceWidth = 0;
            itemWidth = (self.frame.size.width - leftMargin*2)/titles.count;
        }
        else if (titles.count == 3)
        {
            leftMargin = 15;
            totalWidth = leftMargin;
            spaaceWidth = 30;
            itemWidth = (self.frame.size.width - leftMargin*2 - spaaceWidth * 2)/titles.count;
        }
        else if (titles.count == 2)
        {
            leftMargin = 15;
            totalWidth = leftMargin;
            spaaceWidth = 30;
            itemWidth = (self.frame.size.width - leftMargin*2 - spaaceWidth)/titles.count;
        }
        
        /*字符总长度*/
//        NSString *string = [titles componentsJoinedByString:@""];
//        CGFloat titleWidth = [self getWidthWithContent:string font:self.titleFont];
//        titleLength = titleWidth;
        
//        spaaceWidth = (self.frame.size.width - 40 - titleLength) / (titles.count - 1);
//        if (titles.count == 2) {
//            spaaceWidth = 20;
//        }
        
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *titleStr = titles[i];
//            CGFloat strLength = [self getWidthWithContent:titleStr font:self.titleFont];
            
            if ([titleStr isEqualToString:@"价格"]) {
//                ClassifySortButton *button = [[ClassifySortButton alloc] initWithFrame:CGRectMake(totalWidth, 0, strLength, CGRectGetHeight(self.scrollView.frame) - kLineHeight)];
//                button.backgroundColor = [UIColor whiteColor];
//                //设置字体信息
//                button.titleLabel.font = self.titleFont;
//                [button setTitle:titles[i] forState:UIControlStateNormal];
//                button.tag = kBaseButtonTag + i;
//                button.titleLabel.font = self.titleFont;
//                button.upSelectedIconStr = @"btn_up";
//                button.downSelectedIconStr = @"btn_down";
//                button.normalSelectedIconStr = @"btn_choose";
//                button.selectState = 0;
//                [button setTitleColor:self.normalColor forState:UIControlStateNormal];
//                [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
//                [button addTarget:self action:@selector(itemSelectedPrice:) forControlEvents:UIControlEventTouchUpInside];
//                [self.scrollView addSubview:button];
                
            }else {
//                if (titles.count == 2) {
//                    strLength = (self.frame.size.width - 60)/2;
//                }
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalWidth, 0, itemWidth, CGRectGetHeight(self.scrollView.frame) - kLineHeight)];
                [button setTitle:titles[i] forState:UIControlStateNormal];
                [button setTitleColor:self.normalColor forState:UIControlStateNormal];
                [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
                [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = kBaseButtonTag + i;
                button.titleLabel.font = self.titleFont;
                [self.scrollView addSubview:button];
                if (i == self.selectedIndex) {
                    _currentButton = button;
                }
            }
            totalWidth += itemWidth + spaaceWidth;
        }
        return SCREEN_WIDTH;
    }
    
}

- (void)setContentSizeWidthAdjust:(BOOL)yes{
    if (yes) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetHeight(self.scrollView.frame));
    }
    
}


- (void)createBottomLine{
    
    /**底部分割线*/
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.scrollView.frame.size.height - 1, self.scrollView.frame.size.width - 30, 1)];
    lineView.backgroundColor = AppLineBlueGrayColor;
    [self.scrollView addSubview:lineView];
    
    CGFloat oriX = _currentButton.frame.origin.x;
    CGFloat oriY = CGRectGetMaxY(_currentButton.frame);
    CGFloat itemWidth = _currentButton.frame.size.width;
//    CGFloat strLength = [self getWidthWithContent:_currentButton.titleLabel.text font:self.titleFont];
//    if (self.titlesArr.count == 2) {
//        strLength = (self.frame.size.width - 60)/2;
//    }
    self.bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(oriX, oriY, itemWidth, kLineHeight)];
    self.bottomLine.backgroundColor = self.lineColor;
    
    [self.scrollView addSubview:self.bottomLine];
}

//- (void)itemSelectedPrice:(ClassifySortButton *)selectedButton {
//
//    if (_currentButton == selectedButton) {
//        if (selectedButton.selectState == 2) {
//            selectedButton.selectState = 0;
//        }else {
//            selectedButton.selectState++;
//        }
//        [selectedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
//        [selectedButton setTitleColor:self.selectedColor forState:UIControlStateSelected];
//        if (_priceSelectedBlock) {
//            _priceSelectedBlock(selectedButton.selectState);
//        }
//
//    }else {
//        if (_selectBlock) {
//            _selectBlock(selectedButton.tag - kBaseButtonTag);
//        }
//        [self setSelectedIndex:(selectedButton.tag - kBaseButtonTag)];
//    }
//
//}

- (void)itemSelected:(UIButton *)selectedButton{
    if (_currentButton == selectedButton) {
        return;
    }
    
    if (_selectBlock) {
        _selectBlock(selectedButton.tag - kBaseButtonTag);
    }
    
    [self setSelectedIndex:(selectedButton.tag - kBaseButtonTag)];
}

#pragma mark - setter

- (void)setTitleAliment:(MenuViewTitleAlinment)titleAliment{
    _titleAliment = titleAliment;
    
    
    switch (titleAliment) {
        case MenuViewTitleAlinmentCenter:
        {
            
            NSArray *titles = [NSArray arrayWithArray:self.titlesArr];
            
            for (NSInteger i = 0; i < titles.count; i++) {
                UIButton *button = [self.scrollView viewWithTag:(kBaseButtonTag + i)];
                
                CGFloat marin = SCREEN_WIDTH/30.0f;
                CGFloat padding = 0 ;
                
                CGFloat buttonWidth = (SCREEN_WIDTH - marin * 2 - padding *(titles.count - 1))/((float)titles.count);
                
                if (button) {
                    CGRect frame = button.frame;
                    frame.origin.x = marin + (buttonWidth + padding) * i;
                    frame.size.width = buttonWidth;
                    button.frame = frame;
                    button.titleLabel.textAlignment = NSTextAlignmentCenter;
                }
            }
        }
            break;
        case MenuViewTitleAlinmentDefault:{
#warning TODO 回头补上
        }
            break;
        case MenuViewTitleAlinmentLeft:{
            CGFloat marin = 7.0f;
            
            NSArray *titles = [NSArray arrayWithArray:self.titlesArr];
            CGFloat padding = marin;
            CGFloat buttonWidth = (SCREEN_WIDTH - marin * 6) /5;
            CGRect frame = self.bottomLine.frame;
            frame.size.width = buttonWidth;
            self.bottomLine.frame = frame;
            self.bottomLine.center = CGPointMake(_currentButton.center.x, self.bottomLine.center.y);
            for (NSInteger i = 0; i < titles.count; i++) {
                UIButton *button = [self.scrollView viewWithTag:(kBaseButtonTag + i)];
                
                
                if (button) {
                    CGRect frame = button.frame;
                    frame.origin.x = marin + (buttonWidth + padding) * i;
                    frame.size.width = buttonWidth;
                    button.frame = frame;
                    button.titleLabel.textAlignment = NSTextAlignmentCenter;
                }
            }
            
        }
            break;
        default:
            break;
    }
    //调整
    self.bottomLine.center = CGPointMake(_currentButton.center.x, self.bottomLine.center.y);
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    _currentButton.selected = NO;
    _currentButton = [self.scrollView viewWithTag:kBaseButtonTag + selectedIndex];
    _currentButton.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        //        CGFloat width = _currentButton.frame.size.width;
        CGFloat oriX = _currentButton.frame.origin.x;
        CGFloat oriY = CGRectGetMaxY(_currentButton.frame);
        
        CGFloat buttonWidth = 0;
        switch (self.titleAliment) {
            case MenuViewTitleAlinmentLeft:
            {
                
                buttonWidth = _currentButton.frame.size.width;
                
            }
                break;
                
            default:{
                CGFloat strLength = [self getWidthWithContent:self->_currentButton.titleLabel.text font:FONT(13)];
                
//                [NSTool getAttributeSizeWithText:_currentButton.titleLabel.text fontSize:13].width;
                buttonWidth = strLength;
            }
                break;
        }
        
        
        //        self.bottomLine.frame = CGRectMake(oriX, oriY, buttonWidth, kLineHeight);
        self.bottomLine.center = CGPointMake(_currentButton.center.x, self.bottomLine.center.y);
    } completion:^(BOOL finished) {
        [self adjustScrollView];
        
    }];
}

//调整scrollview 偏移量
- (void)adjustScrollView{
    NSInteger lastIndex = self.selectedIndex - 1;
    NSInteger nextIndex = self.selectedIndex + 1;
    //根据当前 和中心点的差值 判断前移还是后移
    CGFloat DValue = (_currentButton.center.x - self.scrollView.contentOffset.x) - self.frame.size.width/2.0f;
    
    CGFloat currentMinXDiff =  CGRectGetMinX(_currentButton.frame) - self.scrollView.contentOffset.x;
    
    CGFloat currentMaxXDiff = CGRectGetMaxX(_currentButton.frame) - self.scrollView.contentOffset.x;
    //按钮靠后，scroview向前滚动
    if (DValue > 0) {
        
        //最后一个
        if (nextIndex > (self.titlesArr.count - 1)) {
            //当前按钮超出 调整显示
            if (currentMaxXDiff > self.frame.size.width) {
                [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetMinX(_currentButton.frame) + kLeadingSpace, CGRectGetMinY(_currentButton.frame), CGRectGetWidth(_currentButton.frame), CGRectGetHeight(_currentButton.frame)) animated:YES];
            }
            
            return;
        }
        
        //判断后面两个是否显示了
        UIButton *nextButton = [self.scrollView viewWithTag:kBaseButtonTag + nextIndex];
        CGFloat nextBtnMaxDiff = CGRectGetMaxX(nextButton.frame) - self.scrollView.contentOffset.x;
        //下一个按钮超出界面
        if (nextBtnMaxDiff > self.frame.size.width) {
            [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetMinX(nextButton.frame) + kLeadingSpace, CGRectGetMinY(nextButton.frame), CGRectGetWidth(nextButton.frame), CGRectGetHeight(nextButton.frame)) animated:YES];
        }
        
    }else{
        
        //第一个
        if (lastIndex < 0) {
            //当前按钮超出 调整显示
            if (currentMinXDiff < 0) {
                [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetMinX(_currentButton.frame) - kLeadingSpace, CGRectGetMinY(_currentButton.frame), CGRectGetWidth(_currentButton.frame), CGRectGetHeight(_currentButton.frame)) animated:YES];
            }
            return;
        }
        
        UIButton *lastButton = [self.scrollView viewWithTag:kBaseButtonTag + lastIndex];
        CGFloat lastBtnMinXDiff = CGRectGetMinX(lastButton.frame) - self.scrollView.contentOffset.x;
        //上一个按钮超出界面
        if (lastBtnMinXDiff < 0) {
            [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetMinX(lastButton.frame) - kLeadingSpace, CGRectGetMinY(lastButton.frame), CGRectGetWidth(lastButton.frame), CGRectGetHeight(lastButton.frame)) animated:YES];
        }
        
    }
}

#pragma mark - tool method

- (CGFloat)getWidthWithContent:(NSString *)contentStr font:(UIFont *)font {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
}



@end
