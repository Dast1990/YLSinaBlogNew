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
#import "YLPhoto.h"

#define horizonMargin  8
#define verticalMargin  8
#define photoHW 70


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

/** 评论栏 左分割线 */
@property (nonatomic, weak) UIView *leftSeperatorView;

/** 评论栏 右分割线 */
@property (nonatomic, weak) UIView *rightSeperatorView;

/** 微博正文到底部评论栏的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraitOfBtmOfContentLblToTopOfBtmView;


/** 承载图片显示的 容器视图 */
//!!!: 容器视图为weak，addSubview操作会对子视图产生强引用吗？NO
@property (nonatomic, weak) UIView *photoView;


@end

@implementation YLTableViewCell

- (void)awakeFromNib {
    /** 向bottomView添加两个分割线view。都抽取到懒加载里了 */
    
    [self setNeedsUpdateConstraints];
    //    [self updateConstraintsIfNeeded];
}

//!!!: 凡是自定义的约束，都要写在这里，不能写在awakeFromNib方法中，比如：leftSeperatorView与控件bottomView有约束关系，当bottomView约束被改变时，系统会自动调用下面的update方法来更新所有约束，如果leftSeperatorView的约束写在awakeFromNib中，则不能通过update方法来更新约束代码，导致显示bug
- (void)updateConstraints{
    WS(weakSelf);
    //    __weak typeof(self) weakself = self;
    
    [self.leftSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.transmitBtn.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.transmitBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    [self.rightSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.commentBtn.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.commentBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    /** photoView 初始约束 */
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(horizonMargin * 0.8);
        make.right.mas_equalTo(horizonMargin);
        make.top.mas_equalTo(weakSelf.contentLbl.mas_bottom).offset(verticalMargin);
        
        /** 这样约束，使得初始photoView高度为0，约束bottom不约束height，是为了方便下面 更新约束：photoView应该与最后一个子视图 底部重合。 
         但是行不通，出现显示bug，改为约束高度后正常。*/
        //        make.bottom.mas_equalTo(weakSelf.contentLbl.mas_bottom).offset(verticalMargin);
        make.height.mas_equalTo(10);
    }];
    
    [self setUpPhotoViewConstraitAndContent];
    
    //!!!: 用autolayout就不能改frame了！展现出来的效果也是由约束条件决定的，跟创建时的宽和高无关。如不重新约束宽高，则看不到控件！
    //    YLLOG(@"%@", NSStringFromCGRect(leftSeperatorView.frame));
    
    //!!!:不能少。易忘记 super！而且要放到方法最后！（文档特别要求）
    [super updateConstraints];
}

/** 不同张数图片的排版约束和内容设置 */
- (void)setUpPhotoViewConstraitAndContent{
    //多张：4张按2X2，其他都按3x3布局时的 行值和列值 来设置相对于 父类容器view 边界的约束。
    
    NSUInteger photoNum = self.status.pic_urls.count;
    YLLOG(@"photoNum = %lu, %@\n%@", photoNum, self.status, self.status.pic_urls);
    
    switch (photoNum) {
        case 0:
            self.photoView.hidden = YES;
            
            //???:  不能用mas_make。会与满足if里设置的 高度100 产生冲突。但是无论是mas_update和下面方法图片仍会以空白的方式出现！
            self.constraitOfBtmOfContentLblToTopOfBtmView.constant = verticalMargin;
            break;
        case 4:
            [self setConstraitWithTotalCols:2 andPhotoNums:photoNum];
            break;
        default:
            [self setConstraitWithTotalCols:3 andPhotoNums:photoNum];
            break;
    }
}

/**
 *  根据列数和照片数 设置约束
 *
 *  @param totalCols 总列数
 *  @param photoNum  照片数
 */
- (void)setConstraitWithTotalCols:(short)totalCols andPhotoNums:(NSUInteger)photoNum{
    self.photoView.hidden = NO;
    /** 为防止复用bug，先清空photoView */
    while (self.photoView.subviews.count) {
        [self.photoView.subviews.firstObject removeFromSuperview];
    }
    /** 总行数 */
    short totalRows = (photoNum - 1) / totalCols + 1;
    /** 循环创建 photoNum 个imgView,添加到photoView 根据算出的 行列号，设置约束和内容*/
    for (int i = 1; i <= photoNum; i++) {
        UIImageView *imgViewTemp = [[UIImageView alloc] init];
        [self.photoView addSubview:imgViewTemp];
        
        /** 行号rows 列号cols */
        short rows = (i - 1) / totalCols + 1;
        short cols = (i - 1) % totalCols + 1;
        
        /** 约束 */
        [imgViewTemp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(photoHW, photoHW));
            make.left.mas_equalTo(horizonMargin + (photoHW + horizonMargin) * (cols - 1));
            make.top.mas_equalTo((photoHW + verticalMargin) * (rows - 1));
            
        }];
        
        /** 内容 */
        NSString *imgUrlString = [self.status.pic_urls[i - 1] thumbnail_pic];
        [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
        
        /** 更新photoView高度约束 */
        [_photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(totalRows * photoHW + (totalRows - 1) * verticalMargin);
            
        }];
        /** _photoView的背景色可见，它的实际高度并没变，还是10。（有时候变了，好像是第一次画时会改frame，之后复用时，高度还是10）
         约束的效果:只是体现在画出来什么样子，实际控件的宽高 并不受约束 的影响。
         所以：即使是亲眼看到，也不要轻易相信你的眼睛。通过现象，要去探索本质。不要被外表所迷惑。
         */
        //                YLLOG(@"photoFrame = %@",NSStringFromCGRect( weakSelf.photoView.frame));
    }
    
    self.constraitOfBtmOfContentLblToTopOfBtmView.constant = verticalMargin + (totalRows) * (photoHW + verticalMargin);
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
    YLLOG(@"_status = %@", _status);
    YLUser *user = status.user;
    
    
    self.nameLbl.text = user.name;
    self.contentLbl.text = status.text;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    //    
    //    NSString *photoUrl = [status.pic_urls.firstObject thumbnail_pic];
    //    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    //!!!: 由崩溃和yllog顺序 得知，setStatus方法是在updateConstrate之后才被调用的。导致在updateConstrate里取用self.status时，为null，所以要手动调用下面方法（自动调用updateConstrate）来重新设置约束和photoView中内容；
    [self setNeedsUpdateConstraints];
    
}



#pragma mark -  懒加载
- (UIView *)photoView
{
    if (!_photoView){
        UIView *photoView = [[UIView alloc] init];
        photoView.backgroundColor = [UIColor cyanColor];
        _photoView = photoView;
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (UIView *)rightSeperatorView
{
    if (!_rightSeperatorView){
        UIView *rightSeperatorView = [UIView viewWithBackgroundColor:[UIColor grayColor] andAlphla:0.4];
        _rightSeperatorView = rightSeperatorView;
        [self.bottomView addSubview:_rightSeperatorView];
    }
    return _rightSeperatorView;
}

- (UIView *)leftSeperatorView
{
    if (!_leftSeperatorView){
        UIView *leftSeperatorView = [UIView viewWithBackgroundColor:[UIColor grayColor] andAlphla:0.4];
        _leftSeperatorView = leftSeperatorView;
        [self.bottomView addSubview:_leftSeperatorView];
    }
    return _leftSeperatorView;
}



@end
