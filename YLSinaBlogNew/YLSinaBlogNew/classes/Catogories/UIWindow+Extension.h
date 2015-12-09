//
//  UIWindow+Extension.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/10.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 *  判断是否需要显示新特性界面并根据判断分别设置合适的根控制器
 */
- (void)newFeatureJudgeAndSetRootViewController;

@end
