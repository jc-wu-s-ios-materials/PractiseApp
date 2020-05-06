//
//  SomeThing.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/6.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "SomeThing.h"

@implementation SomeThing
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.number = 0;
        self.lock = [[NSLock alloc]init];
    }
    return self;
}
@end
