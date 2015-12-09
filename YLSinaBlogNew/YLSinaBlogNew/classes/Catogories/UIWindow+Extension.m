//
//  UIWindow+Extension.m
//  YLSinaBlogNew
//
//  Created by LongMa on 15/12/10.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "YLMainTabbarController.h"
#import "YLNewFeatureController.h"

@implementation UIWindow (Extension)

- (void)newFeatureJudgeAndSetRootViewController{
    NSString *versionKey = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = infoDic[versionKey];
    
    
    if ([currentVersion isEqualToString:lastVersion]) {
        self.rootViewController = [[YLMainTabbarController alloc] init];
    }else{
        //        下面这两句放到else里很适合，放外面时，当不需要显示新特性时，下两句没必要执行。
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.rootViewController = [[YLNewFeatureController alloc] init];
    }
    
}

@end
