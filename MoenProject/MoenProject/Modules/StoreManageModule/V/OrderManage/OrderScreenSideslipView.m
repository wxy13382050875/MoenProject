//
//  OrderScreenSideslipView.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderScreenSideslipView.h"
#import "KWTypeConditionCCell.h"
#import "ZLTimeView.h"
@interface OrderScreenSideslipView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,ZLTimeViewDelegate>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *popSheetView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) KWOSSVDataModel *dataModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) KWOrderScreenSideslipViewActionBlock actionBlock;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) XwScreenModel *model;//选中筛选条件

@property (nonatomic, strong) ZLTimeView *timeView;

@end

@implementation OrderScreenSideslipView

- (instancetype)initWithMarginTop:(CGFloat)marginTop
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self configBaseUIWithMarginTop:marginTop];
    }
    return self;
}

- (void)configBaseUIWithMarginTop:(CGFloat)marginTop
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.containerView.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
    self.containerView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.6);
    self.containerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelClick)];
    tap1.delegate = self;
    [self.containerView addGestureRecognizer:tap1];
    [self addSubview:self.containerView];
    
    
    self.popSheetView.frame = CGRectMake(83, 0, SCREEN_WIDTH - 85, SCREEN_HEIGHT - marginTop);
    [self.containerView addSubview:self.popSheetView];
    
    self.collectionView.frame = CGRectMake(0, 0, self.popSheetView.frame.size.width, self.popSheetView.frame.size.height - 43);
    [self.popSheetView addSubview:self.collectionView];

    
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.popSheetView.frame.size.height - 43, self.popSheetView.frame.size.width/2, 43)];
    [resetBtn setBackgroundColor:UIColorFromRGB(0xB7C9D3)];
    [resetBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [resetBtn addTarget:self action:@selector(resetBtnAction) forControlEvents:UIControlEventTouchDown];
    self.resetBtn = resetBtn;
    [self.popSheetView addSubview:resetBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.popSheetView.frame.size.width/2, self.popSheetView.frame.size.height - 43, self.popSheetView.frame.size.width/2, 43)];
    [confirmBtn setBackgroundColor:UIColorFromRGB(0x1A355C)];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchDown];
    self.confirmBtn = confirmBtn;
    [self.popSheetView addSubview:confirmBtn];
}

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWOrderScreenSideslipViewActionBlock)actionBlock
{
//    self.model = nil
    self.actionBlock = actionBlock;
    self.dataArr = dataArr;
//    [self upDatePopSheetView];
    [self.collectionView reloadData];
    [self present];
}

- (void)upDatePopSheetView
{
    CGFloat popViewH = 0;
    NSInteger dataCount = self.dataArr.count;
    if (dataCount > 4) {
        popViewH = 160;
    }
    else
    {
        popViewH = 40 * dataCount;
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, popViewH);
    self.popSheetView.frame = frame;
    self.collectionView.frame = frame;
}

- (void)CancelClick
{
    [self dismiss];
}

- (void)present
{
    UIWindow *view = [UIApplication sharedApplication].keyWindow;
    //    [self setHidden:YES];
    [view addSubview:self];
}

- (void)popViewAction
{
    [self removeFromSuperview];
}


- (void)dismiss
{
//    if (self.actionBlock) {
//        self.actionBlock(nil, 0);
//    }
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self ||
        touch.view == self.containerView) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.popSheetView.frame.size.width - 40)/2, 30);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XwScreenModel* model = self.dataArr[section];
    return model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    KWOSSVDataModel *model = self.dataArr[indexPath.row];
    KWTypeConditionCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWTypeConditionCCell" forIndexPath:indexPath];
    XwScreenModel* model = self.dataArr[indexPath.section];
    
    [cell showDataWithKWOSSVDataModel:model.list[indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH - 85, 40);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    XwScreenModel* model = self.dataArr[section];
    if(model.showFooter){
        return CGSizeMake(SCREEN_WIDTH - 85, 70);
    } else {
        return CGSizeZero;
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XwScreenModel* model = self.dataArr[indexPath.section];
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        
        UILabel* titleLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#333333") WithNumOfLine:1 WithBackColor:[UIColor whiteColor] WithTextAlignment:NSTextAlignmentLeft WithFont:  14];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [header addSubview: titleLabel];
        
        titleLabel.sd_layout.centerYEqualToView(header)
        .leftSpaceToView(header, 5)
        .rightSpaceToView(header, 10)
        .heightIs(30);
        
        
        titleLabel.text = model.title;
        
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        if(model.showFooter){
            UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
            
            UILabel* titleLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#333333") WithNumOfLine:1 WithBackColor:[UIColor whiteColor] WithTextAlignment:NSTextAlignmentLeft WithFont:  14];
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [footer addSubview: titleLabel];
            
            titleLabel.sd_layout.topSpaceToView(footer, 5)
            .leftSpaceToView(footer, 5)
            .rightSpaceToView(footer, 10)
            .heightIs(30);
            titleLabel.text = @"时间段";
            
//            ZLTimeView *timeView = [ZLTimeView new];
//            timeView.delegate = self;
            [footer addSubview: self.timeView];
            self.timeView.sd_layout.topSpaceToView(titleLabel, 5)
            .leftSpaceToView(footer, 10)
            .rightSpaceToView(footer, 10)
            .heightIs(30);
            
            return footer;
        }
        
        
        
        
        return nil;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    XwScreenModel* tmodel = self.dataArr[indexPath.section];
    for (KWOSSVDataModel *model in tmodel.list) {
        model.isSelected = NO;
    }
    KWOSSVDataModel *model = tmodel.list[indexPath.row];
    model.isSelected = YES;
    [self.collectionView reloadData];
}

- (void)timeView:(ZLTimeView *)timeView seletedDateBegin:(NSString *)beginTime end:(NSString *)endTime {
    // TODO: 进行上传时间段
    self.model.dateStart = beginTime;
    self.model.dateEnd = endTime;
}


- (void)resetBtnAction
{
    for (XwScreenModel *model in self.dataArr) {
        for (KWOSSVDataModel *model1 in model.list) {
            model1.isSelected = NO;
        }
    }
    XwScreenModel *tmodel = self.dataArr[0];
    KWOSSVDataModel *model = tmodel.list[0];
    model.isSelected = YES;
    [self.collectionView reloadData];
}

- (void)confirmBtnAction
{
    NSMutableArray* array = [NSMutableArray array];
    for (XwScreenModel *model in self.dataArr) {
        for (KWOSSVDataModel *model1 in model.list) {
            if (model1.isSelected) {//将所有选中的tag放到一个模型中方便处理
                XWSelectModel* tmd = [XWSelectModel new];
                tmd.module = model.className;
                tmd.selectID = model1.itemId;
                
                [array addObject:tmd];

//                break;
            }
        }
    }
    self.model.selectList = array;
    if (self.actionBlock) {
        self.actionBlock(self.model, 0);
    }
    
    [self dismiss];
}

#pragma Mark- getters and setters
- (UIView *)popSheetView
{
    if (!_popSheetView) {
        _popSheetView = [[UIView alloc] init];
        _popSheetView.backgroundColor = UIColor.whiteColor;
        [_popSheetView setUserInteractionEnabled:YES];
    }
    return _popSheetView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView setUserInteractionEnabled:YES];
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.popSheetView.frame.size.width, self.popSheetView.frame.size.height - 83) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"KWTypeConditionCCell" bundle:nil] forCellWithReuseIdentifier:@"KWTypeConditionCCell"];
        //注册header
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        
        //注册header
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    }
    return _collectionView;
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
-(XwScreenModel*)model{
    if(!_model){
        _model = [XwScreenModel new];
        _model.dateStart =[[NSDate date] timeFormat:@"yyyy-MM-dd"];
        _model.dateEnd =[[NSDate date] timeFormat:@"yyyy-MM-dd"];
    }
    return _model;
}
-(ZLTimeView*)timeView{
    if(!_timeView){
        _timeView = [ZLTimeView new];
        _timeView.delegate = self;
        
    }
    return _timeView;
}
@end
