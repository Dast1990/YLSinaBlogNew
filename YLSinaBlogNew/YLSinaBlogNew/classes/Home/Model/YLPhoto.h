//
//  YLPhoto.h
//  YLSinaBlogNew
//
//  Created by LongMa on 16/2/5.
//  Copyright © 2016年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLPhoto : NSObject

/** 缩略图片地址，没有时不返回此字段 */
@property (nonatomic, copy) NSString *thumbnail_pic;
@end
