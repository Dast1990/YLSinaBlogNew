//
//  YLLoadMoreFooterView.h
//  YLSinaBlogNew
//
//  Created by LongMa on 16/1/8.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLLoadMoreFooterView : UIView

/** 是否正在加载 */
@property (nonatomic, assign, getter=isLoading) BOOL loading;

/** 从xib创建 上拉加载更多视图 */
+ (instancetype)footerView;

@end
