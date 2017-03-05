//
//  ViewController.m
//  FWApp
//
//  Created by Weidong Gu  on 05/03/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import "ViewController.h"

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
}

- (IBAction)clickGoFWFramework2ViewControllerButton:(id)sender {
}

- (id)loadFrameworkViewControllerWithBundleNamed:(NSString *)frameworkName ViewControllerName:(NSString *)viewControllerName{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Embedded/%@",frameworkName] ofType:@"framework"];
    
    // Check bundle exists
    if (![manager fileExistsAtPath:bundlePath]) {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:@"Not Found Framework" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okAction];
        [self presentViewController:alertViewController animated:YES completion:nil];
        return nil;
    }
    
    // Load bundle
    NSError *error = nil;
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlePath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"Load framework successfully");
    }else {
        NSLog(@"Failed to load framework : %@",error);
        return nil;
    }
    
    // Load class
    Class class = NSClassFromString(viewControllerName);
    if (!class) {
        NSLog(@"Unable to load class");
        return nil;
    }
    
    id object = [class new];
    return object;
}
@end
