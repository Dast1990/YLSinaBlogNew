//
//  UIBarButtonItem+Extension.h
//  YLSinaBlog
//
//  Created by LongMa on 15/11/30.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  设置导航栏的item
 *
 *  @param target             哪个对象响应
 *  @param selectorName       被点击时响应哪个方法
 *  @param normalImgName      正常状态图片名字
 *  @param highlightedImgName 高亮状态图片名
 *
 *  @return <#return value description#>
 */
+ (instancetype)itemWithTarget:(id)target   selector:(SEL)selectorName normalImgName:(NSString *)normalImgName   highlightedImgName:(NSString *) highlightedImgName;

@end
