//
//  ViewController.m
//  GCD
//
//  Created by yangyang38 on 2018/3/15.
//  Copyright © 2018年 yangyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // 定义一个并发队列
    dispatch_queue_t concurrent_queue;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //学习barrier异步栅栏调用
    [self learnBarrier];
    //应用barrier：模拟一个多读单写场景
   // [self writeAndRead];
   
}

-(void)learnBarrier{
    [self concurrentQueueAsyncAndSync2BarrrierTest];
    
}

///并发队列   栅栏函数
- (void)concurrentQueueAsyncAndSync2BarrrierTest
{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务1 %d",i);
        }];
    });
    
    dispatch_async(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务2 %d",i);
        }];
    });
    
    
    NSLog(@"同步栅栏 start😊");
    dispatch_barrier_sync(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"同步栅栏, %@",[NSThread currentThread]);
        }];
    });
    NSLog(@"同步栅栏 end😊");
    
    
    dispatch_async(concurrentQueue, ^{
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务3 %d",i);
        }];
    });
    
    dispatch_async(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务4 %d",i);
        }];
    });
    
    NSLog(@"异步栅栏 start 😄");
    dispatch_barrier_async(concurrentQueue, ^{
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"异步栅栏 %@",[NSThread currentThread]);
        }];
    });
    
    NSLog(@"异步栅栏 end 😄");
    
    dispatch_async(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务5 %d",i);
        }];
    });
    dispatch_async(concurrentQueue, ^{
        
        [self forNumIncrementCondition:5 actionBlock:^(int i) {
            NSLog(@"任务6 %d",i);
        }];
    });
    
}

- (void)forNumIncrementCondition:(NSUInteger )num  actionBlock:(void(^)(int i))actionBlcok
{
    for (int a = 0; a < num; a ++)
    {
        if (actionBlcok) {
            actionBlcok(a);
        }
    }
}

-(void)writeAndRead{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("v_zhanggaotong", DISPATCH_QUEUE_CONCURRENT);
    
    concurrent_queue= dispatch_queue_create("v_zhanggaotong_Dmeo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        //写入：
        [self writeNSLog:@"++++"];
    });
    
    dispatch_async(concurrentQueue, ^{
        //读取：
        [self readNSLog:@"*****"];
    });
    dispatch_async(concurrentQueue, ^{
        //写入：
        [self writeNSLog:@"&&&&&"];
    });
    dispatch_async(concurrentQueue, ^{
        //读取：
        [self readNSLog:@"??????"];
    });
}

-(void)readNSLog:(NSString *)logStr{
    //同步并发：
    dispatch_sync(concurrent_queue, ^{
        NSLog(@"%@进入读取中",logStr);
        sleep(5);
        NSLog(@"%@读取完成",logStr);
    });
}

-(void)writeNSLog:(NSString *)logStr{
    
    //异步栅栏调用
    dispatch_barrier_async(concurrent_queue, ^{
        NSLog(@"%@写入中",logStr);
        sleep(10);
        NSLog(@"%@写入完成",logStr);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
