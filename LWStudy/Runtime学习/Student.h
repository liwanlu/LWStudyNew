//
//  student.h
//  LWStudy
//
//  Created by liwanlu on 2020/9/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : Person
@property(nonatomic,strong) NSString *schoolName;
-(void)beginStudy:(NSString *)subject;
@end

NS_ASSUME_NONNULL_END
