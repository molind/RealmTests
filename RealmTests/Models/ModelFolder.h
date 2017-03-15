//
//  ModelFolder.h
//  Galileo
//
//  Created by Arkadiy Tolkun on 1/3/17.
//

#import <Realm/Realm.h>

@interface ModelFolder : RLMObject

@property NSString *uuid;
@property NSString *name;
@property NSString *descr;
@property NSString *shareURL;
@property int64_t date;
@property BOOL opened;

+(instancetype) createInRealm:(RLMRealm *)realm uuid:(NSString *)uuid name:(NSString *)name date:(int64_t)date;

@end
