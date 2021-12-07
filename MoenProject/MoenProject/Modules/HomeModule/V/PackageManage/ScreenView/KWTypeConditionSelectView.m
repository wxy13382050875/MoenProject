//
//  KWTypeConditionSelectView.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/8.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "KWTypeConditionSelectView.h"
#import "KWTypeConditionCCell.h"
@interface KWTypeConditionSelectView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *popSheetView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SegmentTypeModel *dataModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) KWConditionSelectViewActionBlock actionBlock;

@property (nonatomic, copy) KWTypeConditionSelectViewCancelBlock cancelBlock;

@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation KWTypeConditionSelectView

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
    self.containerView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.7);
    self.containerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelClick)];
    tap1.delegate = self;
    [self.containerView addGestureRecognizer:tap1];
    [self addSubview:self.containerView];
    
    self.popSheetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    [self.containerView addSubview:self.popSheetView];
    
    self.collectionView.frame = self.popSheetView.frame;
    [self.popSheetView addSubview:self.collectionView];
    
    self.itemWidth = (SCREEN_WIDTH - 60)/3;
}

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWConditionSelectViewActionBlock)actionBlock WithCancelBlock:(nonnull KWTypeConditionSelectViewCancelBlock)cancelBlock
{
    self.actionBlock = actionBlock;
    self.cancelBlock = cancelBlock;
    self.dataArr = dataArr;
    [self upDatePopSheetView];
    [self.collectionView reloadData];
    [self present];
}

- (void)upDatePopSheetView
{
    CGFloat popViewH = 0;
    NSInteger dataCount = self.dataArr.count;
    if (dataCount > 12) {
        popViewH = 250;
    }
    else
    {
        popViewH = 180;
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, popViewH);
    self.popSheetView.frame = frame;
    self.collectionView.frame = frame;
}

- (void)CancelClick
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
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
    return CGSizeMake(self.itemWidth, 30);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SegmentTypeModel *model = self.dataArr[indexPath.row];
    KWTypeConditionCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWTypeConditionCCell" forIndexPath:indexPath];
    [cell showDataWithSegmentTypeModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    for (SegmentTypeModel *model in self.dataArr) {
        model.isSelected = NO;
    }
    SegmentTypeModel *model = self.dataArr[indexPath.row];
    model.isSelected = YES;
    [self.collectionView reloadData];
    if (self.actionBlock) {
        self.actionBlock(model.ID, indexPath.row);
    }
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}


#pragma Mark- getters and setters
- (UIView *)popSheetView
{
    if (!_popSheetView) {
        _popSheetView = [[UIView alloc] init];
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
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) collectionViewLayout:flowLayout];
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
