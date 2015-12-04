
//YLPullDownView.h

#import <UIKit/UIKit.h>

@class YLPullDownView;

@protocol YLPullDownViewDelegate <NSObject>
@optional
- (void)pulldownMenuDidDismiss:(YLPullDownView *)menu;
- (void)pulldownMenuDidShow:(YLPullDownView *)menu;
@end

@interface YLPullDownView : UIView
@property (nonatomic, weak) id<YLPullDownViewDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
