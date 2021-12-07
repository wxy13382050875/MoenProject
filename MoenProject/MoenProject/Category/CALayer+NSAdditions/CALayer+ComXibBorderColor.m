//
//  CALayer+ComXibBorderColor.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/18.
//

#import "CALayer+ComXibBorderColor.h"

@implementation CALayer (ComXibBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
