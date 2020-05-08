//
//  Person.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "Person.h"
@interface Person ()
{
    @private
    NSString* colorOfSock;//袜子颜色
}
@property (nonatomic, strong) NSString *sex;
@end

@implementation Person

-(instancetype)init{
    self = [super init];
    if (self) {
        self.status = PersonStatusUnknown;
        self->name = @"还没名字";
        self.sex = @"性别未知";
        self->colorOfSock = @"未知颜色";
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
