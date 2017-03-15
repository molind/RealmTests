//
//  ModelBookmark.h
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//
//

#import <Realm/Realm.h>

@interface ModelBookmark : RLMObject

@property NSString *uuid;
@property NSString *name;
@property NSString *descr;
@property NSString *shareURL;
@property int64_t date;
@property NSString *folderUuid;
@property double longitude;
@property double latitude;
@property double mapZoom;
@property int category;
@property BOOL visible;

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date folderUUID:(NSString *)folderUUID lon:(double) lon lat:(double)lat mapZoom:(double)mapZoom;

@end
