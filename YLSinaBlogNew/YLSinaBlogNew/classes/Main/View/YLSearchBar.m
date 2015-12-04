//
//  YLSearchBar.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/30.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLSearchBar.h"

@implementation YLSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //    见天色
        self.background = [UIImage imageNamed:@"common_button_white_disable"];
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索内容";
        
        UIImageView *searchImg = [[UIImageView alloc] init];
        searchImg.image = [UIImage imageNamed:@"tabbar_discover"];
        searchImg.height = 40;
        searchImg.width = 40;
        searchImg.contentMode = UIViewContentModeCenter;
        //    searchImg.backgroundColor = [UIColor lightGrayColor];
        self.leftView = searchImg;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

@end
