//
//  NetworkManager.h
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedManager;

- (void)getItunesMatchedResultsWithQueryString:(NSString *)querystring
                          andComplentionBlock: (void (^)(NSArray *foundResults, NSError *error)) complentionBlock;

- (void)loadImageWithUrl:(NSString *)urlString andComplentionBlock:(void (^)(NSData *imageData))imageDataProcessed;

@end
