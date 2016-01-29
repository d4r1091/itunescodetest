//
//  CodetestDarioTests.m
//  CodetestDarioTests
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkManager.h"

@interface CodetestDarioTests : XCTestCase

@end

@implementation CodetestDarioTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownloadFromItunes {
    // TODO: check again why fails, probably some expectation settings
    XCTestExpectation *expectation = [self expectationWithDescription:@"getItunesMatchedResults"];
    
    [[NetworkManager sharedManager] getItunesMatchedResultsWithQueryString:@"Frank%2BSinatra"
                                                       andComplentionBlock:^(NSArray *foundResults, NSError *error) {
                                                           if (!error) {
                                                               [expectation fulfill];
                                                           } else {
                                                               XCTFail(@"Failure");
                                                               [expectation fulfill];
                                                           }
                                                       }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
