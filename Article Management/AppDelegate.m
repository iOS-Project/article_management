//
//  AppDelegate.m
//  Article Management
//
//  Created by Lun Sovathana on 11/27/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "LoginVC.h"
#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface AppDelegate (){

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"http://hrdams.herokuapp.com"];
    dispatch_queue_t background_queue = dispatch_queue_create("com.khmerdev.article_management", 0);
    // Set the blocks
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        // keep in mind this is called on a background thread
//        // and if you are updating the UI it needs to happen
//        // on the main thread, like this:
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"reach");
//            
//        });
//    };
    
    dispatch_async(background_queue, ^{
        reach.unreachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"unreach");
                //[ROOTVIEW presentViewController:rootView animated:YES completion:nil];
                [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"No Internet Connection" duration:5.0 position:CSToastPositionBottom];
                
                
            });
        };
    });
    
    
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
