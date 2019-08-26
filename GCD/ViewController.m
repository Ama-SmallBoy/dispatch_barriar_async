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
