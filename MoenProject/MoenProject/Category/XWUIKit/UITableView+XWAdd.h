//
//  UITableView+XWAdd.h
//  XW_Object
//
//  Created by Benc Mai on 2020/6/8.
//  Copyright © 2020 武新义. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (XWAdd)
//添加一个方法
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end

NS_ASSUME_NONNULL_END
