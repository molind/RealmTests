//
//  ModelTrack.m
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//
//

#import "ModelTrack.h"

@implementation ModelTrack

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date folderUUID:(NSString *)folderUUID
{
    ModelTrack *rv = [[ModelTrack alloc] init];
    rv.uuid = uuid;
    rv.date = date;
    rv.folderUuid = folderUUID;
    rv.visible = YES;
    [realm addObject:rv];
    return rv;
}

+ (NSArray *)indexedProperties
{
    return @[@"folderUuid"];
}

+ (NSString *) primaryKey
{
    return @"uuid";
}

@end
