//
//  KSegmentScrollViewController.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/19.
//

#import "KSegmentScrollViewController.h"
#import "KSegmentMenuView.h"

@interface KSegmentScrollViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectdIndex;
}
@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) NSArray *childControllers;

@property (nonatomic, strong) KSegmentMenuView *menuView;

@end

@implementation KSegmentScrollViewController

- (instancetype)initWithControllers:(NSArray *)controllers
                              frame:(CGRect)frame
                         menuHeight:(CGFloat)menuHeight
                             titles:(NSArray *)titles
                          titleFont:(UIFont *)titleFont
                      selectedColor:(UIColor *)selectedColor
                        normalColor:(UIColor *)normalColor
                          lineColor:(UIColor *)lineColor
                      selectedIndex:(NSInteger)selectdIndex {
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = AppBgBlueGrayColor;
        self.childControllers = controllers;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _selectdIndex = selectdIndex;
        
        WEAKSELF
        self.menuView = [[KSegmentMenuView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, menuHeight) titles:titles titleFont:titleFont selectedColor:selectedColor normalColor:normalColor lineColor:lineColor selectedIndex:selectdIndex selectBlock:^(NSInteger menuIndex) {
            
            [weakSelf setSelectedIndex:menuIndex];
            
        }];
        
        [self.view addSubview:self.menuView];
        [self setMainScrollView];
        
    }
    return self;
}

- (void)setMainScrollView{
    CGFloat oriY = self.menuView.frame.size.height ?( CGRectGetMaxY(self.menuView.frame)):0;
    CGFloat mainHeight =self.view.frame.size.height - oriY;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,oriY , self.view.frame.size.width, mainHeight)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.childControllers.count, 0);
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(oriY);
    }];
    
    //    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.top.bottom.equalTo(self.view);
    //    }];
    
    for (NSInteger i = 0; i < self.childControllers.count; i ++) {
        UIViewController *childController = self.childControllers[i];
        if (i == _selectdIndex) {
            childController.view.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.frame) * i, 0, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
            
            [self.mainScrollView addSubview:childController.view];
            childController.view.sd_height = mainHeight;
            
        }
        [self addChildViewController:childController];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //设置宽度 不然 宽度为600
    self.view.sd_width = SCREEN_WIDTH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - setter
//点击回调
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    self.menuView.selectedIndex = selectedIndex;
    
    CGFloat offsetX = selectedIndex * self.mainScrollView.frame.size.width;
    CGFloat offsetY = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.mainScrollView setContentOffset:offset animated:YES];
    
    //贴上视图
    //    UIViewController *childController = self.childControllers[selectedIndex];
    //    childController.view.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.frame) * selectedIndex, 0, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
    //
    //    if ([self.mainScrollView.subviews containsObject:childController.view]) {
    //        [childController.view removeFromSuperview];
    //    }
    //    [self.mainScrollView addSubview:childController.view];
    //
    //    [self addChildViewController:childController];
    //    if (self.selectedActionBlock) {
    //        self.selectedActionBlock(selectedIndex);
    //    }
}
- (void)setMenuTitleAliment:(MenuViewTitleAlinment)menuTitleAliment{
//    _menuTitleAliment = menuTitleAliment;
    
    [self.menuView setTitleAliment:menuTitleAliment];
    
}

- (void)setPriceSelectedBlock:(MenuViewSelectBlock)priceSelectedBlock {
    self.menuView.priceSelectedBlock = priceSelectedBlock;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    //设置被选中位置
    if (_selectdIndex == index) {
        return;
    }
    _selectdIndex = index;
    self.menuView.selectedIndex = index;
    
    //滑动回调
    UIViewController *childController = self.childControllers[_selectdIndex];
    childController.view.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.frame) * _selectdIndex, 0, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(self.mainScrollView.frame));
    if ([self.mainScrollView.subviews containsObject:childController.view]) {
        [childController.view removeFromSuperview];
    }
    [self.mainScrollView addSubview:childController.view];
    
    [self addChildViewController:childController];
    if (self.selectedActionBlock) {
        self.selectedActionBlock(_selectdIndex);
    }
    
}


/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
