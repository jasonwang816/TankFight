//
//  BaseNetworkInterface.m
//  Consumer_iPhone
//
//  Created by Richard Rusli on 2013-05-02.
//  Copyright (c) 2013 Trader Media Group. All rights reserved.
//

#import "BaseNetworkInterface.h"
#import <CommonCrypto/CommonCryptor.h>
#import "JSONKit.h"
//#import "TMGNetworkActivityIndicator.h"
//#import "GoogleSSOViewController.h"
//#import "YahooSOOViewController.h"
//#import "CachedData.h"
//#import "Consumer_iPadAppDelegate.h"
//#import "Consumer_iPhoneAppDelegate.h"
//#import "CarProofDefaultsManager.h"

#define ZBASE32_STRING @"ybndrfg8ejkmcpqxot1uwisza345h769"
NSString *deviceName;

@implementation BaseNetworkInterface

+ (long long)tick
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDate *now = [NSDate date];
    long long tick = [now timeIntervalSinceDate:date] * 10000000;
    return tick;
}

+ (NSData*)iv
{
    NSMutableData *iv = [NSMutableData dataWithCapacity:16];
    for (int i = 0; i < 4; i ++) {
        uint32_t random = arc4random();
        [iv appendBytes:&random length:4];
    }
    return [NSData dataWithData:iv];
}

- (NSString*)prepareToken
{
    NSString *tickPlusSlash = [NSString stringWithFormat:@"%llu/%@", [BaseNetworkInterface tick], self.token];
    NSData *dataBeforeEncryption = [tickPlusSlash dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [BaseNetworkInterface iv];
    NSData *edata = [dataBeforeEncryption AES128EncryptWithIV:iv encrypKey:encryptionKey];
    NSMutableData *mdata = [NSMutableData dataWithData:iv];
    [mdata appendData:edata];
    NSString *base32 = [mdata zbase32String];
    
    return [AT_APP_ID stringByAppendingFormat:@"/%@",base32];
}

- (NSString*)encryptZBase32Dict:(NSDictionary*)input
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:input options:0 error:nil];
    NSMutableData *iv = [[BaseNetworkInterface iv] mutableCopy];
    NSData *data = [jsonData AES128EncryptWithIV:iv encrypKey:encryptionKey];
    [iv appendData:data];
    NSString *base32 = [iv zbase32String];
    return base32;
}

//- (NSDictionary*)prepareGetTokenInputData:(BOOL)isForSSO
//{
//    long long tick = [BaseNetworkInterface tick];
//    SSOUser *ssoUser = [SSOUser sharedInstance];
//    NSDictionary *input = @{@"Collection":@{@"appid":AT_APP_ID, @"tick":@((long long)tick)}};
//    BOOL flag = NO;
//    if (isForSSO || ssoUser.hasBeenAuthenticatedByServer) {
//        switch ([SSOUser sharedInstance].loginStatus) {
//            case AT_FBUSER:
//                NSLog(@"Getting AT token for FB user, access token: %@", [SSOUser sharedInstance].accessToken);
//                flag = YES;
//                input = @{@"Collection":@{@"appid":AT_APP_ID, @"tick":@((long long)tick), @"idprd":@"FacebookOAuth2", @"atkn":[SSOUser sharedInstance].accessToken}};
//                break;
//            case AT_GOOUSER:
//                NSLog(@"Getting AT token for Google user, access token: %@", ssoUser.accessToken);
//                flag = YES;
//                input = @{@"Collection":@{@"appid":AT_APP_ID, @"tick":@((long long)tick), @"idprd":@"GoogleOAuth2", @"atkn":ssoUser.accessToken}};
//                break;
//            case AT_YHUSER:
//                NSLog(@"Getting AT token for Yahoo user, access token: %@", ssoUser.accessToken);
//                flag = YES;
//                input = @{@"Collection":@{@"appid":AT_APP_ID, @"tick":@((long long)tick), @"idprd":@"YahooOAuth1", @"atkn":ssoUser.accessToken, @"usrguid":ssoUser.userGuid, @"atknsct":ssoUser.refreshToken1}};
//                break;
//            case AT_ORGANICUSER:
//                if (ssoUser.username && ssoUser.refreshToken2) {
//                    NSLog(@"Getting AT token for organic user");
//                    NSData *userNameData = [ssoUser.username dataUsingEncoding:NSUTF8StringEncoding];
//                    NSData *passwordData = [ssoUser.refreshToken2 dataUsingEncoding:NSUTF8StringEncoding];
//                    input = @{@"Collection":@{@"appid":AT_APP_ID, @"tick":@(tick), @"usr":[userNameData zbase32String], @"pwd":[passwordData zbase32String]}};
//                    flag = YES;
//                    break;
//                } else
//                    NSLog(@"Getting AT token for non SSO user");
//            default:
//                NSLog(@"Getting AT token for non SSO user");
//                break;
//        }
//    }
//    
//    NSString *base32 = [self encryptZBase32Dict:input];
//    NSDictionary *finalData = @{@"appID":AT_APP_ID, @"encryptedSecretKeyMessage":base32, @"submittedSsoUserCredentials":@(flag)};
//    
//    return finalData;
//}
//
//- (void)addTokenOperationForOperation:(NSOperation*)op
//{
//    if (![self hasValidToken]) {
//        if (!fetchTokenOperation) {
//            fetchTokenOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getTokenAsSsoUser:) object:@YES];
//            [otherQueue addOperation:fetchTokenOperation];
//        }
//        [op addDependency:fetchTokenOperation];
//    }
//}

- (NSData*)prepareBodyDataFrom:(NSDictionary*)inputData
{
    NSMutableDictionary *mmap = [inputData mutableCopy];
    if ([mmap objectForKey:@"Token"]) {
        [mmap setObject:[self prepareToken] forKey:@"Token"];
    } else if ([mmap objectForKey:@"token"]) {
        [mmap setObject:[self prepareToken] forKey:@"token"];
    }
    
    NSData *bodyData = nil;
    if (NSClassFromString(@"NSJSONSerialization")) {
        bodyData = [NSJSONSerialization dataWithJSONObject:inputData options:0 error:nil];
    }
    if (!bodyData) {
        NSString *strJson = [inputData JSONString];
        bodyData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return bodyData;
}

+ (id __autoreleasing)dataFromJsonData:(NSData*)data
{
    id __autoreleasing result = nil;
    NSError *error = nil;
    if (NSClassFromString(@"NSJSONSerialization")) {
        result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
#ifdef DEBUG
        if (!result) {
            NSLog(@"json parsing error: %@", [error localizedDescription]);
            if ([error code] == 3840) {
                NSString *debugStr = [[error userInfo] objectForKey:@"NSDebugDescription"];
                NSRange range = [debugStr rangeOfString:@"\\d+" options:NSRegularExpressionSearch];
                if (range.location != NSNotFound) {
                    int strOff = [[debugStr substringWithRange:range] intValue];
                    range.location = MAX(strOff - 100, 0);
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    range.length = MIN(responseString.length - strOff, 100);
                    //NSLog(@"json: %@", [responseString substringWithRange:range]);
                }
            }
        }
#endif
    }
    
    if (!result) {
        result = [data objectFromJSONData];
    }
    
    
    return result;
}

- (id __autoreleasing)sendJsonRequest:(NSString*)requestURL data:(NSDictionary *)inputData error:(NSError **)error
{
    NSURL *url;
    if ([requestURL hasPrefix:@"http"]) url = [NSURL URLWithString:requestURL];
    else {
        url = [NSURL URLWithString:[serverBaseURL stringByAppendingString:requestURL]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self prepareBodyDataFrom:inputData]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%@|%@|%@",deviceName,[[UIDevice currentDevice]systemVersion],[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]] forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:20];
    
    NSURLResponse *res;
    id __autoreleasing result = nil;
//    [[TMGNetworkActivityIndicator sharedInstance] startActivity];
    NSLog(@"start %@", requestURL);
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:error];
    if (!*error) {
        if (data && [data length] > 0)
            result = [BaseNetworkInterface dataFromJsonData:data];
        
        if (!result) {
            *error = [[NSError alloc] initWithDomain:@"ca.autotrader.adSearch" code:5 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"1004", nil)}];
        } else {
            NSString *serverError = [[result valueForKey:@"d"] valueForKey:@"Error"];
            if (serverError && [serverError isKindOfClass:[NSString class]]) {
                if ([self checkErrorMessageForCommonErrorTypes:&serverError]) {
                    if ([requestURL isEqualToString:@"/AuthenticateAppSession"]) {
                        NSLog(@"skip retry for app authentication");
//                        [[TMGNetworkActivityIndicator sharedInstance] stopActivity];
                        return nil;
                    } else {
//                        [self getTokenAsSsoUser:@YES];
                        [request setHTTPBody:[self prepareBodyDataFrom:inputData]];
                        NSLog(@"retry %@", requestURL);
                        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:error];
                        result = [BaseNetworkInterface dataFromJsonData:data];
                    }
                } else if (serverError == nil) {
//                    [[TMGNetworkActivityIndicator sharedInstance] stopActivity];
                    return nil;
                }
            }
        }
    } else {
        NSLog(@"request(%@) failed:%@", requestURL, [*error localizedDescription]);
    }
//    [[TMGNetworkActivityIndicator sharedInstance] stopActivity];
    NSLog(@"end %@", requestURL);
    
    //NSLog(@"request json: %@\r\n  response json: %@\r\n", inputData, result );
    //NSLog(@"request json: %@\r\n", inputData);
    
    return result;
}

// return message to user before relogin
- (BOOL)checkErrorMessageForCommonErrorTypes:(NSString**)error
{
    BOOL retry = NO;
//    if ([*error hasPrefix:@"1000:"]) {
//        static NSString *mutex = @"holding block";
//        NSUInteger oldTokenIssueVersion = ssoAccessTokenIssueVersion;
//        @synchronized(mutex) {
//            if (oldTokenIssueVersion < ssoAccessTokenIssueVersion) return YES;
//            tokenDate = nil;
//            self.token = nil;
//            [MyAppDelegate deleteALLData];
//            
//            [SSOUser sharedInstance].hasBeenAuthenticatedByServer = NO;
//            [[SSOUser sharedInstance] archive];
//            switch ([SSOUser sharedInstance].loginStatus) {
//                case AT_GOOUSER:
//                    retry = [GoogleSSOViewController refreshAccessToken];
//                    if (retry)
//                        ssoAccessTokenIssueVersion ++;
//                    break;
//                    
//                case AT_YHUSER:
//                    retry = [YahooSOOViewController refreshAccessToken];
//                    if (retry)
//                        ssoAccessTokenIssueVersion ++;
//                    break;
//                    
//                case AT_ORGANICUSER:
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MyAppDelegate displaySSOLoginViewController:REGULAR_LOGIN_INSTRUCT];
//                    });
//                    break;
//                    
//                case AT_FBUSER:
//                    [MyAppDelegate refreshFacebookAccessToken];
//                    *error = nil;
//                    retry = NO;
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//    }
    
    return retry;
}

//- (void)getTokenAsSsoUser:(NSNumber*)isForSSO
//{
//    if ([self hasValidToken]) {
//        fetchTokenOperation = nil;
//        return;
//    }
//    
//    NSDictionary *finalData = [self prepareGetTokenInputData:[isForSSO boolValue]];
//    
//    BOOL sendNotification = [isForSSO boolValue];
//    BOOL loginSucess = NO;
//    NSError *error = nil;
//    NSString *strError = nil;
//    NSDictionary *authMap = [self sendJsonRequest:@"/AuthenticateAppSession" data:finalData error:&error];
//    if (!authMap) {
//        NSLog(@"get token fail1(%d): %@", error.code, error.localizedDescription);
//    }
//    else
//    {
//        strError = [authMap valueForKeyPath:@"d.Error"];
//        if (strError && strError == (NSString*)[NSNull null]) strError = nil;
//        if (strError)
//        {
//            NSLog(@"get token fail2: %@", strError);
//            if ([strError hasPrefix:@"1001:"])
//            {
//                // to send activation message when the username is not yet activated
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MyAppDelegate hideHUD];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SSO.Warning.Text", nil) message:[strError localizedErrorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"Button.Label.Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"SSO.ResendActivation.Text", nil), nil];
//                    alertView.tag = ERROR_NOTACTIVATE;
//                    [alertView show];
//                });
//                sendNotification = NO;
//            }
//            else if ([strError hasPrefix:@"1003:"])
//            {
//                // to send activation message when the username is already deactivated
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MyAppDelegate hideHUD];
//                    
//                    tokenDate = nil;
//                    self.token = nil;
//                    [MyAppDelegate deleteALLData];
//                    
//                    [SSOUser sharedInstance].hasBeenAuthenticatedByServer = NO;
//                    [[SSOUser sharedInstance] archive];
//                    UIAlertView *alertView;
//                    if (isIpad)
//                        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SSO.Warning.Text", nil) message:[strError localizedErrorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    else
//                        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SSO.Warning.Text", nil) message:[strError localizedErrorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"Button.Label.Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"SSO.CallUs.Text", nil), nil];
//                    alertView.tag = ERROR_DEACTIVATE;
//                    [alertView show];
//                });
//                sendNotification = NO;
//            }
//            else if ([strError hasPrefix:@"1072:"])
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSString *msg = [strError localizedErrorMessage];
//                    msg = [msg stringByReplacingOccurrencesOfString:@"{0}" withString:@"Apps Store"];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    alert.tag = ERROR_UPDATE_APP;
//                    [alert show];
//                });
//            }
//            else if ([strError hasPrefix:@"10"] && !([strError hasPrefix:@"1000:"] && [SSOUser sharedInstance].loginStatus == AT_ORGANICUSER))
//            {
//                // handle any other error other than access denied
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MyAppDelegate hideHUD];
//                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SSO.Warning.Text", nil) message:[strError localizedErrorMessage] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//                    [[SSOUser sharedInstance] removeUser];
//                    [MyAppDelegate deleteALLData];
//                    
//                });
//                sendNotification = NO;
//            }
//        }
//        else {
//            NSString *tkn = [authMap valueForKeyPath:@"d.Token"];
//            NSData *tknData = [tkn zbase32EncryptedData];
//            NSData *serverIv = [tknData subdataWithRange:NSMakeRange(0, 16)];
//            NSData *dataBeforeDecrypt = [tknData subdataWithRange:NSMakeRange(16, tknData.length - 16)];
//            NSData *decryptData = [dataBeforeDecrypt AES128DecryptWithIV:serverIv encrypKey:encryptionKey];
//            self.token = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
//            
//            if (self.token && [self.token length] > 0) {
//                NSString *username = [authMap valueForKeyPath:@"d.SsoUserName"];
//                NSLog(@"get token %@ for %@ via %@", self.token, username?username:@"non sso user", [self class]);
//                loginSucess = YES;
//                tokenDate = [NSDate date];
//                if (![isForSSO boolValue])
//                    previousToken = self.token;
//                NSString *className = NSStringFromClass(self.class);
//                [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:[className stringByAppendingString:@"_token"]];
//                [[NSUserDefaults standardUserDefaults] setObject:tokenDate forKey:[className stringByAppendingString:@"_tokenDate"]];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                if ([username isKindOfClass:[NSString class]]) {
//                    [[CarProofDefaultsManager sharedInstance] removeAllInfo];
//                    [SSOUser sharedInstance].username = username;
//                    [SSOUser sharedInstance].hasBeenAuthenticatedByServer = YES;
//                    [[SSOUser sharedInstance] archive];
//                    
//                    if ([self isKindOfClass:[CachedData class]]) {
//                        [(CachedData*)self enterSSOState];
//                    }
//                }
//            } else {
//                self.token = nil;
//            }
//        }
//    }
//    
//    fetchTokenOperation = nil;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MyAppDelegate hideHUD];
//        if ([isForSSO boolValue] && loginSucess) {
//            [[CachedData sharedInstance] getSSOUser];
//        }
//        if (sendNotification) {
//            NSDictionary *errorDict = nil;
//            if ([error.localizedDescription length] > 0)
//                errorDict = @{@"Error":error.localizedDescription};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishAuthentication" object:@(loginSucess) userInfo:errorDict];
//#ifdef AT_GA_REQUIRED
//            if ([isForSSO boolValue])
//                [ATTracker trackEvent:isIpad?@"/iPad/SSO Registration":@"/iPhone/SSO Registration" action:@"User sign-in" label:[NSString stringWithFormat:@"User sign-in/%@",[self socialAccountFromLogin]] value:0 withError:NULL];
//#endif
//        }
//    });
//}

//- (NSString*)socialAccountFromLogin
//{
//    switch ([SSOUser sharedInstance].loginStatus) {
//        case AT_FBUSER:
//            return @"Facebook";
//        case AT_GOOUSER:
//            return @"Google";
//        case AT_YHUSER:
//            return @"Yahoo";
//        case AT_ORGANICUSER:
//            return @"Organic";
//        case AT_NON_SSOUSER:
//            return @"Non-SSO";
//        default:
//            return @"Non-SSO";
//    }
//}
//
//- (void)genNewTokenForSSO
//{
//    self.token = nil;
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getTokenAsSsoUser:) object:@(YES)];
//    [otherQueue addOperation:op];
//}

- (BOOL)hasValidToken
{
    BOOL result = self.token && tokenDate && [tokenDate timeIntervalSinceNow] > -60 * 20;
    return result;
}

- (id)init
{
    self  = [super init];
    if (self) {
        NSString *className = NSStringFromClass(self.class);
        tokenDate = [[NSUserDefaults standardUserDefaults] objectForKey:[className stringByAppendingString:@"_tokenDate"]];
        if (tokenDate && ![tokenDate timeIntervalSinceNow] > -60 * 20) {
            self.token = [[NSUserDefaults standardUserDefaults] objectForKey:[className stringByAppendingString:@"_token"]];
        }
        ssoAccessTokenIssueVersion = 0;
    }
    return self;
}

+ (NSString*)errorForResult:(NSDictionary*)result error:(NSError*)error
{
    NSString *strError = nil;
    if (error) strError = [error localizedDescription];
    else {
        strError = [result valueForKeyPath:@"d.Error"];
        if (strError == (NSString*)[NSNull null]) strError = nil;
        else strError = [strError localizedErrorMessage];
    }
    return strError;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
//        case ERROR_DEACTIVATE:
//            if (buttonIndex == 1) {
//                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", NSLocalizedString(@"SSO.CallUs.Phone.Text", nil)]]]) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", NSLocalizedString(@"SSO.CallUs.Phone.Text", nil)]]];
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Advertdetail.Callfailed.Alert.Title", @"") message:NSLocalizedString(@"Advertdetail.Callfailed.Alert.content", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    });
//                }
//            }
//            break;
//            
//        case ERROR_NOTACTIVATE:
//            if (buttonIndex == 1)
//                [[CachedData sharedInstance] sendActivation];
//            break;
//            
//        case ERROR_UPDATE_APP:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/ca/app/autotrader.ca/id368660809?mt=8"]];
//            break;
//            
//        case ERROR_MIGRATE:
//            if (buttonIndex == 0) {
//                //discard local data
//                [MyAppDelegate deleteALLData];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AT_MIGRATED"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            } else {
//                //retry migration
//                [[CachedData sharedInstance] performSelectorInBackground:@selector(doMoveDataToSSO) withObject:nil];
//                [MyAppDelegate showHUD];
//            }
//            break;
            
        default:
            break;
    }
}
@end

@implementation NSData (AESAdditions)

- (NSString*)zbase32String
{
    NSData *mapData = [ZBASE32_STRING dataUsingEncoding:NSASCIIStringEncoding];
    unsigned char *bytes = (unsigned char*)[self bytes];
    NSMutableData *storage = [NSMutableData dataWithCapacity:self.length * 8];
    BOOL *bits = (BOOL*)[storage bytes];
    memset(bits, 0, [self length]);
    int bitIndex = 0;
    for (int i = 0; i < [self length]; i ++ ) {
        int x = bytes[i];
        int y = 128;
        while (true) {
            bits[bitIndex++] = ((x & y) == y);
            if (y == 1) break;
            y /= 2;
        }
    }
    
    int index = 0;
    int value = 0;
    NSMutableData *result = [NSMutableData data];
    for (int i = 0; i < [self length] * 8; i ++) {
        value *= 2;
        if (bits[i]) value ++;
        if (++ index == 5) {
            index = 0;
            [result appendData:[mapData subdataWithRange:NSMakeRange(value, 1)]];
            value = 0;
        }
    }
    
    if (index < 5) {
        value = value << (5 - index);
        [result appendData:[mapData subdataWithRange:NSMakeRange(value, 1)]];
    }
    
    NSString *str = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    return str;
}

- (NSData*)AES128EncryptWithIV:(NSData*)iv encrypKey:(NSString*)encryptionKey
{
    NSData *keyData = [encryptionKey zbase32EncryptedData];
    char *keyPtr = (char*)[keyData bytes];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES128DecryptWithIV:(NSData*)iv encrypKey:(NSString*)encryptionKey
{
    NSData *keyData = [encryptionKey zbase32EncryptedData];
    char *keyPtr = (char*)[keyData bytes];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}
@end

@implementation NSString (zbase32)

- (NSData*)zbase32EncryptedData
{
    NSMutableData *mdata = [NSMutableData data];
    int v = 0;
    unsigned char byte = 0;
    for (int i = 0; i < self.length; i ++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        int value = [ZBASE32_STRING rangeOfString:str].location;
        int x = 16;
        for (int j = 0; j < 5; j ++, v++) {
            byte *= 2;
            if ((value & x) > 0) {
                byte ++;
            }
            x /= 2;
            if (v == 7) {
                v = -1;
                [mdata appendBytes:&byte length:1];
                byte = 0;
            }
        }
        if (v < 0) v = 0;
    }
    
    return [NSData dataWithData:mdata];
}

- (NSString*)localizedErrorMessage
{
    NSString *errorMsg = nil;
    
    // remove xml data at the end
    NSRange range = [self rangeOfString:@"<?xml "];
    if (range.location != NSNotFound) {
        errorMsg = [self substringToIndex:range.location];
    } else {
        errorMsg = [NSString stringWithString:self];
    }
    
    // remove error number
    NSRange colonRange = [errorMsg rangeOfString:@":"];
    if (colonRange.location != NSNotFound) {
        errorMsg = [errorMsg substringFromIndex:colonRange.location + 1];
    }
    
    NSRange delimeterRange = [errorMsg rangeOfString:@"|"];
    if (delimeterRange.location != NSNotFound) {
            errorMsg = [errorMsg substringToIndex:delimeterRange.location];
    };
    
    return errorMsg;
}

- (NSString*)formalizedFieldName
{
    NSMutableString *mstr = [NSMutableString stringWithString:self];
    int nextSpacePosition = 0;
    while (nextSpacePosition != NSNotFound) {
        NSString *s = [mstr substringFromIndex:nextSpacePosition];
        int pos = [s rangeOfString:@" "].location;
        if (pos != NSNotFound) {
            nextSpacePosition += pos + 1;
            NSRange range = NSMakeRange(nextSpacePosition, 1);
            [mstr replaceCharactersInRange:range withString:[[self substringWithRange:range] uppercaseString]];
        } else nextSpacePosition = pos;
    }
    
    return [NSString stringWithString:mstr];
}

@end

//@implementation NSNull (Test)
//
//- (void)countByEnumeratingWithState:(int)state objects:(NSArray*)array count:(int)count
//{
//    NSLog(@"");
//}
//
//@end


