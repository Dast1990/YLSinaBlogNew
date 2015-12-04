//
//  UIView+YLExtension.h


#import <UIKit/UIKit.h>

@interface UIView (YLExtension)

/**
 *  通过frame拿到的size，不是bounds
 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
