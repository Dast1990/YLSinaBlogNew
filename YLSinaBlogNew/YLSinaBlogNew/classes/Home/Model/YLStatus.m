//
//  YLStatus.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/14.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLStatus.h"
#import "YLPhoto.h"
#import <MJExtension.h>

@implementation YLStatus

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"pic_urls":[YLPhoto class]};
}


@end



