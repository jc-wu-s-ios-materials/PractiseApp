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
    
    [NSThread detachNewThreadWithBlock:^{
        for (int x =0; x<10; x++) {
            self.mything.number += 1;
            NSLog(@"线程1-运行%d-%ld",x,self.mything.number);
            [NSThread sleepForTimeInterval:.4];
        }
    }];
    [NSThread detachNewThreadWithBlock:^{
        @synchronized (self.mything) {
            for (int y = 0; y <10; y++) {
                @synchronized (self.mything) {
                    self.mything.number += 1;
                    NSLog(@"线程2-运行%d-%ld",y,self.mything.number);
                    [NSThread sleepForTimeInterval:.4];
                }
            }
        }
    }];
}

@end
