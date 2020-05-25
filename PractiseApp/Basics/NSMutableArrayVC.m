//
//  NSMutableArrayVC.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/25.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "NSMutableArrayVC.h"

@interface NSMutableArrayVC ()

@end

@implementation NSMutableArrayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    // Do any additional setup after loading the view.

    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 100000; i++) {
        array[i] = @(i);
        NSLog(@"%@",array[i]);
    }
    array[100000] = @"a";
    array[100001] = @"b";

    array[100003] = @"c";


}

@end
