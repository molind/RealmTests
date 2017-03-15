//
//  ModelFolder.m
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//
//

#import "ModelFolder.h"

@implementation ModelFolder
{
}

+ (NSString *) primaryKey
{
    return @"uuid";
}

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date
{
    ModelFolder *rv = [[ModelFolder alloc] init];
    rv.uuid = uuid;
    rv.name = name;
    rv.date = date;
    rv.opened = YES;
    [realm addObject:rv];
    return rv;
}

@end
