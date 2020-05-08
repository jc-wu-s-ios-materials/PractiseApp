//
//  Man.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "Man.h"
#import "Person.h"
@interface Man ()
@property (nonatomic, strong) Person *favoriteStar;//喜爱的明星
@end

@implementation Man
-(instancetype)init{
    self = [super init];
    if (self) {
        self->colorOfHair = @"未知色";//public属性，且无getter和setter
        self.colorOfCoat = @"未知色";//外部可见属性，有getter和setter
        self.favoriteStar = [[Person alloc]init];//扩展属性，有getter和setter方法 Person init 后的Person->name=="还没名字"
        self->colorOfSock = @"未知色";//private属性，且无getter和setter
    }
    return self;
}
@end
