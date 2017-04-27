//
//  ViewController.m
//  FWApp
//
//  Created by Weidong Gu  on 05/03/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import "ViewController.h"
#import <FWCore/FWCore.h>

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
    UIViewController *fwFrameworkViewController = [[FWBusAccessor defaultBusAccessor]resourceWithURI:[FWURI URIWithString:@"ui://com.tw.FWFramework/main?showTest=FWCoreIsOk"]];
    [self.navigationController pushViewController:fwFrameworkViewController animated:YES];
}

- (IBAction)clickDownloadFWFramework2Button:(id)sender {
//    [self.class downloadFWFramework2];
}

- (IBAction)clickGoFWFramework2ViewControllerButton:(id)sender {
//    UIViewController *fwFrameworkViewController = [self loadFrameworkViewControllerWithBundleNamed:@"FWFramework2"];
//    [self.navigationController pushViewController:fwFrameworkViewController animated:YES];
}

@end
