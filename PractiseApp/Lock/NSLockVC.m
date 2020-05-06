//
//  NSLockVC.m
//  NSLock 锁
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSLockVC.h"

@interface NSLockVC ()
@property (nonatomic, copy) NSString *str;


@end

@implementation NSLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.str = @"开始";
    
    [NSThread detachNewThreadWithBlock:^{
        self.str = @"改变";
    }];
    
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"str == %@",self.str);
    }];
    
}


@end
