//
//  ViewController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "ViewController.h"
#import "GCDStudyController.h"
#import "PanReturnController.h"
#import "NSOperationStudyController.h"
#import "RunLoopStudyController.h"
#import "AFNStudyController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"学习";
//    [_btnThread addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//     [_btn_return addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (IBAction)btnCLick:(UIButton *)sender {
    
    if(sender.tag==1)
        {
            NSOperationStudyController *thread=[NSOperationStudyController new];
              [self.navigationController pushViewController:thread animated:YES];
        }
    else if (sender.tag==2)
        {
           PanReturnController *thread=[PanReturnController new];
            [self.navigationController pushViewController:thread animated:YES];
        }
    else if(sender.tag==3)
    {
        
        RunLoopStudyController *thread=[RunLoopStudyController new];
                   [self.navigationController pushViewController:thread animated:YES];
    }
    else if(sender.tag==4)
      {
          
          AFNStudyController *thread=[AFNStudyController new];
                     [self.navigationController pushViewController:thread animated:YES];
      }
}
@end
