//
//  YLButton.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/12.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLButton.h"
#define YLMargin 5

@implementation YLButton

- (instancetype)initWithFrame:(CGRect)frame
{
    YLLOG(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:(UIControlStateSelected)];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:(UIControlStateNormal)];
    }
    return self;
}

// 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
/**
 *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置。
 */
#pragma mark -  本例如果不重写这个方法，会导致界面显示时的bug
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width += YLMargin;
//    [super setFrame:frame];
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    YLLOG(@"%s", __func__);
    self.titleLabel.x = self.imageView.x;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + YLMargin;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect

@end
