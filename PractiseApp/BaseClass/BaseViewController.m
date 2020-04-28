//
//  BaseViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/27.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hidMyScreen];
}

-(void)hidMyScreen{//上班摸鱼时保持黑屏幕
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.7];
    self.closeBtn = [[UIButton alloc]init];
    [self.closeBtn setTitle:@"返回主页面" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-20);
    }];
}

@end
