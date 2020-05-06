//
//  NSConditionVC.m
//  NSCondition 条件所
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSConditionVC.h"
#import "SomeThing.h"
@interface NSConditionVC ()
@property (nonatomic, strong) SomeThing *mything;
@end

@implementation NSConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    self.mything = [[SomeThing alloc]init];
    
    dispatch_queue_t queue = dispatch_queue_create("队列", DISPATCH_QUEUE_CONCURRENT);
    NSCondition *condition = [[NSCondition alloc]init];
    
    //简单用法，直接和NSLock一样直接调用lock和unlock。
    //原因：都包含NSLocking协议
    dispatch_async(queue, ^{
        [condition lock];
        for (int x =0; x<10; x++) {
            self.mything.number += 1;
            NSLog(@"线程1-运行%d-%ld",x,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
        [condition unlock];
    });
    dispatch_async(queue, ^{
        [condition lock];
        for (int y = 0; y <10; y++) {
            self.mything.number += 1;
            NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
        [condition unlock];
    });
    
    [NSThread sleepForTimeInterval:10];
    //更高级用法，类似于信号量的wait和signal
    dispatch_async(queue, ^{
        NSLog(@"线程3等线程4先走5步再一起减少number");
        [condition wait];
        for (int x =0; x<10; x++) {
            self.mything.number -= 1;
            NSLog(@"线程3-运行%d-%ld",x,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
    });
    dispatch_async(queue, ^{
        for (int y = 0; y <10; y++) {
            if (y == 4) {
                [condition signal];
            }
            self.mything.number -= 1;
            NSLog(@"线程4-运行%d-%ld",y,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
    });
}



@end
//NSCondition和NSLock、@synchronized等是不同的是，NSCondition可以给每个线程分别加锁，加锁后不影响其他线程进入临界区。这是非常强大。
