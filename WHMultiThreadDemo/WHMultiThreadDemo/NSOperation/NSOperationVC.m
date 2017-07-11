//
//  NSOperationVC.m
//  WHMultiThreadDemo
//  https://github.com/remember17/WHMultiThreadDemo
//  Created by 吴浩 on 2017/7/6.
//  Copyright © 2017年 wuhao. All rights reserved.
//  http://www.jianshu.com/p/7649fad15cdb

#import "NSOperationVC.h"
#import "WHOperation.h"

@interface NSOperationVC ()

@property (weak, nonatomic) IBOutlet UIButton *hideImageViewButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSOperationVC

/** NSInvocationOperation的使用 */
- (IBAction)NSInvocationOperationAction:(id)sender {
    [self testNSInvocationOperation];
}

/** NSBlockOperation的使用 */
- (IBAction)NSBlockOperationAction:(id)sender {
    [self testNSBlockOperation];
}

/** 运用继承自NSOperation的子类 */
- (IBAction)WHOperationAction:(id)sender {
    [self testWHOperation];
}

/** addExecutionBlock:实现多线程 */
- (IBAction)addExecutionBlockAction:(id)sender {
    [self testNSBlockOperationExecution];
}

/** addOperation把任务添加到队列 */
- (IBAction)AddOperationAction:(id)sender {
    [self testAddOperation];
}

/** addOperationWithBlock把任务添加到队列 */
- (IBAction)AddOperationWithBlockAction:(id)sender {
    [self testAddOperationWithBlock];
}

/** NSOperation线程间通信 */
- (IBAction)communicationBetweenThreadAction:(id)sender {
    [self communicationBetweenThread];
}

/** 最大并发数 */
- (IBAction)MaxConcurrentOperationCountAction:(id)sender {
    [self testMaxConcurrentOperationCount];
}

/** 操作依赖 */
- (IBAction)AddDependencyAction:(id)sender {
    [self testAddDependency];
}



/******************************************************************/
/******************************************************************/



/** NSInvocationOperation的使用 */
- (void)testNSInvocationOperation {
    // 创建NSInvocationOperation
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation) object:nil];
    // 开始执行操作
    [invocationOperation start];
}

- (void)invocationOperation {
    NSLog(@"NSInvocationOperation包含的任务，没有加入队列========%@", [NSThread currentThread]);
}

/** NSBlockOperation的使用 */
- (void)testNSBlockOperation {
    // 把任务放到block中
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation包含的任务，没有加入队列========%@", [NSThread currentThread]);
    }];
    
    [blockOperation start];
}

/** 运用继承自NSOperation的子类 */
- (void)testWHOperation {
    WHOperation *operation = [[WHOperation alloc] init];
    [operation start];
}

/** addExecutionBlock:实现多线程 */
- (void)testNSBlockOperationExecution {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation运用addExecutionBlock========%@", [NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务1========%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务2========%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务3========%@", [NSThread currentThread]);
    }];
    
    [blockOperation start];
}

/** addOperation把任务添加到队列 */
- (void)testAddOperation {
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 创建操作，NSInvocationOperation
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAddOperation) object:nil];
    // 创建操作，NSBlockOperation
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperation把任务添加到队列======%@", [NSThread currentThread]);
        }
    }];
    
    [queue addOperation:invocationOperation];
    [queue addOperation:blockOperation];
}

- (void)invocationOperationAddOperation {
    NSLog(@"invocationOperation===addOperation把任务添加到队列==========%@", [NSThread currentThread]);
}

/** addOperationWithBlock把任务添加到队列 */
- (void)testAddOperationWithBlock {
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperationWithBlock把任务添加到队列======%@", [NSThread currentThread]);
        }
    }];
}

/** 线程间通信 */
- (void)communicationBetweenThread {
    [SVProgressHUD showWithStatus:@"Waiting..."];
    
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 在子线程进行耗时操作
    [queue addOperationWithBlock:^{
        // 耗时操作放在这里，例如下载图片。（运用线程休眠三秒来模拟耗时操作）
        [NSThread sleepForTimeInterval:3];
        UIImage *image = [UIImage imageNamed:@"test"];
        
        // 回到主线程进行UI操作
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 在主线程上添加图片
            self.imageView.image = image;
            
            self.hideImageViewButton.hidden = NO;
            self.imageView.hidden = NO;
            [SVProgressHUD dismiss];
        }];
    }];
}

- (IBAction)hideImageViewAction:(id)sender {
    self.imageView.hidden = YES;
    self.hideImageViewButton.hidden = YES;
}

/** 最大并发数 */
- (void)testMaxConcurrentOperationCount {
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 最大并发数为1，串行
    queue.maxConcurrentOperationCount = 1;
    
    // 最大并发数为2，并发
    //    queue.maxConcurrentOperationCount = 2;
    
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperationWithBlock把任务添加到队列1======%@", [NSThread currentThread]);
        }
    }];
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperationWithBlock把任务添加到队列2======%@", [NSThread currentThread]);
        }
    }];
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperationWithBlock把任务添加到队列3======%@", [NSThread currentThread]);
        }
    }];
}

/** 操作依赖 */
- (void)testAddDependency {
    
    // 并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 操作1
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"operation1======%@", [NSThread  currentThread]);
        }
    }];
    
    // 操作2
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"****operation2依赖于operation1，只有当operation1执行完毕，operation2才会执行****");
        for (int i = 0; i < 3; i++) {
            NSLog(@"operation2======%@", [NSThread  currentThread]);
        }
    }];
    
    // 使操作2依赖于操作1
    [operation2 addDependency:operation1];
    
    // 把操作加入队列
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
    self.imageView.hidden = YES;
    self.hideImageViewButton.hidden = YES;
}

@end
