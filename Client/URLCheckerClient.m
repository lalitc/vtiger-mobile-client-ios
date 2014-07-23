//
//  URLCheckerClient.m
//  VTFunctionalitiesApp
//
//  Created by Giovanni on 1/16/14.
//  Copyright (c) 2014 gixWorks. All rights reserved.
//

#import "URLCheckerClient.h"

static BOOL user_wants_to_trust_invalid_certificates = YES;

@interface URLCheckerClient ()
{
    BOOL using_invalid_certificate;
    BOOL requested_client_certificate;
}

@end

@implementation URLCheckerClient

- (void)startTestingReachability
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    [request setHTTPMethod: @"HEAD"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    //Init method should not be called
    return self;
}

- (id)initWithDelegate:(id<URLCheckerClientDelegate>)delegate url:(NSURL *)urlToTest
{
    self = [super init];
    if (self) {
        self.URLCheckerClientDelegate = delegate;
        self.url = urlToTest;
        using_invalid_certificate = NO; //we start without self-signed certificate
        requested_client_certificate = NO; //we assume the server has not (yet) requested client certificate
    }
    return self;
}

#pragma mark - NSURLconnection delegate

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
#if DEBUG
    NSLog(@"AuthenticationMethod: %@", protectionSpace.authenticationMethod);
#endif
    return ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust ] ||
            [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]);
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        // Verify certificate:
        SecTrustResultType trustResult;
        OSStatus status = SecTrustEvaluate(challenge.protectionSpace.serverTrust, &trustResult);
        BOOL trusted = (status == errSecSuccess) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
        
        if (trusted) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                 forAuthenticationChallenge:challenge];
            using_invalid_certificate = NO;
        } else {
            if (user_wants_to_trust_invalid_certificates) { //always defaulted to YES //GM
                using_invalid_certificate = YES;
                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                     forAuthenticationChallenge:challenge];
            } else {
                [challenge.sender cancelAuthenticationChallenge:challenge];
            }
        }
    }
    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
        
        requested_client_certificate = YES;
        
        //Client Certificate
        NSLog(@"Client Certificate requested");
        
        if (_certificateData == nil) {
            //This will fail
            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
        }
        else{
            //we have a identity reference to work with
            NSLog(@"Here's the data: %@", _certificateData);
            SecIdentityRef myIdentity = identityForPersistentRef((__bridge CFDataRef)(_certificateData));
            
            //New initialization
            SecCertificateRef myCertificate;

            SecIdentityCopyCertificate(myIdentity, &myCertificate);
            const void *certs[] = { myCertificate };
            CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
            NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistenceNone];
            //
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];

        }

    }
    else {
        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}


SecIdentityRef identityForPersistentRef(CFDataRef persistent_ref)
{
    CFTypeRef   identity_ref     = NULL;
    const void *keys[] =   { kSecClass, kSecReturnRef,  kSecValuePersistentRef };
    const void *values[] = { kSecClassIdentity, kCFBooleanTrue, persistent_ref };
    CFDictionaryRef dict = CFDictionaryCreate(NULL, keys, values,
                                              3, NULL, NULL);
    SecItemCopyMatching(dict, &identity_ref);
    
    if (dict)
        CFRelease(dict);
    
    return (SecIdentityRef)identity_ref;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    connection = nil;
    DDLogDebug(@"%@ %@ connection failed with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error description]);
    [self.URLCheckerClientDelegate urlCheckerDidFinishWithError:[error localizedDescription] url:self.url responseCode:-1 invalid_certificate:using_invalid_certificate requestedClientCertificate:requested_client_certificate];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    if (httpResponse.statusCode >= 500) {
        //Something is wrong with the url provided by the server
        DDLogDebug(@"%@ %@ The server is not available (Response code %ld)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSString *err = [NSString stringWithFormat:@"The server is not available (Response code %ld)", (long)httpResponse.statusCode];
        [self.URLCheckerClientDelegate urlCheckerDidFinishWithError:err url:_url responseCode:httpResponse.statusCode invalid_certificate:using_invalid_certificate requestedClientCertificate:requested_client_certificate];
    }
    else if (httpResponse.statusCode == 403)
    {
        //Unauthorized (could be due to client certificate)
        NSString *err = [NSString stringWithFormat:@"Unauthorized (Response code %ld)", (long)httpResponse.statusCode];
        [self.URLCheckerClientDelegate urlCheckerDidFinishWithError:err url:_url responseCode:httpResponse.statusCode invalid_certificate:using_invalid_certificate requestedClientCertificate:requested_client_certificate];
    }
    else if(httpResponse.statusCode == 200)
    {
        //Everything OK - the best outcome
        [self.URLCheckerClientDelegate urlCheckerDidFinishWithError:nil url:_url responseCode:httpResponse.statusCode invalid_certificate:using_invalid_certificate requestedClientCertificate:requested_client_certificate];
    }
    else
    {
        //any other error
        DDLogDebug(@"%@ %@ The server is not available (Response code %ld)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSString *err = [NSString stringWithFormat:@"The server is not available (Response code %ld)", (long)httpResponse.statusCode];
        [self.URLCheckerClientDelegate urlCheckerDidFinishWithError:err url:_url responseCode:httpResponse.statusCode invalid_certificate:using_invalid_certificate requestedClientCertificate:requested_client_certificate];
    }
}


@end
