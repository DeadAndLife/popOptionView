//
//  AppDelegate.h
//  popOptionViewDemo
//
//  Created by 张氏集团 Inc on 20/1/6.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

