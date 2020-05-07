//
//  Person.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "Person.h"


@implementation Person

-(instancetype)init{
    self = [super init];
    if (self) {
        self.status = PersonStatusUnknown;
        self->name = @"还没名字";
    }
    return self;
}
-(void)firstTimeChangeName{
    self->name = @"庞麦郎";
}
-(void)secondTimeChangeName{
    self->name = @"约瑟夫·庞麦郎";
}
@end
