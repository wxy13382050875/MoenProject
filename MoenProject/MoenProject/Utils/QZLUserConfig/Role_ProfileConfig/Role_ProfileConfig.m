//
//  User_ProfileConfig.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "Role_ProfileConfig.h"

@implementation Role_ProfileConfig

#pragma mark 门店店长—首页
NSString* const ME_Store_Owner_HomePage = @"{\
\"datas\": [\
{\
\"title\": \"客户注册\",\
\"icon\": \"register_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"卖货\",\
\"icon\": \"sell_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"门店促销\",\
\"icon\": \"store_promotion_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"意向管理\",\
\"icon\": \"intention_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"套餐管理\",\
\"icon\": \"package_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
}\
]\
}";


#pragma mark 门店导购—首页
NSString* const ME_Store_Guide_HomePage = @"{\
\"datas\": [\
{\
\"title\": \"客户注册\",\
\"icon\": \"register_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"卖货\",\
\"icon\": \"sell_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"门店促销\",\
\"icon\": \"store_promotion_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"意向管理\",\
\"icon\": \"intention_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"套餐管理\",\
\"icon\": \"package_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
}\
]\
}";







#pragma mark 门店店长—门店管理
NSString* const ME_Store_Owner_StoreManage = @"{\
\"datas\": [\
{\
\"title\": \"门店客户\",\
\"icon\": \"store_customer_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"订单管理\",\
\"icon\": \"order_manage_icon\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"商品管理\",\
\"icon\": \"goods_manage_icon\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"专业客户\",\
\"icon\": \"professional_customer_icon\",\
\"skipid\": 3,\
\"isskip\": 0\
},\
{\
\"title\": \"专业客户订单\",\
\"icon\": \"professional_order_icon\",\
\"skipid\": 4,\
\"isskip\": 0\
},\
{\
\"title\": \"员工管理\",\
\"icon\": \"staff_manage_icon\",\
\"skipid\": 5,\
\"isskip\": 0\
},\
{\
\"title\": \"出样填报\",\
\"icon\": \"sampling_report_icon\",\
\"skipid\": 6,\
\"isskip\": 0\
},\
{\
\"title\": \"出样管理\",\
\"icon\": \"sampling_manage_icon\",\
\"skipid\": 7,\
\"isskip\": 0\
},\
{\
\"title\": \"巡店查询\",\
\"icon\": \"shop_search_icon\",\
\"skipid\": 8,\
\"isskip\": 0\
},\
{\
\"title\": \"退货\",\
\"icon\": \"return_icon\",\
\"skipid\": 9,\
\"isskip\": 0\
},\
{\
\"title\": \"退货单管理\",\
\"icon\": \"return_manage_icon\",\
\"skipid\": 10,\
\"isskip\": 0\
},\
{\
\"title\": \"优惠券记录\",\
\"icon\": \"coupon_record_icon\",\
\"skipid\": 11,\
\"isskip\": 0\
}\
]\
}";



#pragma mark 门店导购—门店管理
NSString* const ME_Store_Guide_StoreManage = @"{\
\"datas\": [\
{\
\"title\": \"门店客户\",\
\"icon\": \"store_customer_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"订单管理\",\
\"icon\": \"order_manage_icon\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"商品管理\",\
\"icon\": \"goods_manage_icon\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"退货\",\
\"icon\": \"return_icon\",\
\"skipid\": 9,\
\"isskip\": 0\
},\
{\
\"title\": \"退货单管理\",\
\"icon\": \"return_manage_icon\",\
\"skipid\": 10,\
\"isskip\": 0\
}\
]\
}";



#pragma mark 门店店长—统计
NSString* const ME_Store_Owner_Statistics = @"{\
\"datas\": [\
{\
\"title\": \"门店销量\",\
\"icon\": \"store_sales_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"商品销量\",\
\"icon\": \"goods_sales_icon\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"套餐排名\",\
\"icon\": \"package_ranking_icon\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"商品品类排名\",\
\"icon\": \"category_ranking_icon\",\
\"skipid\": 3,\
\"isskip\": 0\
},\
{\
\"title\": \"\",\
\"icon\": \"\",\
\"skipid\": -1,\
\"isskip\": 0\
},\
{\
\"title\": \"\",\
\"icon\": \"\",\
\"skipid\": -1,\
\"isskip\": 0\
}\
]\
}";


#pragma mark 门店导购—统计
NSString* const ME_Store_Guide_Statistics = @"{\
\"datas\": [\
{\
\"title\": \"门店销量\",\
\"icon\": \"store_sales_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"商品销量\",\
\"icon\": \"goods_sales_icon\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"\",\
\"icon\": \"\",\
\"skipid\": -1,\
\"isskip\": 0\
}\
]\
}";


#pragma mark 门店店长—识别
NSString* const ME_Store_Owner_Identity = @"{\
\"datas\": [\
{\
\"title\": \"卖货\",\
\"icon\": \"sell_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户活动\",\
\"icon\": \"customer_activity_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户账户\",\
\"icon\": \"customer_account_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"地址管理\",\
\"icon\": \"address_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"意向管理\",\
\"icon\": \"intention_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户订单\",\
\"icon\": \"customer_order_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"退货\",\
\"icon\": \"return_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"退货单\",\
\"icon\": \"return_order_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户标签\",\
\"icon\": \"customer_tag_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
}\
]\
}";


#pragma mark 门店导购—识别
NSString* const ME_Store_Guide_Identity = @"{\
\"datas\": [\
{\
\"title\": \"卖货\",\
\"icon\": \"sell_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户活动\",\
\"icon\": \"customer_activity_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户账户\",\
\"icon\": \"customer_account_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"地址管理\",\
\"icon\": \"address_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"意向管理\",\
\"icon\": \"intention_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户订单\",\
\"icon\": \"customer_order_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"退货\",\
\"icon\": \"return_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"退货单\",\
\"icon\": \"return_order_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户标签\",\
\"icon\": \"customer_tag_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
}\
]\
}";






#pragma mark 会员—注册
NSString* const ME_Store_User_Register = @"{\
\"datas\": [\
{\
\"title\": \"卖货\",\
\"icon\": \"sell_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户活动\",\
\"icon\": \"customer_activity_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户账户\",\
\"icon\": \"customer_account_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"地址管理\",\
\"icon\": \"address_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"意向管理\",\
\"icon\": \"intention_manage_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"客户标签\",\
\"icon\": \"customer_tag_icon\",\
\"skipid\": 0,\
\"isskip\": 0\
}\
]\
}";


#pragma mark 库存管理-店长
NSString* const ME_Store_Owner_StockManage = @"{\
\"datas\": [\
{\
\"title\": \"进货申请\",\
\"icon\": \"icon_receipt_apply\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"调拨申请\",\
\"icon\": \"icon_transfers_apply\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"库存管理\",\
\"icon\": \"icon_Inventory_manage\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"进货单管理\",\
\"icon\": \"icon_receipt_manage\",\
\"skipid\": 3,\
\"isskip\": 0\
},\
{\
\"title\": \"发货单管理\",\
\"icon\": \"icon_Invoice_manage\",\
\"skipid\": 4,\
\"isskip\": 0\
},\
{\
\"title\": \"调拨单管理\",\
\"icon\": \"icon_transfer_manage\",\
\"skipid\": 5,\
\"isskip\": 0\
},\
{\
\"title\": \"退仓单管理\",\
\"icon\": \"icon_return_manage\",\
\"skipid\": 6,\
\"isskip\": 0\
},\
{\
\"title\": \"总仓发货管理\",\
\"icon\": \"icon_warehouse_manage\",\
\"skipid\": 7,\
\"isskip\": 0\
}\
]\
}";
#pragma mark 库存管理-导购
NSString* const ME_Store_Guide_StockManage = @"{\
\"datas\": [\
{\
\"title\": \"库存管理\",\
\"icon\": \"icon_Inventory_manage\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"进货单管理\",\
\"icon\": \"icon_receipt_manage\",\
\"skipid\": 3,\
\"isskip\": 0\
},\
{\
\"title\": \"发货单管理\",\
\"icon\": \"icon_Invoice_manage\",\
\"skipid\": 4,\
\"isskip\": 0\
},\
{\
\"title\": \"调拨单管理\",\
\"icon\": \"icon_transfer_manage\",\
\"skipid\": 5,\
\"isskip\": 0\
},\
{\
\"title\": \"退仓单管理\",\
\"icon\": \"icon_return_manage\",\
\"skipid\": 6,\
\"isskip\": 0\
},\
{\
\"title\": \"总仓发货管理\",\
\"icon\": \"icon_warehouse_manage\",\
\"skipid\": 7,\
\"isskip\": 0\
}\
]\
}";

#pragma mark 库存管理二级-店长
NSString* const ME_Store_Owner_StockManageChild = @"{\
\"datas\": [\
{\
\"title\": \"门店库存\",\
\"icon\": \"icon_store_inventory\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"库存查询\",\
\"icon\": \"icon_Inventory_query\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"出入库流水\",\
\"icon\": \"icon_Inventory_water\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"门店盘库\",\
\"icon\": \"icon_store_check_inventory\",\
\"skipid\": 3,\
\"isskip\": 0\
},\
{\
\"title\": \"盘库单管理\",\
\"icon\": \"icon_Inventory_list_manage\",\
\"skipid\": 4,\
\"isskip\": 0\
},\
{\
\"title\": \"调库单管理\",\
\"icon\": \"icon_transfer_order_manage\",\
\"skipid\": 5,\
\"isskip\": 0\
},\
{\
\"title\": \"门店样品库存\",\
\"icon\": \"icon_sample_stock\",\
\"skipid\": 6,\
\"isskip\": 0\
},\
]\
}";
#pragma mark 库存管理二级-店长
NSString* const ME_Store_Guide_StockManageChild = @"{\
\"datas\": [\
{\
\"title\": \"门店库存\",\
\"icon\": \"icon_store_inventory\",\
\"skipid\": 0,\
\"isskip\": 0\
},\
{\
\"title\": \"库存查询\",\
\"icon\": \"icon_Inventory_query\",\
\"skipid\": 1,\
\"isskip\": 0\
},\
{\
\"title\": \"出入库流水\",\
\"icon\": \"icon_Inventory_water\",\
\"skipid\": 2,\
\"isskip\": 0\
},\
{\
\"title\": \"门店样品库存\",\
\"icon\": \"icon_sample_stock\",\
\"skipid\": 6,\
\"isskip\": 0\
},\
]\
}";
    
@end
