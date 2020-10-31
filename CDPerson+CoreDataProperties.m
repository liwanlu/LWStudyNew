//
//  CDPerson+CoreDataProperties.m
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//
//

#import "CDPerson+CoreDataProperties.h"

@implementation CDPerson (CoreDataProperties)

+ (NSFetchRequest<CDPerson *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CDPerson"];
}

@dynamic age;
@dynamic name;
@dynamic sex;

@end
