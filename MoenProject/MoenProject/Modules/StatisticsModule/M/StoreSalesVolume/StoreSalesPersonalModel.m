//
//  StoreSalesPersonalModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreSalesPersonalModel.h"

@implementation StoreSalesPersonalModel

@end

@implementation StoreSalesPersonalListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopData" : [StoreSalesPersonalModel class]};
}
@end
