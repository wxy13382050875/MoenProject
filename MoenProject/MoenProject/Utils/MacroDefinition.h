//
//  MacroDefinition.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/8.
//


/**
 *  宏定义
 */
#ifndef MacroDefinition_h
#define MacroDefinition_h



#pragma mark -- 获取设备大小宏定义
//-------------------获取设备大小块-------------------------

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//NavBar高度
#define SCREEN_Nav_HEIGHT 44

//StatusBar高度
#define SCREEN_StatusBar_HEIGHT 20

//NavBar整体高度
//#define SCREEN_NavTop_Height 64

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone

#define SCREEN_NavTop_Height (CGFloat)(kIs_iPhoneX?(88.0):(64.0))

//TabBar高度
#define SCREEN_TabBar_HEIGHT 49

//-------------------获取设备大小-------------------------
#define KWIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define KWIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& KWIs_iphone

/*状态栏高度*/
#define KWStatusBarHeight (CGFloat)(KWIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define KWNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define KWNavBarAndStatusBarHeight (CGFloat)(KWIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define KWTabBarHeight (CGFloat)(KWIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define KWTopBarSafeHeight (CGFloat)(KWIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define KWBottomSafeHeight (CGFloat)(KWIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define KWTopBarDifHeight (CGFloat)(KWIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define KWNavAndTabHeight (KWNavBarAndStatusBarHeight + KWTabBarHeight)





#pragma mark -- 主题颜色宏定义
//----------------------颜色块---------------------------

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR(a) [UIColor colorWithHexString:a]
// -- 背景用色
/**蓝灰色 页面模块底色， 列表底色*/
#define AppBgWhiteColor UIColorFromRGB(0xFFFFFF)

/**白色 页面主背景用色*/
#define AppBgBlueGrayColor UIColorFromRGB(0xF3F3FC)

/**灰色 套餐展开商品，订单页面商品底色*/
#define AppBgGrayColor UIColorFromRGB(0xFBFAFA)

/**冰蓝色 巡店结果，样品展示页面标题底色*/
#define AppBgBlueColor UIColorFromRGB(0xB7C9D3)


/**购物车背景色  */
#define AppBgShoppingCarColor UIColorFromRGB(0xEEF2F4)





// -- 分割线用色
/** [分割线1] 灰色: 一级页面九宫格按钮切分角色*/
#define AppLineGrayColor UIColorFromRGB(0xEAEAEA)

/** [分割线2] 蓝灰：填写资料页面分割线*/
#define AppLineBlueGrayColor UIColorFromRGB(0xF3F3F3)

/** [分割线5] 白色：套餐展开商品分割线，5PX*/
#define AppLineWhiteColor UIColorFromRGB(0xFFFFFF)

/** [分割线6] 冰蓝：登陆页，注册页分割线，1PX*/
#define AppLineBlueColor UIColorFromRGB(0xB7C9D3)

/** [分割线7] 深灰色：数量加减框，1PX*/
#define AppLineDeepGrayColor UIColorFromRGB(0xCACACA)


// -- 文字用色
/** [文字1] 黑色：全局文字用色*/
#define AppTitleBlackColor UIColorFromRGB(0x4E4E4E)

/** [文字2] 灰色：底部导航未选中状态文字，提示文字用色*/
#define AppTitleGrayColor UIColorFromRGB(0xB7B7B7)

/** [文字3] 白色：操作按钮文字用色*/
#define AppTitleWhiteColor UIColorFromRGB(0xFFFFFF)

/** [文字4] 摩恩蓝：登陆页，注册页按钮文字用色*/
#define AppTitleBlueColor UIColorFromRGB(0x5B7F95)

/** [文字5] 砺金：金额，提示性文字用色*/
#define AppTitleGoldenColor UIColorFromRGB(0xC6893F)


/** [文字6] 购物车文字用色*/
//#define AppTitleShoppingCarColor UIColorFromRGB(0x5B7F95)



// -- 按钮用色
/** [按钮1] 冰蓝：登录，注册页按钮默认状态*/
#define AppBtnBlueColor UIColorFromRGB(0xB7C9D3)

/** [按钮2] 深蓝：操作按钮默认状态*/
#define AppBtnDeepBlueColor UIColorFromRGB(0x1B365D)

/** [按钮3] 砺金：删除按钮默认状态*/
#define AppBtnGoldenColor UIColorFromRGB(0xC6893F)














/** Nav标题黑色 、绝大部分深黑色*/
#define AppNavTitleBlackColor UIColorFromRGB(0x323232)

/** TabBarTitle 选中时的颜色*/
#define AppTabBarTitleSelected UIColorFromRGB(0x5B7F95)

/** Segment 选中时的颜色  红色 */
#define AppSegmentSelectedTitleRedColor UIColorFromRGB(0xFF554B)

//状态标识颜色
/** 状态标识颜色 红色 */
#define AppStatusIdeRedColor UIColorFromRGB(0xED1921)

/** 状态标识颜色 绿色 */
#define AppStatusIdeGreenColor UIColorFromRGB(0x14AA9D)

/** 状态标识颜色 蓝色 */
#define AppStatusIdeBlueColor UIColorFromRGB(0x2A98D7)






#pragma mark -- 字体大小宏定义
//-------------------字体大小块-------------------------
//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"Helvetica" size:F]
#define FONTSYS(F) [UIFont systemFontOfSize:F]

//兰亭黑体
#define FONTLanTingB(F) [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:(F + 1)]
#define FONTLanTingR(F) [UIFont fontWithName:@"FZLTHJW--GB1-0" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:(F + 1)]
#define FONTLanTingL(F) [UIFont fontWithName:@"FZLTXHK" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:(F + 1)]

//Din
#define FontBinB(F) [UIFont fontWithName:@"DINPro-Bold" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:(F + 1)]
#define FontBinR(F) [UIFont fontWithName:@"DINPro-Regular" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:(F + 1)]
#define FontBinL(F) [UIFont fontWithName:@"DINPro-Light" size:[[UIScreen mainScreen] bounds].size.height<=667.f? F:[[UIScreen mainScreen] bounds].size.height <= 736.f? (F + 1):(F + 2)]



#pragma mark -- 打印日志宏定义
//----------------------打印日志块---------------------------

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif



#pragma mark -- weakself宏定义
//----------------------weakself块---------------------------
// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;


#pragma mark -- 综合宏定义
//----------------------综合块---------------------------
//定义UIImage对象
#define ImageNamed(imageName) [UIImage imageNamed:imageName]

//#define NSLocalizedStringM(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

/* regist cell(xib) */
#define kRegistCell(tableView, cellName, identifier) [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:identifier];

#define kRegistClassCell(tableView, cellName, identifier) [tableView registerClass:cellName forCellReuseIdentifier:identifier];

#define kRegistCollection(collectionView, cellName, identifier)  [collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:identifier];

#define kSetMJRefresh(view) MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xw_loadNewData)];\
header.lastUpdatedTimeLabel.hidden = YES;\
view.mj_header = header;\
MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(xw_loadMoreData)];\
view.mj_footer = footer;\
[view.mj_header beginRefreshing];


// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];
#endif /* MacroDefinition_h */
