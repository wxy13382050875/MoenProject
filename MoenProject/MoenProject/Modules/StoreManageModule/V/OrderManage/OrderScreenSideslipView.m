//
//  OrderScreenSideslipView.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/27.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderScreenSideslipView.h"
#import "KWTypeConditionCCell.h"

@implementation KWOSSVDataModel
@end


@interface OrderScreenSideslipView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *popSheetView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) KWOSSVDataModel *dataModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) KWOrderScreenSideslipViewActionBlock actionBlock;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIButton *confirmBtn;


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
    
    self.collectionView.frame = CGRectMake(0, 40, self.popSheetView.frame.size.width, self.popSheetView.frame.size.height - 83);
    [self.popSheetView addSubview:self.collectionView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    titleLab.textColor = AppTitleBlackColor;
    titleLab.text = @"下单时间";
    [self.popSheetView addSubview:titleLab];
    
    
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KWOSSVDataModel *model = self.dataArr[indexPath.row];
    KWTypeConditionCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWTypeConditionCCell" forIndexPath:indexPath];
    [cell showDataWithKWOSSVDataModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    for (KWOSSVDataModel *model in self.dataArr) {
        model.isSelected = NO;
    }
    KWOSSVDataModel *model = self.dataArr[indexPath.row];
    model.isSelected = YES;
    [self.collectionView reloadData];
//    if (self.actionBlock) {
//        self.actionBlock(model, indexPath.row);
//    }
//    [self dismiss];
}


- (void)resetBtnAction
{
    for (KWOSSVDataModel *model in self.dataArr) {
        model.isSelected = NO;
    }
    KWOSSVDataModel *model = self.dataArr[0];
    model.isSelected = YES;
    [self.collectionView reloadData];
}

- (void)confirmBtnAction
{
    for (KWOSSVDataModel *model in self.dataArr) {
        if (model.isSelected) {
            if (self.actionBlock) {
                self.actionBlock(model, 0);
            }
            break;
        }
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

@end
