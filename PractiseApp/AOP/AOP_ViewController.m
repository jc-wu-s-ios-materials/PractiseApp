//
//  AOP_ViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/8.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "AOP_ViewController.h"
#import "Stastic.h"

@interface AOP_ViewController ()

@end

@implementation AOP_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_HERE);
    
    //一般的做法(非AOP)
    [Stastic stasticWithEventName:@"普通做法:AOP_ViewController"];
    
    //AOP做法
    //创建了 AOP_ViewController+Stastic .h.m 文件
    //交换了 -viewDidLoad 和 -swizzle_viewDidLoad 方法
    //在 新的-viewDidLoad 方法中先加上了一句[Stastic stasticWithEventName:@"AOP做法----> AOP_ViewController"];\
        然后调用原来的 -viewDidLoad方法
    
}

@end
