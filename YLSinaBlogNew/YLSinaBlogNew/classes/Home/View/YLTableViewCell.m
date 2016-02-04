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


@interface YLTableViewCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/** 博主名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

/** 微博正文 */
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

/** 转评赞 底部视图 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation YLTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
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
