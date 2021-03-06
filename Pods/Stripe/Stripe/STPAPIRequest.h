//
//  STPAPIRequest.h
//  Stripe
//
//  Created by Jack Flintermann on 10/14/15.
//  Copyright © 2015 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPAPIResponseDecodable.h"
@class STPAPIClient;

@interface STPAPIRequest<__covariant ResponseType:id<STPAPIResponseDecodable>> : NSObject

typedef void(^STPAPIResponseBlock)(ResponseType object, NSHTTPURLResponse *response, NSError *error);

+ (NSURLSessionDataTask *)postWithAPIClient:(STPAPIClient *)apiClient
                                   endpoint:(NSString *)endpoint
                                 parameters:(NSDictionary *)parameters
                               deserializer:(ResponseType)deserializer
                                 completion:(STPAPIResponseBlock)completion;

+ (NSURLSessionDataTask *)postWithAPIClient:(STPAPIClient *)apiClient
                                    endpoint:(NSString *)endpoint
                                  parameters:(NSDictionary *)parameters
                               deserializers:(NSArray<ResponseType>*)deserializers
                                  completion:(STPAPIResponseBlock)completion;

+ (NSURLSessionDataTask *)getWithAPIClient:(STPAPIClient *)apiClient
                                  endpoint:(NSString *)endpoint
                                parameters:(NSDictionary *)parameters
                              deserializer:(id<STPAPIResponseDecodable>)deserializer
                                completion:(STPAPIResponseBlock)completion;

+ (void)parseResponse:(NSURLResponse *)response
                body:(NSData *)body
               error:(NSError *)error
       deserializers:(NSArray<id<STPAPIResponseDecodable>>*)deserializers
          completion:(STPAPIResponseBlock)completion;

@end
