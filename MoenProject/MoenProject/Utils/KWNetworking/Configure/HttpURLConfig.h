//
//  HttpURLConfig.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/24.
//

#ifndef HttpURLConfig_h
#define HttpURLConfig_h


#pragma mark -- 测试路径
/**接口请求地址 -- 开发*/
static NSString * const TestHostName = @"https://crm.waycomtech.com/api";

/**接口请求 主路径*/
static NSString * const TestImageUploadPath = @"https://crm.waycomtech.com/api";



//https://crm.waycomtech.com/demoapi 测试环境
//https://pos.moen.cn/api 生产环境
//https://posdemo.moen.cn/api 培训环境
#pragma mark -- 开发环境
/**接口请求地址 -- 开发*/
//static NSString * const DebugHostName = @"https://posdemo.moen.cn/api";

static NSString * const DebugHostName = @"https://crm.waycomtech.com/api";
/**接口请求 主路径*/
static NSString * const DebugHostPath = @"";

/**接口请求 主路径*/
//static NSString * const DebugImageUploadPath = @"https://posdemo.moen.cn/api";
static NSString * const DebugImageUploadPath = @"https://crm.waycomtech.com/api";

/**接口请求 主路径*/
static NSString * const DebugImageDownloadPath = @"";



#pragma mark -- Distribute


/**接口请求地址 -- 生产*/
//static NSString * const ReleaseHostName = @"https://posdemo.moen.cn/api";
static NSString * const ReleaseHostName = @"https://crm.waycomtech.com/api";
//https://pos.moen.cn/api
//https://posdemo.moen.cn/api
/**接口请求 主路径 -- 生产*/
static NSString * const ReleaseHostPath = @"";

/**接口请求 主路径*/
//static NSString * const ReleaseImageUploadPath = @"https://posdemo.moen.cn/api";
static NSString * const ReleaseImageUploadPath = @"https://crm.waycomtech.com/api";

/**接口请求 主路径*/
static NSString * const ReleaseImageDownloadPath = @"";

//http://47.92.208.157:8088/financer



#pragma Mark -- 网络配置
@interface HttpURLConfig : NSObject

/**配置接口访问地址*/
+(NSString *)configInterfaceAddress;

/**配置上传图片地址*/
+(NSString *)configUploadImageAddress;

/**配置下载图片地址*/
+(NSString *)configDownloadImageAddress;
@end


////////////////////////登录/////////////////////////////////////

/**登录获取Token*/
static NSString * const Path_oauth_token = @"/oauth/token";

/*** 获取验证码 */
static NSString * const Path_sendSMS = @"/v1/app/user/getCheckCode";

/*** 获取验证码(门店员工登录使用) */
static NSString * const Path_getCheckCodeShop = @"/v1/app/user/getCheckCodeShop";

/*** 客户注册获取验证码 */
static NSString * const Path_getCustomerCheckCode = @"/v1/app/user/getCustomerCheckCode";

/*** 忘记密码 */
static NSString * const Path_forgetPassword = @"/v1/app/user/forgetPassword";

/*** 修改密码 */
static NSString * const Path_changePassword = @"/v1/app/user/changePassword";

/*** 首页信息 */
static NSString * const Path_getHomePage = @"/v1/app/user/getHomePage";

/*** 获取登录用户信息 */
static NSString * const Path_getUserConfig = @"/v1/app/user/getUserConfig";


////////////////////////会员信息/////////////////////////////////////

/*** 会员注册 */
static NSString * const Path_registerCustomer = @"/v1/app/customer/registerCustomer";

/*** 获取会员信息 */
static NSString * const Path_getCustomer = @"/v1/app/customer/getCustomer";

/*** 门店二维码 */
static NSString * const Path_shopQRCode = @"/v1/app/customer/shopQRCode";


////////////////////////会员意向/////////////////////////////////////

/*** 门店员工（店长） */
static NSString * const Path_shopPersonal = @"/v1/app/customer/shopPersonal";

/*** 未标注的会员 */
static NSString * const Path_notLabel = @"/v1/app/customer/notLabel";

/*** 门店人员的会员意向 */
static NSString * const Path_customerIntent = @"/v1/app/customer/customerIntent";

/*** 添加意向商品 */
static NSString * const Path_addIntentProduct = @"/v1/app/customer/addIntentProduct";

/*** 删除意向商品 */
static NSString * const Path_deleteIntentProduct = @"/v1/app/customer/deleteIntentProduct";

/*** 删除会员意向 */
static NSString * const Path_deleteIntent = @"/v1/app/customer/deleteIntent";

/*** 修改意向备注信息 */
static NSString * const Path_updateRemark = @"/v1/app/customer/updateRemark";

/*** 会员意向商品列表 */
static NSString * const Path_intentProductList = @"/v1/app/customer/intentProductList";

/*** 会员意向----会员识别之后 */
static NSString * const Path_shopCustomerIntent = @"/v1/app/customer/shopCustomerIntent";


////////////////////////优惠券//////////////////////////////////////

/*** 优惠券列表 */
static NSString * const Path_couponList = @"/v1/app/customer/couponList";



////////////////////////订单//////////////////////////////////////
/*** 查询套餐或商品 */
static NSString * const Path_selectProduct = @"/v1/app/customer/selectProduct";

/*** 卖货柜台 */
static NSString * const Path_sale = @"/v1/app/customer/sale";

/*** 确认订单 */
static NSString * const Path_saveOrder = @"/v1/app/customer/saveOrder";

/*** 订单列表 */
static NSString * const Path_orderList = @"/v1/app/customer/orderList";

/*** 订单详情 */
static NSString * const Path_orderDetail = @"/v1/app/customer/orderDetail";




////////////////////////门店促销//////////////////////////////////////

/*** 活动详情 */
static NSString * const Path_getPromoDetail = @"/v1/app/shop/getPromoDetail";

/*** 门店活动列表 */
static NSString * const Path_getPromoList = @"/v1/app/shop/getPromoList";


/*** 查询促销活动中套餐信息 */
static NSString * const Path_selectPromoCombo = @"/v1/app/customer/selectPromoCombo";



////////////////////////地址管理//////////////////////////////////////

/*** 地址管理列表 */
static NSString * const Path_customerAddress = @"/v1/app/customer/customerAddress";

/*** 新增收货地址 */
static NSString * const Path_save_customerAddress = @"/v1/app/customer/save/customerAddress";

/*** 获取区县 */
static NSString * const Path_getDistricts = @"/v1/app/customer/getDistrict";


/*** 获取市 */
static NSString * const Path_getCity = @"/v1/app/customer/getCity";


/*** 获取省 */
static NSString * const Path_getProvince = @"/v1/app/customer/getProvince";


/*** 获取街道 */
static NSString * const Path_getStreet = @"/v1/app/customer/getStreet";


////////////////////////门店客户//////////////////////////////////////

/*** 门店扩展客户 */
static NSString * const Path_coustomer = @"/v1/app/shop/coustomer";

/*** 门店客户扩展每月详情 */
static NSString * const Path_monthCoustomer = @"/v1/app/shop/monthCoustomer";


#pragma  mark -- 商品管理
////////////////////////商品管理//////////////////////////////////////

/*** 门店商品列表 */
static NSString * const Path_getProductList = @"/v1/app/shop/getProductList";

/*** 获取商品品类 */
static NSString * const Path_getProductCategory = @"/v1/app/shop/getProductCategory";

/*** 商品详情 */
static NSString * const Path_getProductDetail = @"/v1/app/shop/getProductDetail";


#pragma  mark -- 套餐管理
////////////////////////套餐管理//////////////////////////////////////

/*** 套餐列表 */
static NSString * const Path_getComboList = @"/v1/app/shop/getComboList";

/*** 套餐类型 */
static NSString * const Path_getComboTypes = @"/v1/app/shop/getComboTypes";

/*** 套餐详情 */
static NSString * const Path_getComboInfo = @"/v1/app/shop/getComboInfo";

#pragma  mark -- 专业客户
////////////////////////专业客户//////////////////////////////////////

/*** 门店专业客户 */
static NSString * const Path_specialtyCustomer = @"/v1/app/shop/specialtyCustomer";

/*** 获取套餐和门店促销两个点 */
static NSString * const Path_getCheck = @"/v1/app/shop/getCheck";

/*** 新增专业客户 */
static NSString * const Path_addCustomer = @"/v1/app/shop/addCustomer";


#pragma  mark -- 员工管理
////////////////////////员工管理//////////////////////////////////////

/*** 门店人员 */
static NSString * const Path_personal = @"/v1/app/shop/personal";

/*** 添加门店导购 */
static NSString * const Path_addPersonal = @"/v1/app/shop/addPersonal";

/*** 停用导购 */
static NSString * const Path_disablePersonal = @"/v1/app/shop/disablePersonal";



#pragma  mark -- 出样填报
////////////////////////出样填报//////////////////////////////////////

/*** 商品出样填报详情 */
static NSString * const Path_getProductSample = @"/v1/app/shop/getProductSample";

/*** 修改商品出样填报数量 */
static NSString * const Path_updateProductSample = @"/v1/app/shop/updateProductSample";



#pragma  mark -- 出样管理
////////////////////////出样管理//////////////////////////////////////

/*** 出样历史 */
static NSString * const Path_productSampleHistory = @"/v1/app/shop/productSampleHistory";

/*** 发表出样图片 */
static NSString * const Path_publishProductSampleImage = @"/v1/app/shop/publishProductSampleImage";



#pragma  mark -- 巡店查询
////////////////////////巡店查询//////////////////////////////////////

/*** 巡店列表 */
static NSString * const Path_patrolShopList = @"/v1/app/shop/patrolShopList";

/*** 巡店详情 */
static NSString * const Path_patrolShopDetail = @"/v1/app/shop/patrolShopDetail";

/*** 巡店问题详情 */
static NSString * const Path_patrolShopProblemDetail = @"/v1/app/shop/patrolShopProblemDetail";


#pragma  mark -- 优惠券记录
////////////////////////优惠券记录//////////////////////////////////////

/*** 优惠券使用记录（按月） */
static NSString * const Path_couponUsageList = @"/v1/app/shop/couponUsageList";

/*** 优惠券使用记录详情 */
static NSString * const Path_couponUsageRecord = @"/v1/app/shop/couponUsageRecord";



#pragma  mark -- 统计
////////////////////////统计//////////////////////////////////////

/*** 门店销售 */
static NSString * const Path_shopSale = @"/v1/app/statistic/shopSale";

/*** 门店销量 --- 查看其中一个门店人员的数据 */
static NSString * const Path_findOne = @"/v1/app/statistic/shopSale/findOne";

/*** 商品销量 */
static NSString * const Path_productSale = @"/v1/app/statistic/productSale";

/*** 套餐排名 */
static NSString * const Path_setMealRanking = @"/v1/app/statistic/setMealRanking";

/*** 商品品类排名 */
static NSString * const Path_categoryRanking = @"/v1/app/statistic/categoryRanking";

/*** 商品品类排名下的商品信息 */
static NSString * const Path_categoryProduct = @"/v1/app/statistic/categoryProduct";

/*** 今日客户注册数 */
static NSString * const Path_customer = @"/v1/app/statistic/customer";

/*** 首页统计 */
static NSString * const Path_firstPage = @"/v1/app/statistic/firstPage";


#pragma  mark -- 获取下拉数据
////////////////////////获取下拉数据//////////////////////////////////////

/*** 获取下拉数据 */
static NSString * const Path_load = @"/v1/app/customer/getEnums";


#pragma  mark -- 退货
////////////////////////退货//////////////////////////////////////

/*** 退货单列表 */
static NSString * const Path_returnOrderList = @"/v1/app/customer/returnOrderList";

/*** 确认退货 */
static NSString * const Path_saveReturnOrder = @"/v1/app/customer/saveReturnOrder";

/*** 退货单详情 */
static NSString * const Path_returnOrderDetail = @"/v1/app/customer/returnOrderDetail";

/*** 退货柜台---部分 */
static NSString * const Path_ReturnProduct = @"/v1/app/customer/ReturnProduct";

/*** 选择退货商品（整单退货接口共用） */
static NSString * const Path_selectReturnProduct = @"/v1/app/customer/selectReturnProduct";

/*** 关于 */
static NSString * const Path_appInfo = @"/v1/app/user/appInfo";

/**获取版本信息接口*/
static NSString * const Path_versionTerminal = @"/v1/app/user/getAppVersion";

/**短信接口*/
static NSString * const Path_login_sendsmscode = @"login/sendsmscode";

/**忘记密码的短信接口*/
static NSString * const Path_login_checkphone = @"login/checkphone";

/**注册接口*/
static NSString * const Path_login_register = @"login/register";



/**修改密码、忘记密码 接口*/
static NSString * const Path_login_revisepassword = @"login/revisepassword";

/**验证码校验接口*/
static NSString * const Path_login_checkcode = @"login/checkcode";

/**验证码获取接口*/
static NSString * const Path_login_sendcode = @"login/sendcode";

/**是否存在手势*/
static NSString * const Path_details = @"api/gesture/details";

/**退出登录*/
static NSString * const Path_logout = @"login/logout";




/**设置手势*/
static NSString * const Path_addGesture = @"api/gesture/addGesture";



/**手势登录*/
static NSString * const Path_gesture_login = @"api/gesture/login";

/**手势开关*/
static NSString * const Path_switch = @"api/gesture/switch";

/**修改手势密码*/
static NSString * const Path_updateGesture = @"api/gesture/updateGesture";

/**手势密码短信接口*/
static NSString * const Path_gesture_smsCode = @"api/gesture/smsCode";

/**手势校验验证码短信接口*/
static NSString * const Path_gesture_validateSms = @"api/gesture/validateSms";



////////////////////////2019年11月16日 奖励/////////////////////////////////////

/**奖励总览*/
static NSString * const Path_GetTotalReward = @"/v1/app/saleReward/getTotalReward";

/**奖励明细*/
static NSString * const Path_GetRewardList = @"/v1/app/saleReward/getRewardList";

/**奖励统计*/
static NSString * const Path_GetRewardStatistics = @"/v1/app/saleReward/getRewardStatistics";


/**根据会员ID获取会员标签信息*/
static NSString * const Path_GetCustomerTag = @"/v1/app/customer/getCustomerTag";

/**保存会员标签信息*/
static NSString * const Path_SaveCustomerTag = @"/v1/app/customer/saveCustomerTag";




////////////////////////2019年11月16日 奖励/////////////////////////////////////









////////////////////////首页/////////////////////////////////////

/**首页推荐接口*/
static NSString * const Path_homePageProductRecom = @"api/productManager/homePageProductRecom";


/**产品详情接口*/
static NSString * const Path_selHomePageProductInfo = @"api/productManager/selHomePageProductInfo";


/**产品投资记录接口*/
static NSString * const Path_bidderRecord = @"api/productManager/bidderRecord";





///////////////////////融资申请/////////////////////////////////////


/**个人融资申请接口*/
static NSString * const Path_personalApply = @"api/financingPersonal/personalApply";

/**个人融资申请 - 上传图片 接口*/
static NSString * const Path_uploadPerImage = @"api/financingPersonal/uploadPerImage";

/**公司融资申请接口*/
static NSString * const Path_companyApply = @"api/financingCompany/companyApply";

/**公司融资申请 - 上传图片 接口*/
static NSString * const Path_uploadComImage = @"api/financingCompany/uploadComImage";


////////////////////////智选智投/////////////////////////////////////

/**智选智投 接口*/
static NSString * const Path_wisChoWisInvest = @"api/productManager/wisChoWisInvest";


////////////////////////我的账户/////////////////////////////////////

/**上传图片 接口*/
static NSString * const Path_uploadFiles = @"member/uploadFiles";

/**会员交易记录明细/我的投资 接口  null,查所有；竞标中：2；待回收：3；已回收：5*/
static NSString * const Path_orderRecord = @"order/orderRecord";

/**删除银行卡 接口*/
static NSString * const Path_deleteBank = @"member/deleteBank";

/**基本信息 接口*/
static NSString * const Path_getInfoById = @"member/getInfoById";

/**实名认证 接口*/
static NSString * const Path_invokeBankCard = @"member/invokeBankCard";

/**设置交易密码 接口*/
static NSString * const Path_editTradePass = @"member/editTradePass";

/**获取实名认证信息 接口*/
static NSString * const Path_getMemberAuth = @"member/getMemberAuth";

/**我的融资（融资申请记录） 接口*/
static NSString * const Path_getFinancings = @"member/getFinancings";

/**我的抵押（抵押申请记录） 接口*/
static NSString * const Path_getAssetRecords = @"member/getAssetRecords";

/**提现申请 接口*/
static NSString * const Path_applyCash = @"member/applyCash";

/**提现记录 接口*/
static NSString * const Path_queryApplyCaseRecords = @"member/queryApplyCaseRecords";

/**添加银行卡 接口*/
static NSString * const Path_addBank = @"member/addBank";

/**用户投资 情况 接口*/
static NSString * const Path_getInvestmentInfo = @"order/getInvestmentInfo";



/**立即投资 接口*/
static NSString * const Path_investCommit = @"order/investCommit";


/**确认下单 接口*/
static NSString * const Path_placeAnOrder = @"order/placeAnOrder";


/**立即投资 接口*/
static NSString * const Path_getProductAvailAccount = @"order/getProductAvailAccount";

/**获取MID的银行卡 接口*/
static NSString * const Path_queryMBankCards = @"member/queryMBankCards";

/**获取会员充值记录 接口*/
static NSString * const Path_queryRechargeRecords = @"member/queryRechargeRecords";

/**获取指定银行卡信息 接口*/
static NSString * const Path_getBankCard = @"member/getBankCard";

/**邀请列表 接口*/
static NSString * const Path_getInviteRecords = @"member/getInviteRecords";


////////////////////////进货/////////////////////////////////////

/**查询套餐或商品 接口*/
static NSString * const Path_stock_getGoods = @"/v1/app/second/getGoods";
/**进货单列表 接口*/
static NSString * const Path_stock_orderList = @"/v1/app/second/orderList";
/**进货单明细 接口*/
static NSString * const Path_stock_orderDetail = @"/v1/app/second/orderDetail";
/**进货申请 接口*/
static NSString * const Path_stock_apply = @"/v1/app/second/apply";

////////////////////////调拔/////////////////////////////////////

/**查询套餐或商品  --- 调拨 接口*/
static NSString * const Path_dallot_getGoodsByTransfer = @"/v1/app/second/getGoodsByTransfer";
/**调拨申请 接口*/
static NSString * const Path_dallot_applyByTransfer = @"/v1/app/second/applyByTransfer";
/**门店列表 接口*/
static NSString * const Path_dallot_storeList = @"/v1/app/second/storeList";

/**调拨单和任务列表 接口*/
static NSString * const Path_dallot_transferOrderList = @"/v1/app/second/transferOrderList";
/**调拨单和任务明细 接口*/
static NSString * const Path_dallot_transferOrderDetail = @"/v1/app/second/transferOrderDetail";
/**调拨操作 接口*/
static NSString * const Path_dallot_transferOperate = @"/v1/app/second/transferOperate";
////////////////////////退仓/////////////////////////////////////

/**退仓单列表  --- 调拨 接口*/
static NSString * const Path_refund_returnOrderList = @"/v1/app/second/returnOrderList";
/**退仓单明细 接口*/
static NSString * const Path_refund_returnOrderDetail = @"/v1/app/second/returnOrderDetail";
/**退仓操作 接口*/
static NSString * const Path_refund_returnOperate = @"/v1/app/second/returnOperate";


////////////////////////发货/////////////////////////////////////

/**发货单列表接口*/
static NSString * const Path_delivery_sendOrderList = @"/v1/app/second/sendOrderList";
/**发货单明细 接口*/
static NSString * const Path_delivery_sendOrderDetail = @"/v1/app/second/sendOrderDetail";
/**确认收货 接口*/
static NSString * const Path_delivery_confirmReceipt = @"/v1/app/second/confirmReceipt";



//////////////////////////库存/////////////////////////////////////
//总仓
/**总仓单明细接口*/
static NSString * const Path_inventory_generalOrderDetail = @"/v1/app/second/generalOrderDetail";
/**总仓发货单列表 接口*/
static NSString * const Path_inventory_generalOrderList = @"/v1/app/second/generalOrderList";
/**是否有红点 接口*/
static NSString * const Path_inventory_getNews = @"/v1/app/second/getNews";

///盘库
/**盘库-选择库存 接口*/
static NSString * const Path_inventory_inventoryCheckChoice = @"/v1/app/second/inventoryCheckChoice";

/**盘库单列表 接口*/
static NSString * const Path_inventory_inventoryCheckOrderList = @"/v1/app/second/inventoryCheckOrderList";

/**盘库单详情 接口*/
static NSString * const Path_inventory_inventoryCheckOrderDetail = @"/v1/app/second/inventoryCheckOrderDetail";

/**盘库操作（保存或确认）接口*/
static NSString * const Path_inventory_inventoryCheckOperate = @"/v1/app/second/inventoryCheckOperate";

//管理
/**出入库流水接口*/
static NSString * const Path_inventory_inventoryReceipt = @"/v1/app/second/inventoryReceipt";

/**库存查询接口*/
static NSString * const Path_inventory_inventorySearch = @"/v1/app/second/inventorySearch";

/**库存查询SKU接口*/
static NSString * const Path_inventory_inventorySearchSKU = @"/v1/app/second/inventorySearchSKU";

/**是否有盘库历史接口*/
static NSString * const Path_inventory_haveInventoryCheckChoice = @"/v1/app/second/haveInventoryCheckChoice";

/**门店库存分类查询接口*/
static NSString * const Path_inventory_inventorySortByStore = @"/v1/app/second/inventorySortByStore";

/**门店库存（商品和样品）（直营和分销）接口*/
static NSString * const Path_inventory_storeInventory = @"/v1/app/second/storeInventory";

/**门店类别和分销店查询 接口*/
static NSString * const Path_inventory_storeCheck = @"/v1/app/second/storeCheck";

//调整
/**是否有调整单历史 接口*/
static NSString * const Path_inventory_haveCallInventory = @"/v1/app/second/haveCallInventory";

/**查询商品 接口*/
static NSString * const Path_inventory_getCallInventoryGoods = @"/v1/app/second/getCallInventoryGoods";

/**确认商品 接口*/
static NSString * const Path_inventory_callInventoryCheckChoice = @"/v1/app/second/callInventoryCheckChoice";

/**终止调库 接口*/
static NSString * const Path_inventory_stopCallInventory = @"/v1/app/second/stopCallInventory";

/**调库-（购物车界面） 接口*/
static NSString * const Path_inventory_callInventoryProducts = @"/v1/app/second/callInventoryProducts";


/**调库单列表 接口*/
static NSString * const Path_inventory_callInventoryOrderList = @"/v1/app/second/callInventoryOrderList";

/**调库单详情接口*/
static NSString * const Path_inventory_callInventoryOrderDetail = @"/v1/app/second/callInventoryOrderDetail";

/**调库单调整接口*/
static NSString * const Path_inventory_callInventoryOrderOperate = @"/v1/app/second/callInventoryOrderOperate";

/**门店库存调整（商品和样品）（直营和分销）接口*/
static NSString * const Path_inventory_storeInventoryOperate = @"/v1/app/second/storeInventoryOperate";

//问题商品调库
static NSString * const Path_getProblemList = @"/v1/app/second/getProblemList";
//////////////////////////门店下单，退货/////////////////////////////////////

//库存参考信息
static NSString * const Path_stores_getShopDealerStock = @"/v1/app/second/getShopDealerStock";

//更新发货确定
static NSString * const Path_stores_confirmSend = @"/v1/app/second/confirmSend";

//更新发货（ 首次 和 再次发货 复用接口）
static NSString * const Path_stores_getOrderProductInfo = @"/v1/app/second/getOrderProductInfo";

//经销商总仓列表
static NSString * const Path_stores_dealerStockerList = @"/v1/app/second/dealerStockerList";

//订单预约自提信息
static NSString * const Path_stores_selfInfo = @"/v1/app/second/selfInfo";

//退货选择仓库
static NSString * const Path_stores_returnAddress = @"/v1/app/second/returnAddress";

//预约自提确认保存
static NSString * const Path_stores_selfSave = @"/v1/app/second/selfSave";

//上传图片
static NSString * const Path_publishImage = @"/v1/app/second/publishImage";


//问题商品盘库
static NSString * const Path_getProblemProducts = @"/v1/app/second/getProblemProducts";

//问题商品盘库
static NSString * const Path_print = @"/v1/app/second/print";

//活动重点关注项
static NSString * const Path_getActivityIndexIdList = @"/v1/app/second/getActivityIndexIdList";


//////////////////////////换货/////////////////////////////////////

//客户换货单列表
static NSString * const Path_getCustomerExchangeList= @"/v1/app/second/customerExchangeList";

//换货单详情
static NSString * const Path_ExchangeOrderDetail= @"/v1/app/second/exchangeOrderDetail";

//确认换货
static NSString * const Path_ConfirmExchange= @"/v1/app/second/confirmExchange";

//选择商品
static NSString * const Path_SelectExchangeProduct= @"/v1/app/second/selectProduct";

//选择换货商品
static NSString * const Path_SelectProductInfo= @"/v1/app/second/selectProductInfo";

//选择换货订单
static NSString * const Path_ExchangeGoods= @"/v1/app/second/exchangeGoods";

//门店换货单列表
static NSString * const Path_PostShopExchangeList= @"/v1/app/second/shopExchangeList";

//完善预订商品
static NSString * const Path_ReserveProduct= @"/v1/app/second/reserveProduct";
//完善商品确定
static NSString * const Path_ReserveProductFix= @"/v1/app/second/reserveProductFix";

#endif /* HttpURLConfig_h */
