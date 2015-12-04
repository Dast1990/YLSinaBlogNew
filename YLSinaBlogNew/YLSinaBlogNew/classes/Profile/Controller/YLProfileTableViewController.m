//
//  YLProfileTableViewController.m
//  YLSinaBlog
//
//  Created by LongMa on 15/11/29.
//  Copyright © 2015年 LongMa. All rights reserved.
//

#import "YLProfileTableViewController.h"
#import "YLTest1ViewController.h"
#import "YLTabBar.h"

@interface YLProfileTableViewController ()

@end

@implementation YLProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看更多" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemDidClick)];
}

- (void)rightBarButtonItemDidClick{
    // initWithNibName 不能带 .xib,切记！
    YLTest1ViewController *test1VC = [[YLTest1ViewController alloc] initWithNibName:@"YLTest1ViewController" bundle:nil];
    [self.navigationController pushViewController:test1VC  animated:YES];
}

@end
