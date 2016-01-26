//
//  Utils.h
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (Utils *)sharedUtils;

- (void)showGenericAlertWithMessage:(NSString *)message
                   inViewController:(id)targetViewController;
@end
