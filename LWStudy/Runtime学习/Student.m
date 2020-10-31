//
//  student.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>

@implementation Student
-(void)beginStudy:(NSString *)subject
{
    NSLog(@"%@在%@开始学习%@",self.pName,_schoolName,subject);
}


@end
