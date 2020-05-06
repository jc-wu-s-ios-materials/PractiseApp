//
//  BaseViewController.h
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/27.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "UIImageView+CornerRadius.h"

//_HERE 宏
#define _HERE ({ \
    NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
    [NSString stringWithFormat:@"%s (%@:%d)", __PRETTY_FUNCTION__, file, __LINE__]; \
})

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIButton *closeBtn;
-(void)closeSelf;
@end

NS_ASSUME_NONNULL_END
