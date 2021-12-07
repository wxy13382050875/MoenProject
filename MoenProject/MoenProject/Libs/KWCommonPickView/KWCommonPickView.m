//
//  KWCommonPickView.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import "KWCommonPickView.h"

@implementation KWCPDataModel

@end


#define KyQLCommonPickerView [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]

static CGFloat bgViewHeith = 240;
static CGFloat cityPickViewHeigh = 200;
static CGFloat toolsViewHeith = 40;
static CGFloat animationTime = 0.25;

@interface KWCommonPickView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UIView *bgView;              /** 背景view */

@property (nonatomic, strong) UIView *toolsView;           /** 自定义标签栏 */

@property (nonatomic, strong) UIPickerView *cityPickerView;/** 城市选择器 */

@property (nonatomic, strong) UIButton *sureButton;        /** 确认按钮 */

@property (nonatomic, strong) UIButton *canselButton;      /** 取消按钮 */

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) KWCPDataModel *selectedModel;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end

@implementation KWCommonPickView

- (instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.type = type;
        [self initBaseData];
        [self initSubViews];
    }
    return self;
}

/**数据初始化*/
- (void)initBaseData{
}

/**初始化子视图*/
- (void)initSubViews{
    
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelfView)]];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolsView];
    [self.toolsView addSubview:self.canselButton];
    [self.toolsView addSubview:self.sureButton];
    
    [self.toolsView addSubview:self.titleLabel];
//    if (self.title.length) {
//        self.titleLabel.text = self.title;
//
//    }
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.toolsView.mas_centerX);
        make.centerY.equalTo(self.toolsView.mas_centerY);
    }];
    
    [self.bgView addSubview:self.cityPickerView];
    
    UIWindow *view = [UIApplication sharedApplication].keyWindow;
    [self setHidden:YES];
    [view addSubview:self];
}

- (void)setTitle:(NSString *)title{
    
//    _title = title;
    self.titleLabel.text = title;
    
}


- (void)canselButtonClick{
    [self dismissHXDCityChoosePickerView];
}

- (void)sureButtonClick{
    self.selectedModel = self.dataArr[self.selectedIndex];
    if (self.confirmBlock) {
        self.confirmBlock(self.selectedModel);
    }
    [self dismissHXDCityChoosePickerView];
}

/**点击黑色背景 回收视图*/
- (void)clickSelfView
{
    [self dismissHXDCityChoosePickerView];
}

/**点击工具视图 用于减小点击回收的区域*/
- (void)CancelClick
{
    //点击填充区域无响应
}

#pragma mark private methods
/**展现*/
- (void)showWithDataArray:(NSMutableArray *)dataArr WithConfirmBlock:(ConfirmBlock)confirmBlock
{
    self.dataArr = dataArr;
    self.confirmBlock = confirmBlock;
    [self.cityPickerView reloadAllComponents];
    self.selectedIndex = 0;
    [self.cityPickerView selectRow:0 inComponent:0 animated:NO];
    [self setHidden:NO];
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, self.frame.size.height - bgViewHeith, self.frame.size.width, bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}

/**消失*/
- (void)dismissHXDCityChoosePickerView{
    
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, bgViewHeith);
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

- (void)releasePickView
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    
}


#pragma mark - pickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.dataArr.count;
    
}

#pragma mark - pickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    KWCPDataModel *model = self.dataArr[row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 40)];
    label.font = FONT(18);
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = model.titleName;    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectedIndex = row;
    
    
    if (self.type == 1) {
//        if (component == 0) {
//            self.secondArr = [self handleSecondArr:row];
//            [self.cityPickerView reloadComponent:1];
//            [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
//            self.firstStr = self.firstArr[row];
//            if (self.secondArr.count) {
//                YQLAddressFloorModel *model = self.secondArr[0];
//                self.secondStr = model.title;
//                self.selectedModel = self.secondArr[0];
//            }
//
//        }
//        else if (component == 1)
//        {
//            if (self.secondArr.count) {
//                YQLAddressFloorModel *model = self.secondArr[row];
//                self.secondStr = model.title;
//                self.selectedModel = self.secondArr[row];
//            }
//        }
    }else if (self.type == 2){
//        if (component == 0) {
//            self.secondArr = self.secondMainArr[row];
//            [self.cityPickerView reloadComponent:1];
//            [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
//            self.firstStr = self.firstArr[row];
//            if (self.secondArr.count) {
//                self.secondStr = self.secondArr[0];
//
//            }
//
//        }
//        else if (component == 1)
//        {
//            if (self.secondArr.count) {
//                self.secondStr = self.secondArr[row];
//            }
//        }
        
    }
    
}

- (NSArray *)handleSecondArr:(NSInteger)row
{
    NSArray *temp2 = [[NSArray alloc] init];
    
    if (row == 0) {
//        temp2 = self.floorList.noLift;
    }
    else if (row == 1)
    {
//        temp2 = self.floorList.hasLift;
    }
    return temp2;
}



#pragma mark - lazy

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, bgViewHeith)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelClick)]];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIPickerView *)cityPickerView{
    if (!_cityPickerView) {
        _cityPickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolsViewHeith, self.frame.size.width, cityPickViewHeigh)];
            pickerView.backgroundColor = [UIColor whiteColor];
            [pickerView setShowsSelectionIndicator:YES];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView;
        });
    }
    return _cityPickerView;
}

- (UIView *)toolsView{
    
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolsViewHeith)];
        _toolsView.backgroundColor = KyQLCommonPickerView;
    }
    return _toolsView;
}

- (UIButton *)canselButton{
    if (!_canselButton) {
        _canselButton = ({
            UIButton *canselButton = [UIButton buttonWithType:UIButtonTypeSystem];
            canselButton.frame = CGRectMake(20, 0, 50, toolsViewHeith);
            canselButton.titleLabel.font = FONT(17);
            [canselButton setTitle:@"取消" forState:UIControlStateNormal];
            [canselButton addTarget:self action:@selector(canselButtonClick) forControlEvents:UIControlEventTouchUpInside];
            canselButton;
        });
    }
    return _canselButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = ({
            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
            sureButton.frame = CGRectMake(self.frame.size.width - 20 - 50, 0, 50, toolsViewHeith);
            sureButton.titleLabel.font = FONT(17);
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            sureButton;
        });
    }
    return _sureButton;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = AppNavTitleBlackColor;
    }
    return _titleLabel;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (KWCPDataModel *)selectedModel
{
    if (!_selectedModel) {
        _selectedModel = [[KWCPDataModel alloc] init];
    }
    return _selectedModel;
}

- (void)dealloc
{
    NSLog(@"================>>>>>>地区选择器释放");
}

@end
