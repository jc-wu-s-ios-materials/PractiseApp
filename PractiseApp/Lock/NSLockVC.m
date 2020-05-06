//
//  NSLockVC.m
//  NSLock 锁
//  低端锁。一旦获取锁，执行则进入临界区，且不会允许超过一个线程并行执行。
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSLockVC.h"
#import "SomeThing.h"

@interface NSLockVC ()
@property (nonatomic, strong) SomeThing *mything;

@end

@implementation NSLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mything = [[SomeThing alloc]init];
    
    
    [NSThread detachNewThreadWithBlock:^{
        [self.mything.lock lock];
        for (int x =0; x<10; x++) {
            self.mything.number += 1;
            NSLog(@"线程1-运行%d-%ld",x,self.mything.number);
//            [NSThread sleepForTimeInterval:.4];
        }
        [self.mything.lock unlock];
    }];
    
    [NSThread detachNewThreadWithBlock:^{
        for (int y = 0; y <10; y++) {
            self.mything.number += 1;
            NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
    }];
    
}
/*
 在Cocoa程序中NSLock中实现了一个简单的互斥锁，实现了NSLocking protocol。
 lock，加锁
 unlock，解锁
 tryLock，尝试加锁，如果失败了，并不会阻塞线程，只是立即返回
 NOlockBeforeDate:，在指定的date之前暂时阻塞线程（如果没有获取锁的话），如果到期还没有获取锁，则线程被唤醒，函数立即返回NO
 使用tryLock并不能成功加锁，如果获取锁失败就不会执行加锁代码了。
 */


@end

