//
//  NetworkManager.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"

@interface NetworkManager()

@property (nonatomic, strong) NSString *itunesUrlString;
@property (nonatomic, copy) void (^complentionBlock)(NSArray *, NSError *);

@end

@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    static NetworkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.itunesUrlString = kItunesBaseUrl;
    }
    return self;
}

- (void)getItunesMatchedResultsWithQueryString:(NSString *)querystring
                           andComplentionBlock: (void (^)(NSArray *foundResults, NSError *error)) complentionBlock {
    
    self.complentionBlock = complentionBlock;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.itunesUrlString, querystring ];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:backgroundOperation];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:operationQueue];
    
    __block NetworkManager *_self = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&jsonError];
                                                    if (jsonError) {
                                                        complentionBlock (nil, jsonError);
                                                    } else {
                                                        // FEEDBACK from UKCompany
                                                        // Calling methods on further background threads when it’s already on a background thread in the NSURLSessionDataTask is unneeded.
                                                        // [self performSelectorInBackground:@selector(parseItunesResultWithArrayOfDictionaries:) withObject:responseDictionary[kiTunesRootJson]];
                                                        [_self parseItunesResultWithArrayOfDictionaries:responseDictionary[kiTunesRootJson]];
                                                    }
                                                } else {
                                                    complentionBlock (nil, error);
                                                }
                                            }];
    [task resume];
    
}

-(void)parseItunesResultWithArrayOfDictionaries:(NSArray*)dictionaryArray {
    NSMutableArray *resultDict = [NSMutableArray arrayWithArray:dictionaryArray];
    self.complentionBlock(resultDict, nil);
}

- (void)loadImageWithUrl:(NSString *)urlString andComplentionBlock:(void (^)(NSData *imageData))imageDataProcessed
{
    NSURL *anImageUrl = [NSURL URLWithString:urlString];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:anImageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageDataProcessed(imageData);
        });
    });
}


@end
