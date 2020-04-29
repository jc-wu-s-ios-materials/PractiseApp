//
//  GCDViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/28.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* GCD 使用的步骤: 1.定制任务 2.将任务添加到队列中，指定运行方式。
     * GCD会自动将队列中的任务取出，放到对应的线程中执行。任务的取出遵循队列的FIFO原则，先进先出。
     * 不需要管理线程的生命周期；线程能够复用
     */
    
    
    //创建任务
    dispatch_block_t task1 = ^{
        NSLog(@"global_queue %@",[NSThread currentThread]);
    };
    //获取队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //任务加入队列
    dispatch_async(queue, task1);//与下面被注释的两行等效,threanumber==5
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"task %@",[NSThread currentThread]);
//    });
    //不需要管理线程生命周期,线程能够复用
    for(NSInteger i = 0;i<2;i++){
        dispatch_sync(queue, task1);//同步执行，复用task1，threadnumber==1
    }
    //创建队列 SERIAL
    dispatch_queue_t serialQueue = dispatch_queue_create("serial队列", DISPATCH_QUEUE_SERIAL);
    for (NSInteger i=0; i<10; i++) {
        dispatch_async(serialQueue, ^{//异步执行串行队列,threadnumber==4
            NSLog(@"串行异步-%@-%ld",[NSThread currentThread],i);
        });
        NSLog(@"添加了异步串行-%ld",i);
    }
    for (NSInteger i=0; i<10; i++) {
        dispatch_sync(serialQueue, ^{//同步执行串行队列,threadnumber==1
            NSLog(@"串行同步-%@-%ld",[NSThread currentThread],i);
        });
        NSLog(@"添加了同步串行-%ld",i);
    }
    //创建队列 CONCURRENT
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent队列", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i=0; i<10; i++) {
        dispatch_async(concurrentQueue, ^{//异步执行并行队列，threadnumber==4,5,6,7,8
            NSLog(@"并行异步-%@-%ld",[NSThread currentThread],i);
        });
        NSLog(@"添加了异步并行-%ld",i);
    }
    for (NSInteger i=0; i<10; i++) {
        dispatch_sync(concurrentQueue, ^{//同步执行并行队列，threadnumber ==1
            NSLog(@"并行同步-%@-%ld",[NSThread currentThread],i);
        });
        NSLog(@"添加了同步并行-%ld",i);
    }
    /*  主队列⬇️
     *  主队列是特殊的串行队列，永远在主线程执行
     */
    //主队列-异步- OK
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    for (NSInteger i=0; i<10; i++) {
        dispatch_async(mainQueue, ^{//异步执行主队列，threadnumber == 1
            NSLog(@"主队列-异步-%@-%ld",[NSThread currentThread],i);
        });
        NSLog(@"添加了异步主队列-%ld",i);
    }
    //主队列-同步- 报错 - 死锁
//    dispatch_sync(mainQueue, ^{
//       //即使只有1个block，即使block里面啥也没有，主队列-同步，也会死报错。
//    });
    /* ⬆️此处报错
     *  @discussion -dispatch_sync(dispatch_queue_t queue, DISPATCH_NOESCAPE dispatch_block_t block)
     *  Submits a workitem to a dispatch queue like dispatch_async(), however
     *  dispatch_sync() will not return until the workitem has finished.
     */
    
    
    //队列组
    NSLog(@"创建下载队列组");
    dispatch_group_t myGroup = dispatch_group_create();
    dispatch_group_async(myGroup, concurrentQueue, ^{
        NSLog(@"开始下载音乐");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"完成下载音乐");
    });
    dispatch_group_async(myGroup, concurrentQueue, ^{
        NSLog(@"开始下载电影");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"完成下载电影");
    });
    dispatch_group_notify(myGroup, concurrentQueue, ^{
        NSLog(@"全部下载完成");
    });
    
    
    //dispatch_once_t 可以多次调用，但是只会执行一次，常用于单例模式
    [self runOnlyOnce];
    [self runOnlyOnce];
    [self runOnlyOnce];
    
    
    
}

-(void)runOnlyOnce{
    static dispatch_once_t onceToken;//第一次调用时,onceToken=0,再次调用时onceToken不为0
    dispatch_once(& onceToken, ^{
        NSLog(@"常用于单例模式");
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
