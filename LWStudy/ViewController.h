//
//  ViewController.h
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnThread;
@property (weak, nonatomic) IBOutlet UIButton *btn_return;

- (IBAction)btnCLick:(UIButton *)sender;

@end

