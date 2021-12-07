//
//  PatrolShopDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PatrolShopDetailModel.h"

@implementation PatrolShopDetailModel


- (void)setQuestionName:(NSString *)questionName
{
    _questionName = questionName;
    if (self.itemCellHeight == 0) {
        CGFloat textHeight = [NSTool getHeightWithContent:questionName width:SCREEN_WIDTH - 125 font:FONTSYS(14) lineOffset:3];
        if (textHeight < 25) {
            self.itemCellHeight = 56;
        }
        else
        {
            self.itemCellHeight = 73;
        }
    }
}

@end


@implementation PatrolShopDetailListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"patrolShopDetail" : [PatrolShopDetailModel class]};
}
@end
@implementation PSQuestionStatusModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end



