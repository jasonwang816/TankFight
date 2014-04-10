//
//  BaseNetworkInterface.h
//  Consumer_iPhone
//
//  Created by Richard Rusli on 2013-05-02.
//  Copyright (c) 2013 Trader Media Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BETA_SERVER

typedef enum {
    ERROR_DEACTIVATE,
    ERROR_NOTACTIVATE,
    ERROR_MIGRATE,
    ERROR_UPDATE_APP
} serverLoginError;

@interface BaseNetworkInterface : NSObject <UIAlertViewDelegate>
{
    NSOperationQueue *otherQueue;
    NSOperation *fetchTokenOperation;
    NSString *AT_APP_ID;
    NSString *encryptionKey;
    NSDate *tokenDate;
    NSUInteger ssoAccessTokenIssueVersion;
    NSString *serverBaseURL;
    NSString *previousToken;
}

@property (nonatomic, retain) NSString *token;

+ (long long)tick;
+ (NSData*)iv;
- (NSDictionary*)prepareGetTokenInputData:(BOOL)isForSSO;
- (NSString*)encryptZBase32Dict:(NSDictionary*)input;
+ (NSString*)errorForResult:(NSDictionary*)result error:(NSError*)error;
- (NSString*)prepareToken;
- (BOOL)hasValidToken;
- (void)addTokenOperationForOperation:(NSOperation*)op;
- (id __autoreleasing)sendJsonRequest:(NSString*)requestURL data:(NSDictionary *)inputData error:(NSError **)error;
- (void)genNewTokenForSSO;
@end

@interface NSData (AESAdditions)
- (NSString*)zbase32String;
- (NSData*)AES128EncryptWithIV:(NSData*)iv encrypKey:(NSString*)encryptionKey;
- (NSData*)AES128DecryptWithIV:(NSData*)iv encrypKey:(NSString*)encryptionKey;
@end


@interface NSString (zbase32)
- (NSData*)zbase32EncryptedData;
- (NSString*)localizedErrorMessage;
- (NSString*)formalizedFieldName;
@end
