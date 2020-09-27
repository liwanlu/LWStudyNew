//
//  NSURLSessionStudyController.h
//  LWStudy
//
//  Created by liwanlu on 2020/9/25.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionStudyController : UIViewController
- (IBAction)btnSatrClick:(id)sender;
- (IBAction)btnSupendClick:(id)sender;
- (IBAction)btnResumeClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

NS_ASSUME_NONNULL_END
