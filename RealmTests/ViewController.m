//
//  ViewController.m
//  RealmTests
//
//  Created by Arkadiy Tolkun on 3/15/17.
//  Copyright © 2017 Arkadiy Tolkun. All rights reserved.
//

#import "ViewController.h"

#import <Realm/Realm.h>
#import "ModelFolder.h"
#import "ModelTrack.h"
#import "ModelBookmark.h"

@implementation ViewController
{
    RLMNotificationToken *_token;
    NSMutableArray<NSString *> *_tracks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prmaryKeyChangeTest:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray<NSNumber *> *) updateModify:(NSArray<NSNumber *> *)modify withDelete:(NSIndexSet *)del andInsert:(NSIndexSet *)insert
{
    NSMutableArray<NSNumber *> *rv = [NSMutableArray array];
    for (NSNumber *num in modify) {
        __block NSUInteger curIndex = [num unsignedIntegerValue];
        [del enumerateIndexesInRange:NSMakeRange(0, curIndex) options:0 usingBlock:^(NSUInteger deleteIndex, BOOL * _Nonnull stop) {
            curIndex--;
        }];
        
        [insert enumerateIndexesUsingBlock:^(NSUInteger insertIndex, BOOL * _Nonnull stop) {
            if (insertIndex <= curIndex)
                curIndex++;
            
            if (insertIndex > curIndex)
                *stop = YES;
        }];
        [rv addObject:[NSNumber numberWithUnsignedInteger:curIndex]];
    }
    return rv;
}

-(void) updateTracks:(RLMResults *)results change:(RLMCollectionChange *)change
{
    if(change != nil)
    {
        NSArray<NSNumber *> *deletions = change.deletions;
        NSMutableIndexSet *deletionsSet = [NSMutableIndexSet indexSet];
        for(NSInteger i = deletions.count-1; i>=0; i--)
        {
            [deletionsSet addIndex:deletions[i].unsignedIntegerValue];
        }
        [_tracks removeObjectsAtIndexes:deletionsSet];
        
        NSMutableIndexSet *insertionsSet = [NSMutableIndexSet indexSet];
        NSMutableArray *insertedTracks = [NSMutableArray arrayWithCapacity:change.insertions.count];
        for(NSNumber *idx in change.insertions)
        {
            ModelTrack *track = [results objectAtIndex:idx.unsignedIntegerValue];
            [insertedTracks addObject:track.uuid];
            [insertionsSet addIndex:idx.unsignedIntegerValue];
        }
        [_tracks insertObjects:insertedTracks atIndexes:insertionsSet];
        
        NSArray *updatedChanges = [self updateModify:change.modifications withDelete:deletionsSet andInsert:insertionsSet];
        for(NSNumber *idx in updatedChanges)
        {
            ModelTrack *track = [results objectAtIndex:idx.unsignedIntegerValue];
            NSString *trackUUID = [_tracks objectAtIndex:idx.unsignedIntegerValue];
            NSAssert([trackUUID isEqualToString:track.uuid], @"Primary key changed.");
        }
        NSAssert(results.count == _tracks.count, @"Counts should be same");
        for(NSUInteger i = 0; i< results.count; ++i)
        {
            ModelTrack *track = [results objectAtIndex:i];
            NSString *uuid = [_tracks objectAtIndex:i];
            NSAssert([track.uuid isEqualToString:uuid], @"Track %@ should be equal to our %@", track, uuid);
        }
    }else
    {
        _tracks = [[NSMutableArray alloc] initWithCapacity:results.count];
        for(ModelTrack *track in results)
        {
            [_tracks addObject:track.uuid];
        }
    }
}

-(void) uploadData:(RLMSyncUser *)user
{
    if(user == nil)
    {
        NSLog(@"Failed to connect");
        return;
    }
    NSError *error = nil;
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.syncConfiguration = [[RLMSyncConfiguration alloc] initWithUser:user realmURL:[NSURL URLWithString:@"realms://sync.galileo-app.com:10443/~/galileo"]];
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    
    [ModelFolder createInRealm:realm uuid:@"DA40B286-010C-4F1E-B5BC-3626768A8A75" name:@"А" date:1489414245242];
    [ModelFolder createInRealm:realm uuid:@"725AD987-16FC-4EFF-99AD-D3288D811D6E" name:@"Б" date:1489414248354];
    [ModelFolder createInRealm:realm uuid:@"3B4A88A7-D074-4EC5-B5A1-58D6A8D5CCC5" name:@"В" date:1489414250964];
    [ModelFolder createInRealm:realm uuid:@"32B22590-8396-4651-AE4C-E3D815965CAD" name:@"Д" date:1489414253751];
    [ModelFolder createInRealm:realm uuid:@"176EC8C1-5DEE-477A-9364-261349BAD466" name:@"Е" date:1489414284514];

    [ModelBookmark createInRealm:realm uuid:@"175746D0-8E9A-489C-A28A-4D22CA34ACB8" name:@"1" date:1489414253751 folderUUID:@"32B22590-8396-4651-AE4C-E3D815965CAD" lon:-122.0323803539067 lat:37.33815594755777 mapZoom:15.86782636410887];
    [ModelBookmark createInRealm:realm uuid:@"3FAD440E-6FF8-4496-BB72-24C540B1005A" name:@"2" date:1489414255399 folderUUID:@"32B22590-8396-4651-AE4C-E3D815965CAD" lon:-122.0354374858729 lat:37.33776330579295 mapZoom:15.86782636410887];
    [ModelBookmark createInRealm:realm uuid:@"D2F197E2-456E-474E-AA09-6690DE46EF26" name:@"3" date:1489414258088 folderUUID:@"32B22590-8396-4651-AE4C-E3D815965CAD" lon:-122.0314632143168 lat:37.33585615945248 mapZoom:15.86782636410887];
    [ModelBookmark createInRealm:realm uuid:@"A3323A82-CEBD-478C-8D43-4418C08B9DC5" name:@"4" date:1489414284514 folderUUID:@"176EC8C1-5DEE-477A-9364-261349BAD466" lon:-122.0309693699222 lat:37.34064263106843 mapZoom:15.86782636410887];
    [ModelBookmark createInRealm:realm uuid:@"8EA5AC2A-C62D-4058-AAE9-2F69051F3D12" name:@"5" date:1489414298703 folderUUID:@"176EC8C1-5DEE-477A-9364-261349BAD466" lon:-122.0340265018885 lat:37.33585615945248 mapZoom:15.86782636410887];
    
    [ModelTrack createInRealm:realm uuid:@"F670C216-6BB7-49F1-B4EA-8BDC68CDE6C2" name:@"По городу" date:1489416782565 folderUUID:@"176EC8C1-5DEE-477A-9364-261349BAD466"];
    
    [realm commitWriteTransaction];
    
    __weak ViewController *wthis = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visible == true"];
    RLMResults *tracks = [[ModelTrack objectsInRealm:realm withPredicate:predicate] sortedResultsUsingKeyPath:@"uuid" ascending:NO];
    _token = [tracks addNotificationBlock:^(RLMResults *results, RLMCollectionChange *change, NSError *error){
        if(error == nil)
        {
            NSLog(@"tracksNotification results: %d insert: %d delete: %d modify: %d", (int)results.count, (int)change.insertions.count, (int)change.deletions.count, (int)change.modifications.count);
            [wthis updateTracks:results change:change];
        }else
        {
            NSLog(@"Error fetching tracks: %@", error.localizedDescription);
        }
    }];
}

-(IBAction) prmaryKeyChangeTest:(id)sender
{
    //Cleanup
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    for (NSString *path in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil])
    {
        NSString *fullPath = [documentsDir stringByAppendingPathComponent:path];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
    
    //Auth
    RLMSyncCredentials *creds = [RLMSyncCredentials credentialsWithUsername:@"test" password:@"test" register:NO];
    [RLMSyncUser logInWithCredentials:creds authServerURL:[NSURL URLWithString:@"https://sync.galileo-app.com:10443"] onCompletion:^(RLMSyncUser *user, NSError *error) {
        [self performSelectorOnMainThread:@selector(uploadData:) withObject:user waitUntilDone:NO];
    }];
}

@end
