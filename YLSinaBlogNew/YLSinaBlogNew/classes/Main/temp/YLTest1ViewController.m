//
//  YLTest1ViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLTest1ViewController.h"
#import "YLTest2ViewController.h"

@interface YLTest1ViewController ()

@end

@implementation YLTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    YLTest2ViewController *test2VC = [[YLTest2ViewController alloc] initWithNibName:@"YLTest2ViewController" bundle:nil];
    [self.navigationController pushViewController:test2VC animated:YES];
}

@end
