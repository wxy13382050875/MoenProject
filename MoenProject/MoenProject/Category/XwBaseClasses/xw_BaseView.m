//
//  xw_BaseView.m
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import "xw_BaseView.h"

@implementation xw_BaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self xw_setupUI];
        [self xw_updateConstraints];
        [self xw_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<xw_ViewModelProtocol>)viewModel {
    
    self = [super init];
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
- (void)xw_bindViewModel {
}
@end
