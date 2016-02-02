//
//  YLLoadMoreFooterView.m
//  YLSinaBlogNew
//
//  Created by LongMa on 16/1/8.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import "YLLoadMoreFooterView.h"

@interface YLLoadMoreFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *loadMoreLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation YLLoadMoreFooterView


+ (instancetype)footerView {
    return [[NSBundle mainBundle] loadNibNamed:@"YLLoadMoreFooterView" owner:nil options:nil].lastObject;
}

- (void)setLoading:(BOOL)loading{
    _loading = loading;
    if (_loading) {
        self.loadMoreLbl.text = @"正在拼命加载中……";
        [self.indicatorView startAnimating];
    }else{
        self.loadMoreLbl.text = @"上拉加载更多";
        [self.indicatorView stopAnimating];
    }
}

@end
