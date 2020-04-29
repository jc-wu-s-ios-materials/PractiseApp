//
//  WelcomeToSandBoxViewController.m
//  PractiseApp
//
//  Created by 吴京城 on 2020/4/29.
//  Copyright © 2020 吴京城. All rights reserved.
//

#import "WelcomeToSandBoxViewController.h"
//#import <>
@interface WelcomeToSandBoxViewController ()
@property (nonatomic, copy) NSString *docPath;  // documents目录
@property (nonatomic, copy) NSString *tmpPath;  // tmp目录
@property (nonatomic, copy) NSString *libPath;  // Library目录
@property (nonatomic, copy) NSString *cachePath;// Library/Caches目录
@property (nonatomic, copy) NSString *prePath;  // Library/Preferences目录，通常系统维护，很少人为操作
@property (nonatomic, copy) NSString *appPath;  // 获取应用程序包的路径
@end

@implementation WelcomeToSandBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化获取路径
    [self findMyPaths];
//    [self showMyPaths]; //验证是否获得路径
    
    //写入和取出
    NSString *filename = @"写入读取.txt";//文件名称
//    id content = @"江南皮革厂倒闭了！";//写入的内容为 NSString
//    id content = @[@"c",@"c++",@"c#",@"oc",@"swift"]; //写入的内容为NSArray
//    id content = @{@"职业":@"coder",@"性别":@"男"};//写入内容为NSDictionary
    id content = [self getMyNSData];//写入内容为NSData
    
    NSBlockOperation *writhStrOP = [NSBlockOperation blockOperationWithBlock:^{
        [self safelyWriteMyContent:content InMyFileNamed:filename InDir:self.docPath];
    }];
    NSBlockOperation *readStrOP = [NSBlockOperation blockOperationWithBlock:^{
//        [self readMyStringInDocDicFileNamed:filename];
        [self readMyNSdataFileNamed:filename InDir:self.docPath];
    }];
    [readStrOP addDependency:writhStrOP];//加dependency确保先写后读(在不使用队列&&逆序start的情况下不能保证)
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:readStrOP];//此处如果不使用queue，直接先start read再start write会崩溃。
    [queue addOperation:writhStrOP];//但是如果使用queue,在有dependency情况下，即使先add read再add write也不会崩溃
}

#pragma mark - 文件管理
//  在{dir}文件夹下创建新的文件夹
-(NSString*)addNewDirNamed:(NSString*)dirname InDir:(NSString*)dir{
    NSString* dirPath = [dir stringByAppendingPathComponent:dirname];//创建文件夹的路径
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    return dirPath;
}
//  文件移动
//  文件对接
#pragma mark - 写入进阶版 支持各类数据⬇️
-(void)writeMyContent:(id)content InMyFileNamed:(NSString*)filename{
    NSString *filePath = [self.docPath stringByAppendingPathComponent:filename];
    [content writeToFile:filePath atomically:YES];
}
-(void)safelyWriteMyContent:(id)content InMyFileNamed:(NSString*)filename InDir:(NSString*)dir{
    NSString *filePath = [dir stringByAppendingPathComponent:filename];
    if ([content isKindOfClass:[NSString class]]) {
        [(NSString*)content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        [content writeToFile:filePath atomically:YES];
    }
}
#pragma mark - 写入基础版 各类数据分开⬇️
-(void)writeMyString:(NSString*)str InMyFileNamed:(NSString*)filename InDir:(NSString*)dir{
    //在document目录下写入
    NSString *filePath = [dir stringByAppendingPathComponent:filename];//验证易知 self.docPath没有被改变,path获得预期结果
    //字符串写入执行的方法,此方法会覆盖原有内容
    [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];//覆盖写法
}
#pragma mark - 读取数据⬇️
//读取String
-(void)readMyStringFileNamed:(NSString*)filename InDir:(NSString*)dir{
    NSString *filePath = [dir stringByAppendingPathComponent:filename];
    NSString *resultStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@的内容为:%@",filename,resultStr);
}
//读取NSData
-(void)readMyNSdataFileNamed:(NSString*)filename InDir:(NSString*)dir{
    NSString *filePath = [dir stringByAppendingPathComponent:filename];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"%@的内容为:%@",filename,data);
}
//.....还有其他的类型


#pragma mark - 一些其他方法
-(UIImage*)getMyWebImage{//获取网络图片
    NSString *urlStr = @"https://www.runoob.com/wp-content/uploads/2015/10/swift.png";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}
-(NSData*)getMyNSData{//随便获取一个data
    NSString *urlStr = @"https://www.runoob.com/wp-content/uploads/2015/10/swift.png";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSLog(@"data为:%@",data);
    return data;
}
-(NSArray*)getMyNSArryFromNSString:(NSString*)string{//从NSString得到NSArray
    NSArray *array = [string componentsSeparatedByString:@","];
    return array;
}
-(NSDictionary*)geMyDictionaryFromJsonString:( NSString*)jsonStr{
    NSDictionary *dic = nil;
    if (jsonStr){
        NSDate * _Nullable jsData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSError *error;
        dic = [NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"JsonStr解析为Dictionary失败");
        }
    }
    return dic;
}
#pragma mark - 路径⬇️
-(void)findMyPaths{
    self.docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.tmpPath = NSTemporaryDirectory();
    self.libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    self.cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    self.prePath = [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
    self.appPath = [NSBundle mainBundle].resourcePath;
}
-(void)showMyPaths{
    NSLog(@"前面5个Path的前半段同为:%@",[self.docPath substringToIndex:76]);//到76，不包含76
    NSLog(@"documents目录:%@",[self.docPath substringFromIndex:76]);//从76开始，包含76
    NSLog(@"tmp目录:%@",[self.tmpPath substringFromIndex:76]);
    NSLog(@"Library目录:%@",[self.libPath substringFromIndex:76]);
    NSLog(@"Library/Caches目录:%@",[self.cachePath substringFromIndex:76]);
    NSLog(@"Library/Preferences目录:%@",[self.prePath substringFromIndex:76]);
    NSLog(@"应用程序包路径:%@",self.appPath);
}
-(void)whatDoThosePathsMean{//这些路径的意义
/*
 *Documents/
 保存应用程序的重要数据文件和用户数据文件等。用户数据基本上都放在这个位置
 (例如从网上下载的图片或音乐文件)，该文件夹在应用程序更新时会自动备份，在连接iTunes时也可以自动同步备份其中的数据；
 该目录的内容被iTunes和iCloud备份。
 *
 *Library/
 这个目录下有两个子目录,可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份；
 该目录的内容被iTunes和iCloud备份
 *
 *Tmp/
 使用此目录可以编写在应用程序启动之间不需要保留的临时文件，您的应用程序应在不再需要时删除此目录中的文件，但是，当您的应用未运行时，系统可能会清除此目录；
 iTunes或iCloud不会备份此目录下的内容。
 *
 *Library/Caches
 保存应用程序使用时产生的支持文件和缓存文件(保存应用程序再次启动过程中需要的信息)，还有日志文件最好也放在这个目录；
 iTunes 不会备份该目录，并且该目录下数据可能被其他工具清理掉。
 *
 *Library/Preferrences
 保存应用程序的偏好设置文件。NSUserDefaults类创建的数据和plist文件都放在这里；
 该目录的内容被iTunes和iCloud备份。
 *
 *AppName.app
 应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以不能在运行时对这个目录中的内容进行修改，否则会导致应用程序无法启动。
 */
}
@end
