//
//  YLTableViewCell.m
//  YLSinaBlogNew
//
//  Created by LongMa on 16/2/4.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import "YLTableViewCell.h"
#import "YLStatus.h"
#import "YLUser.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "UIView+YLExtension.h"


@interface YLTableViewCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/** 博主名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

/** 微博正文 */
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

/** 转评赞 底部视图 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 转载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *transmitBtn;

/** 评论按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

/** 点赞按钮 */
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

/** 左分割线 */
@property (nonatomic, weak) UIView *leftSeperatorView;

/** 右分割线 */
@property (nonatomic, weak) UIView *rightSeperatorView;

@end

@implementation YLTableViewCell

- (void)awakeFromNib {
    /** 向bottomView添加两个分割线view */
    UIView *leftSeperatorView = [UIView viewWithBackgroundColor:[UIColor grayColor] andAlphla:0.4];
    [self.bottomView addSubview:leftSeperatorView];
    self.leftSeperatorView = leftSeperatorView;
    
    UIView *rightSeperatorView = [UIView viewWithBackgroundColor:[UIColor grayColor] andAlphla:0.4];
    [self.bottomView addSubview:rightSeperatorView];
    self.rightSeperatorView = rightSeperatorView;
    
    [self setNeedsUpdateConstraints];
    //    [self updateConstraintsIfNeeded];
}

//!!!: 凡是自定义的约束，都要写在这里，不能写在awakeFromNib方法中，比如：leftSeperatorView与控件bottomView有约束关系，当bottomView约束被改变时，系统会自动调用下面的update方法来更新所有约束，如果leftSeperatorView的约束写在awakeFromNib中，则不能通过update方法来更新约束代码，导致显示bug
- (void)updateConstraints{
    [self.leftSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.transmitBtn.mas_trailing).offset(3);
        make.centerY.mas_equalTo(self.transmitBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    [self.rightSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.commentBtn.mas_trailing).offset(3);
        make.centerY.mas_equalTo(self.commentBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    //!!!: 用autolayout就不能改frame了！展现出来的效果也是由约束条件决定的，跟创建时的宽和高无关。如不重新约束宽高，则看不到控件！
    //    YLLOG(@"%@", NSStringFromCGRect(leftSeperatorView.frame));
    
    //!!!:不能少。易忘记 super！而且要放到方法最后！（文档特别要求）
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //!!!: 必须放在super前，才有效果！默认两个都是NO
    //    selected = YES;
    //    animated = YES;
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setStatus:(YLStatus *)status{
    _status = status;
    YLUser *user = status.user;
    
    
    self.nameLbl.text = user.name;
    self.contentLbl.text = status.text;
    //FIXME: sizeToFit？
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
}



@end
