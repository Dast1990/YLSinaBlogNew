//
//  UIBarButtonItem+Extension.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/30.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

//selectorName属性是SEL，不是NSString *
+ (instancetype)itemWithTarget:(id)target   selector:(SEL)selectorName normalImgName:(NSString *)normalImgName   highlightedImgName:(NSString *) highlightedImgName {
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:normalImgName] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:highlightedImgName] forState:(UIControlStateHighlighted)];
    //    不设置尺寸，按钮就无法显示（见天色）
    btn.size = btn.currentBackgroundImage.size;
    
    //    selectorName，不要写成 @selector(selectorName)
    [btn addTarget:target  action:selectorName forControlEvents:(UIControlEventTouchUpInside)];
    return [[self alloc] initWithCustomView:btn];
}

@end

