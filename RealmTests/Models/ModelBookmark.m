//
//  ModelBookmark.m
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//
//

#import "ModelBookmark.h"

@implementation ModelBookmark
{
}

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date folderUUID:(NSString *)folderUUID lon:(double) lon lat:(double)lat mapZoom:(double)mapZoom
{
    ModelBookmark *rv = [[ModelBookmark alloc] init];
    rv.uuid = uuid;
    rv.date = date;
    rv.latitude = lat;
    rv.longitude = lon;
    rv.mapZoom = mapZoom;
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
