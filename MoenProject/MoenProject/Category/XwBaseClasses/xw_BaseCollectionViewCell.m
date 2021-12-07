//
//  xw_BaseCollectionViewCell.m
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import "xw_BaseCollectionViewCell.h"

@implementation xw_BaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xw_setupUI];
        [self xw_updateConstraints];
        [self xw_bindViewModel];
    }
    return self;
}

-(void)xw_setupUI{
    
}
-(void)xw_updateConstraints{
    
}
-(void)xw_bindViewModel{
    
}
@end
