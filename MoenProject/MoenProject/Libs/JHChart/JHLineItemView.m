//
//  JHLineItemView.m
//  YChartTest
//
//  Created by LELE on 17/4/6.
//  Copyright © 2017年 rect. All rights reserved.
//

#import "JHLineItemView.h"
@interface JHLineItemView()
@property(nonatomic,weak)UILabel* textLbl;
@end
@implementation JHLineItemView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:30.0 / 255.0 green:81.0 / 255.0 blue:106.0 / 255.0 alpha:0.8];
        self.layer.cornerRadius = frame.size.height * 0.5;
        self.layer.masksToBounds = YES;
        
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.frame.size.width - 10, self.frame.size.height - 6)];
        [self addSubview:textLbl];
        textLbl.font = [UIFont systemFontOfSize:8];
        textLbl.numberOfLines = 0;
        textLbl.textColor = [UIColor whiteColor];
        self.textLbl = textLbl;
    }
    return self;
}

-(void)drawTextWith:(NSString *)text
{
    self.textLbl.text = text;
}

@end
