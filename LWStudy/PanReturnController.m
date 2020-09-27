//
//  滑动返回Controller.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "PanReturnController.h"

@interface PanReturnController ()

@end

@implementation PanReturnController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;

        // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];

        panGesture.delegate = self; // 设置手势代理，拦截手势触发

        [self.view addGestureRecognizer:panGesture];

        // 一定要禁止系统自带的滑动手势

        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer

    {

    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势

    if(self.navigationController.childViewControllers.count == 1)

    {

    return NO;

    }

    return YES;

    }
    @end
