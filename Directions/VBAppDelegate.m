//
//  VBAppDelegate.m
//  Directions
//
//  Created by Ariel Rodriguez on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VBAppDelegate.h"
#import "VBMapViewController.h"
#import "VBListViewController.h"
#import "VBSegmentsController.h"
#import "VBReachability.h"

@interface VBAppDelegate ()
- (NSArray *)segmentsViewControllers; 
- (void)checkReachability; 
@end

@implementation VBAppDelegate

@synthesize window = _window;
@synthesize segmentsController;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *w = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; 
    [self setWindow:w]; 

    UINavigationController *navigationController = [[UINavigationController alloc] init]; 
    VBSegmentsController *segments = [[VBSegmentsController alloc] initWithNavigationController:navigationController 
                                                                                viewControllers:[self segmentsViewControllers]];
    [self setSegmentsController:segments]; 
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Map", @"List", nil];
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:titles];
    [sc setSegmentedControlStyle:UISegmentedControlStyleBar]; 
    [sc addTarget:segments
           action:@selector(indexDidChangeForSegmentedControl:)
 forControlEvents:UIControlEventValueChanged]; 
    
    [sc setSelectedSegmentIndex:0]; 
    [segments indexDidChangeForSegmentedControl:sc]; 
    
    [[self window] addSubview:[navigationController view]]; 
    [[self window] makeKeyAndVisible];
    
    [self checkReachability]; 
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkReachability]; 
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray *)segmentsViewControllers {
    VBMapViewController *mapViewController = [[VBMapViewController alloc] initWithNibName:@"VBMapViewController"
                                                                                   bundle:nil]; 
    VBListViewController *listViewController = [[VBListViewController alloc] initWithNibName:@"VBListViewController"
                                                                                      bundle:nil]; 
    return [NSArray arrayWithObjects:mapViewController, listViewController,nil]; 
}

- (void)checkReachability {
    VBReachability *reach = [VBReachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(VBReachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Reachable"); 
        });
    }; 
    reach.unreachableBlock = ^(VBReachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *unreachableAlertView = [[UIAlertView alloc] initWithTitle:@"Unreachable Network"
                                                                           message:@"You have to had a live data connection to use this app" 
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK" 
                                                                 otherButtonTitles:nil]; 
            [unreachableAlertView show]; 
        }); 
    };
    [reach startNotifier];
}

@end
