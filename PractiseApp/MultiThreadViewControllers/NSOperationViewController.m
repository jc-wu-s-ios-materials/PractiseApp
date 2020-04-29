//
//  NSOperationViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/28.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     NSOperation面向对象，基于GCD封装，比GCD多一些简单的功能，基于OC语言。线程的生命周期是自动管理的，经常使用。
     NSOperation是一个抽象类，不具备封装任务的能力，不可以直接使用，它只是约束子类都具有共同的属性和方法。因此必须使用它的子类：
     1.NSInvocationOperation
     2.NSBlockOperation
     3.自定义子类，继承NSOperation，实现内部相应的方法
     子类创建operation使用的方法虽不尽相同，但最后都需要调用start方法来启动执行任务。
     默认情况下，调用start方法后不会新开一个线程执行任务，
     而是在当前线程同步执行，只有将NSOperation放入一个NSOperationQueue中，才会异步执行操作。
     */
    
    //NSInvocationOperation 使用-start开启 较少使用
    NSInvocationOperation *myNSInvocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(showLog:) object:@"一个对象"];
    myNSInvocationOperation.completionBlock = ^{
        NSLog(@"myNSInvocationOperation 任务完成!");
    };
    [myNSInvocationOperation start];
    
    //NSBlockOperation 使用-start开启
    //默认情况下，调用start方法后不会新开一个线程执行任务，而是在当前线程同步执行
    //只有将NSOperation放入一个NSOperationQueue中，才会异步执行操作。
    NSBlockOperation *myNSBlockOperation1 = [[NSBlockOperation alloc]init];
    myNSBlockOperation1.completionBlock = ^{//监听任务是否执行完毕，这个block在任务完成之后执行，而且它不在主线程上，也与它监听的任务不一定在同一个线程上
        NSLog(@"myNSBlockOperation1 任务完成,此时在%@",[NSThread currentThread]);
    };
    for (NSInteger i = 0; i < 6; i++) {
        [myNSBlockOperation1 addExecutionBlock:^{//addExecutionBlock方法给operation添加额外的任务，这时operation中的所有任务并发执行（当前线程和其他子线程）
            NSLog(@"BOP1-block%ld,运行在:%@",i,[NSThread currentThread]);
        }];
    }
    [myNSBlockOperation1 start];
    NSBlockOperation *myNSBlockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"直接block创建BOP2,运行在:%@",[NSThread currentThread]);
    }];
    myNSBlockOperation2.completionBlock = ^{
        NSLog(@"myNSBlockOperation2 任务完成,此时在%@",[NSThread currentThread]);
    };
    for (NSInteger i=0; i < 6; i++) {
        [myNSBlockOperation2 addExecutionBlock:^{//addExecutionBlock方法给operation添加额外的任务，这时operation中的所有任务并发执行（当前线程和其他子线程）
            NSLog(@"BOP2-bock%ld，运行在:%@",i+1,[NSThread currentThread]);
        }];
    }
//    [myNSBlockOperation2 start];
    NSBlockOperation *myNSBlockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"直接block创建BOP3,运行在:%@",[NSThread currentThread]);
    }];
    myNSBlockOperation3.completionBlock = ^{
        NSLog(@"myNSBlockOperation3 任务完成,此时在%@",[NSThread currentThread]);
    };
    for (NSInteger i=0; i < 6; i++) {
        [myNSBlockOperation3 addExecutionBlock:^{//addExecutionBlock方法给operation添加额外的任务，这时operation中的所有任务并发执行（当前线程和其他子线程）
            NSLog(@"BOP3-bock%ld，运行在:%@",i+1,[NSThread currentThread]);
        }];
    }
//*****NSOperation*****⬆️
//*******************************************************
//*****NSOperationQueue*****⬇️
    //NSOperation 加入 NSOperationQueue之后，自动调用start，且异步执行
    //若[myNSBlockOperation2 start];则在主线程和子线程运行，若myNSBlockOperation2加入queue则不会在主线程运行。
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;//若=0，则queue的op都不会执行。若=1，则可以基本在同一个多线程内线性执行。不过运行时发现OP的最后一个bock可能去另一个线程。
    [queue addOperationWithBlock:^{
        NSLog(@"queue增加匿名blockOP,运行在:%@",[NSThread currentThread]);
    }];
    queue.suspended = YES;//暂时挂起，正在执行的OP会继续执行完，还未执行的OP会挂起等待
    //2添加3为依赖，需要3完成后才能执行2。2和3可以跨越不同队列。
    [myNSBlockOperation2 addDependency:myNSBlockOperation3];//不要互相添加依赖，容易死锁。另外建议先add依赖，再进入queue。
    [queue addOperation:myNSBlockOperation2];
    [queue addOperation:myNSBlockOperation3];
    //这一行报错不可执行，触发NSInvalidArgumentException，因为myNSBlockOperation1已经finished完成，不能再被enqueued入列。
//    [queue addOperation:myNSBlockOperation1];
//    [queue cancelAllOperations];  若在这里加入这一行，则queue内的Opreation都不执行
//    [queue waitUntilAllOperationsAreFinished]; //若在这里加入这一行，则后面的代码需要等待queue执行所有opreation后才执行
    NSLog(@"呵呵呵呵，先挂起2秒");
    [NSThread sleepForTimeInterval:2];
    queue.suspended = NO;//停止挂起，queue内还未执行的OP可以执行
    NSOperationQueue * otherQueue = [[NSOperationQueue alloc]init];
    //线程之间通信，例如
    [queue addOperationWithBlock:^{
        //这个线程做点事情
        NSLog(@"1+1=?,问在线程%@",[NSThread currentThread]);
        NSInteger result = 2;
            // 到另一个队列(这里写的主队列)
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //作出响应
                NSInteger answer = result;
                NSLog(@"1+1=%ld,答在线程%@",result,[NSThread currentThread]);
                // 到另一个队列
                [otherQueue addOperationWithBlock:^{
                    NSInteger corret = result;
                    if (answer == corret) {
                        NSLog(@"我觉得他说的对,评论在线程%@",[NSThread currentThread]);
                    }
                }];
            }];
    }];
    
    
//*****NSOperationQueue*****⬆️
}

-(void)showLog:(id)sender{
    NSLog(@"sender==%@",sender);
}
@end


//自定义NSOperation子类
@interface CustomOperation : NSOperation
@end
@implementation CustomOperation
-(void)main{
    NSLog(@"自定义Op对象开始运行main方法");
    
    [self doSomeThingNeedTime];
    if (self.isCancelled) {//建议每次耗时操作时，都要对isCancel进行检验，如果cancel了就直接结束
        return;
    }
    
    [self doSomeThingNeedTime];
    if (self.isCancelled) {
        return;
    }
}
-(void)doSomeThingNeedTime{//随便写了个方法，表示在执行耗时操作
    [NSThread sleepForTimeInterval:5];
}
@end
