//
//  SemaphoreVC.m
//  Semaphore(信号量),  条件信号量 替代 锁的作用
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "SemaphoreVC.h"
#import "SomeThing.h"

@interface SemaphoreVC ()
{
    dispatch_semaphore_t semaphore;
}
@property (nonatomic, strong) SomeThing *mything;

@end

@implementation SemaphoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    self.mything = [[SomeThing alloc]init];
    self->semaphore = dispatch_semaphore_create(1);//创造信号量为1的信号
    
    dispatch_queue_t queue = dispatch_queue_create("队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //如果该信号量的值大于0，则使其信号量的值-1。\
        否则阻塞线程直到该信号量的值大于0或者达到等待时间DISPATCH_TIME_FOREVER
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);//等待信号量
        for (int x =0; x<10; x++) {
            self.mything.number += 1;
            NSLog(@"线程1-运行%d-%ld",x,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
        dispatch_semaphore_signal(self->semaphore);//释放信号量
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);//等待信号量
        for (int y = 0; y <10; y++) {
            self.mything.number += 1;
            NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
        dispatch_semaphore_signal(self->semaphore);//释放信号量
    });
}

@end
/*
dispatch_semaphore_tGCD中信号量，也可以解决资源抢占问题,支持信号通知和信号等待。每当发送一个信号通知，则信号量+1；每当发送一个等待信号时信号量-1,；如果信号量为0则信号会处于等待状态，直到信号量大于0开始执行。
*/
