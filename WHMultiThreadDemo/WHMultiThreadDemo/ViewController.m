//
//  ViewController.m
//  WHMultiThreadDemo
//  https://github.com/remember17/WHMultiThreadDemo
//  Created by 吴浩 on 2017/7/6.
//  Copyright © 2017年 wuhao. All rights reserved.
//  http://www.jianshu.com/p/7649fad15cdb

#import "ViewController.h"
#import "GCDViewController.h"
#import "NSOperationVC.h"
#import "NSThreadVC.h"

@implementation ViewController

- (IBAction)NSThreadAction:(id)sender {
    NSThreadVC *threadVC = [[NSThreadVC alloc] init];
    [self.navigationController pushViewController:threadVC animated:YES];
}

- (IBAction)GCDAction:(id)sender {
    GCDViewController *GCDVC = [[GCDViewController alloc] init];
    [self.navigationController pushViewController:GCDVC animated:YES];
}

- (IBAction)NSOperationAction:(id)sender {
    NSOperationVC *operationVC = [[NSOperationVC alloc] init];
    [self.navigationController pushViewController:operationVC animated:YES];
}

@end
