//
//  SynchronizedVC.m
//  @synchronized 锁
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "SynchronizedVC.h"
#import "SomeThing.h"

@interface SynchronizedVC ()
@property (nonatomic, strong) SomeThing *mything;


@end

@implementation SynchronizedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mything = [[SomeThing alloc]init];
    NSLog(@"%@",_HERE);
    /*
     @synchronized(object)指令使用的 object 为该锁的唯一标识，只有当标识相同时，才满足互斥。
     因此下面1234四个线程，12互斥，34互斥
     */
    dispatch_queue_t queue = dispatch_queue_create("队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        @synchronized (self) {
        for (int x =0; x<10; x++) {
            self.mything.number += 1;
            NSLog(@"线程1-运行%d-%ld",x,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
            }
        }
    });
    dispatch_async(queue, ^{
        @synchronized (self) {
            for (int y = 0; y <10; y++) {
                self.mything.number += 1;
                NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
                [NSThread sleepForTimeInterval:.4];
            }
        }
    });
    
    [NSThread detachNewThreadWithBlock:^{
        @synchronized (self.mything) {
            for (int x =0; x<10; x++) {
                self.mything.number += 1;
                NSLog(@"线程3-运行%d-%ld",x,self.mything.number);
                [NSThread sleepForTimeInterval:.4];
            }
        }
    }];
    [NSThread detachNewThreadWithBlock:^{
        @synchronized (self.mything) {
            for (int y = 0; y <10; y++) {
                    self.mything.number += 1;
                    NSLog(@"线程4-运行%d-%ld",y,self.mything.number);
                    [NSThread sleepForTimeInterval:.4];
                }
        }
    }];
}

@end
