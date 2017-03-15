//
//  ModelTrack.h
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//
//

#import <Realm/Realm.h>

@interface ModelTrack : RLMObject

@property NSString *uuid;
@property NSString *name;
@property NSString *descr;
@property NSString *shareURL;
@property int64_t date;
@property NSString *folderUuid;
@property BOOL visible;
@property int color;
@property NSData *data;
@property NSData *stats;

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date folderUUID:(NSString *)folderUUID;

@end

