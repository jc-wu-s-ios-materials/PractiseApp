//
//  ThreadViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/28.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __block NSInteger x = 0;
    [NSThread detachNewThreadWithBlock:^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"x = %ld,x=x+1= %ld",x,++x);
        }
    }];
}


@end
