//
//  AppDelegate.m
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Core Data additional function
//Coredata deleteAll
- (void)deleteAllEntities:(NSString *)nameEntity {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }

    error = nil;
    [context save:&error];
}

//fetch core data function
//return array
- (NSArray *)fetchArrayFromCoreData:(NSString *)Entity{
    NSArray *results; //data get in here
    NSManagedObjectContext *context = self.persistentContainer.viewContext; //get context
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Entity]; //create request
    [request setReturnsObjectsAsFaults:NO]; //data not return to fault
    NSError *error = nil; //error handler
    results = [context executeFetchRequest:request error:&error]; // get data into result
    if (!results) { //show error if error
        NSLog(@"Error fetching entity objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    else{
        //dont know what to do LOL
        //NSLog(@"%@", results);
    }
    return results;
}

#pragma mark other convinient functions

//get specific string in string (input :lot of character string :delete from head to here :delete from here to end
//return new string trimmed
- (NSMutableString *)getStringFromString:(NSMutableString *)string :(NSString *)from :(NSString *)to{
    NSMutableString *result;
    NSRange searchFromRange = [string rangeOfString:from];
    NSRange searchToRange = [string rangeOfString:to];
    result = [NSMutableString stringWithFormat:@"%@", [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)]];
    return result;
}

@end
