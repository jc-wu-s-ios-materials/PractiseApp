//
//  Man.h
//  PractiseApp
//
//  Created by 吴京城 on 2020/5/7.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Man : NSObject
{
    @private
    NSString* colorOfSock;//袜子颜色
    @public
    NSString* colorOfHair;//头发颜色
}
@property (nonatomic, copy) NSString *colorOfCoat;//外套颜色
@end

NS_ASSUME_NONNULL_END
