//
//  NSRecursiveLockVC.m
//  NSRecursiveLock 递归锁
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSRecursiveLockVC.h"
#import "SomeThing.h"
@interface NSRecursiveLockVC ()
@property (nonatomic, strong) SomeThing *mything;
@end

@implementation NSRecursiveLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    self.mything = [[SomeThing alloc]init];
    
    dispatch_queue_t queue = dispatch_queue_create("队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSLog(@"%ld",self.mything.number);
    });
    dispatch_async(queue, ^{
        for (int y = 0; y <10; y++) {
            self.mything.number += 1;
            NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
    });
    
}
@end
/*
 有时候“加锁代码”中存在递归调用，递归开始前加锁，递归调用开始后会重复执行此方法以至于反复执行加锁代码最终造成死锁,
 这个时候可以使用递归锁来解决。使用递归锁可以在一个线程中反复获取锁而不造成死锁，
 这个过程中会记录获取锁和释放锁的次数，只有最后两者平衡锁才被最终释放。
 */
