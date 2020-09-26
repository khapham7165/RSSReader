//
//  AppDelegate.h
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (void)deleteAllEntities:(NSString *)nameEntity;
- (NSArray *)fetchArrayFromCoreData:(NSString *)Entity;
- (NSMutableString *)getStringFromString:(NSMutableString *)string :(NSString *)from :(NSString *)to;

@end
