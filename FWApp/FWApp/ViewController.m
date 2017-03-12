//
//  ViewController.m
//  FWApp
//
//  Created by Weidong Gu  on 05/03/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <ZipArchive/ZipArchive.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickGoFWFrameworkViewControllerButton:(id)sender {
    UIViewController *fwFrameworkViewController = [self loadFrameworkViewControllerWithBundleNamed:@"FWFramework" ViewControllerName:@"FWFrameworkViewController"];
    [self.navigationController pushViewController:fwFrameworkViewController animated:YES];
}

- (IBAction)clickDownloadFWFramework2Button:(id)sender {
    [self.class downloadFWFramework2];
}

- (IBAction)clickGoFWFramework2ViewControllerButton:(id)sender {
    UIViewController *fwFrameworkViewController = [self loadFrameworkViewControllerWithBundleNamed:@"FWFramework2" ViewControllerName:@"FWFramework2ViewController"];
    [self.navigationController pushViewController:fwFrameworkViewController animated:YES];
}

- (id)loadFrameworkViewControllerWithBundleNamed:(NSString *)frameworkName ViewControllerName:(NSString *)viewControllerName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0) {
        documentDirectory = [paths objectAtIndex:0];
    }
    
    NSString *bundlePath = [documentDirectory stringByAppendingPathComponent:[frameworkName stringByAppendingString:@".framework"]];
    
    // 检查framework是不是在Documents
    if (![manager fileExistsAtPath:bundlePath]) {
        NSLog(@"No framework in documents");
        bundlePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Embedded/%@",frameworkName] ofType:@"framework"];
        
        // 检查framework是不是在mainBundle
        if (![manager fileExistsAtPath:bundlePath]) {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Not Found %@.framework",frameworkName] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleDefault handler:nil];
            [alertViewController addAction:okAction];
            [self presentViewController:alertViewController animated:YES completion:nil];
            return nil;
        }
    }
    
    // 加载Framework
    NSError *error = nil;
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlePath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"Load framework successfully");
    }else {
        NSLog(@"Failed to load framework : %@",error);
        return nil;
    }
    
    // 加载class
    Class class = NSClassFromString(viewControllerName);
    if (!class) {
        NSLog(@"Unable to load class");
        return nil;
    }
    
    id object = [class new];
    return object;
}

+ (void)downloadFWFramework2{
    // 1、 设置请求
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://7qn8gw.com1.z0.glb.clouddn.com/FWFramework2.framework.zip"]];
    // 2、初始化
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 3、开始下载
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //这里要返回一个NSURL，其实就是文件的位置路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //使用建议的路径
        path = [path stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载成功
        if (error == nil) {
            NSLog(@"下载完成:%@",[filePath path]);
        }else{//下载失败的时候，只列举判断了两种错误状态码
            NSString * message = nil;
            if (error.code == - 1005) {
                message = @"网络异常";
            }else if (error.code == -1001){
                message = @"请求超时";
            }else{
                message = @"未知错误";
            }
            NSLog(@"%@",message);
        }
        //解压
        NSString *filePathString = filePath.path;
        NSLog(@"解压文件：%@",filePathString);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"解压到：%@",path);
        if ([SSZipArchive unzipFileAtPath:filePathString toDestination:path]) {
            NSLog(@"解压成功");
        }
    }];
    //开始启动任务
    [task resume];
}

@end
