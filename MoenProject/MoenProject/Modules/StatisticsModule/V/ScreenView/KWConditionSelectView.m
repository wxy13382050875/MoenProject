//
//  KWConditionSelectView.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/31.
//

#import "KWConditionSelectView.h"
#import "KWConditionSelectTCell.h"

@implementation KWCSVDataModel
@end



@interface KWConditionSelectView()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *popSheetView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) KWCSVDataModel *dataModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) KWConditionSelectViewActionBlock actionBlock;



@end

@implementation KWConditionSelectView

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
    self.containerView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.8);
    self.containerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelClick)];
    tap1.delegate = self;
    [self.containerView addGestureRecognizer:tap1];
    [self addSubview:self.containerView];
    
    self.popSheetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    [self.containerView addSubview:self.popSheetView];
    
    self.tableview.frame = self.popSheetView.frame;
    [self.popSheetView addSubview:self.tableview];
}

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWConditionSelectViewActionBlock)actionBlock
{
    self.actionBlock = actionBlock;
    self.dataArr = dataArr;
    [self upDatePopSheetView];
    [self.tableview reloadData];
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
        popViewH = 45 * dataCount;
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, popViewH);
    self.popSheetView.frame = frame;
    self.tableview.frame = frame;
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
    if (self.actionBlock) {
        self.actionBlock(nil, 0);
    }
    [self removeFromSuperview];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KWConditionSelectTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KWConditionSelectTCell" forIndexPath:indexPath];
    KWCSVDataModel *model = (KWCSVDataModel *)self.dataArr[indexPath.row];
    [cell showDataWithKWCSVDataModel:model];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KWCSVDataModel *model = (KWCSVDataModel *)self.dataArr[indexPath.row];
    
    if (model.isSelected) {
        return;
    }
    else
    {
        for (KWCSVDataModel *item in self.dataArr) {
            if (model != item) {
                item.isSelected = NO;
            }
            else
            {
                model.isSelected = YES;
            }
        }
        if (self.actionBlock) {
            self.actionBlock(model, 1);
        }
        [self popViewAction];
    }
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



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview setUserInteractionEnabled:YES];
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableview registerNib:[UINib nibWithNibName:@"KWConditionSelectTCell" bundle:nil] forCellReuseIdentifier:@"KWConditionSelectTCell"];
    }
    return _tableview;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
