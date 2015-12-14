//
//  YLUser.h
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/14.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLUser : NSObject

/**
 *  字符串型用户id
 */
@property (nonatomic, copy) NSString *idstr;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *profile_image_url;

@end
