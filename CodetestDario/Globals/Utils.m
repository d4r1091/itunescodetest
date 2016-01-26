//
//  Utils.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils

+ (Utils *)sharedUtils {
    static Utils *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)showGenericAlertWithMessage:(NSString *)message
                   inViewController:(id)targetViewController {
    
    NSString *appName = [[NSBundle bundleWithIdentifier:@"BundleIdentifier"]
                         objectForInfoDictionaryKey:(id)kCFBundleExecutableKey];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if ([targetViewController isKindOfClass:[UIViewController class]]) {
                                 // TODO: find a way to avoid Snapshotting a view that has not been rendered results in an empty snapshot...
                                 [targetViewController dismissViewControllerAnimated:YES completion:^{
                                 }];
                             }
                         }];
    [alert addAction:ok];
    
    if ([targetViewController isKindOfClass:[UIViewController class]]) {
        // TODO: find a way to avoid Snapshotting a view that has not been rendered results in an empty snapshot...
        [targetViewController presentViewController:alert animated:YES completion:^{
        }];
    }
}


@end
