//
//  Guy.h
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/8.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Aspects/Aspects.h>

NS_ASSUME_NONNULL_BEGIN

@interface Guy : NSObject <AspectToken>
@property (nonatomic, strong) NSString *name;//名字
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithName:(NSString*)name NS_DESIGNATED_INITIALIZER;
-(void)isAskedQuestionsHeDontKnow;//被问到不懂的问题

@end

NS_ASSUME_NONNULL_END
