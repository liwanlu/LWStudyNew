//
//  LWNavigationController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "LWNavigationController.h"

@interface LWNavigationController ()

@end

@implementation LWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"启动了");
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.view.backgroundColor=[UIColor whiteColor];
    
    [super pushViewController:viewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
