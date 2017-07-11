//
//  GCDViewController.m
//  WHMultiThreadDemo
//  https://github.com/remember17/WHMultiThreadDemo
//  Created by 吴浩 on 2017/7/6.
//  Copyright © 2017年 wuhao. All rights reserved.
//  http://www.jianshu.com/p/7649fad15cdb

#import "GCDViewController.h"

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UIButton *hideImageViewButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GCDViewController

/** 串行同步 */
- (IBAction)syncSerialAction:(id)sender {
    [self syncSerial];
}

/** 串行异步 */
- (IBAction)asyncSerialAction:(id)sender {
    [self asyncSerial];
}

/** 并发同步 */
- (IBAction)syncConcurrentAction:(id)sender {
    [self syncConcurrent];
}

/** 并发异步 */
- (IBAction)asyncConcurrentAction:(id)sender {
    [self asyncConcurrent];
}

/** 主队列同步，放到主线程会死锁，所以这里开了一条线程 */
- (IBAction)syncMainAction:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self syncMain];
    });
}

// 主队列异步
- (IBAction)asyncMainAction:(id)sender {
    [self asyncMain];
}

/** 线程间通信 */
- (IBAction)communicationBetweenThreadAction:(id)sender {
    [self communicationBetweenThread];
}

/** GCD队列组 */
- (IBAction)groupAction:(id)sender {
    [self testGroup];
}

/** GCD快速迭代 */
- (IBAction)applyAction:(id)sender {
    [self applyGCD];
}

/** GCD栅栏 */
- (IBAction)barrierAction:(id)sender {
    [self barrierGCD];
}



/******************************************************************/
/******************************************************************/



/** 串行同步 */
- (void)syncSerial {
    
    NSLog(@"\n\n**************串行同步***************\n\n");
    
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步3   %@",[NSThread currentThread]);
        }
    });
}

/** 串行异步 */
- (void)asyncSerial {
    
    NSLog(@"\n\n**************串行异步***************\n\n");
    
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步3   %@",[NSThread currentThread]);
        }
    });
}

/** 并发同步 */
- (void)syncConcurrent {
    
    NSLog(@"\n\n**************并发同步***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发同步3   %@",[NSThread currentThread]);
        }
    });
}

/** 并发异步 */
- (void)asyncConcurrent {
    
    NSLog(@"\n\n**************并发异步***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"并发异步3   %@",[NSThread currentThread]);
        }
    });
}

/** 主队列同步 */
- (void)syncMain {
    
    NSLog(@"\n\n**************主队列同步，放到主线程会死锁，现在是在新开的一条线程上执行***************\n\n");
    
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步3   %@",[NSThread currentThread]);
        }
    });
}

/** 主队列异步 */
- (void)asyncMain {
    
    NSLog(@"\n\n**************主队列异步***************\n\n");
    
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步3   %@",[NSThread currentThread]);
        }
    });
}

/** 线程间通信 */
- (void)communicationBetweenThread {
    [SVProgressHUD showWithStatus:@"Waiting..."];
    
    // 异步
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 耗时操作放在这里，例如下载图片。（运用线程休眠三秒来模拟耗时操作下载图片）
        [NSThread sleepForTimeInterval:3];
        UIImage *image = [UIImage imageNamed:@"test"];
        
        // 回到主线程处理UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 在主线程上添加图片
            self.imageView.image = image;
            
            self.hideImageViewButton.hidden = NO;
            self.imageView.hidden = NO;
            [SVProgressHUD dismiss];
        });
    });
}

- (IBAction)hideImageViewAction:(id)sender {
    self.imageView.hidden = YES;
    self.hideImageViewButton.hidden = YES;
}

/** 队列组 */
- (void)testGroup {
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作完成！");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作完成！");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"队列组：前面的耗时操作都完成了，回到主线程进行相关操作");
    });
}

/** GCD快速迭代 */
- (void)applyGCD {
    NSLog(@"\n\n************** GCD快速迭代 ***************\n\n");
    
    // 并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // dispatch_apply几乎同时遍历多个数字
    dispatch_apply(7, queue, ^(size_t index) {
        NSLog(@"dispatch_apply：%zd======%@",index, [NSThread currentThread]);
    });
}

/** GCD栅栏 */
- (void)barrierGCD {
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏：并发异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏：并发异步2   %@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"------------barrier------------%@", [NSThread currentThread]);
        NSLog(@"******* 并发异步执行，但是34一定在12后面 *********");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏：并发异步3   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏：并发异步4   %@",[NSThread currentThread]);
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    self.imageView.hidden = YES;
    self.hideImageViewButton.hidden = YES;
}

@end
