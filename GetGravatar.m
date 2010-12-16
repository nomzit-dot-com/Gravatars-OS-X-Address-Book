//
//  GetGravatar.m
//  GetGravatar
//
//  Created by Philip Willoughby on 2009-12-15.
//  Copyright Philip Willoughby 2009 2010. All rights reserved.
//

#import "GetGravatar.h"
#include <openssl/md5.h>

@implementation GetGravatar

- (NSString *)actionProperty
{
    //NSLog(@"actionProperty");
    return kABEmailProperty;
}

- (NSString *)titleForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"titleForPerson:%p identifier:%@",person,identifier);
    ABMultiValue* values = [person valueForProperty:[self actionProperty]];
    NSString* value = [values valueForIdentifier:identifier];

    return [NSString stringWithFormat:@"Get gravatar for %@", value];    
}

- (void)performActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"performActionForPerson:%p identifier:%@",person,identifier);
    unsigned char emailBytes[1024];
    unsigned char emailMD5[16];
    NSUInteger emailBytesUsed;
    NSRange    emailRange;
    ABMultiValue* values = [person valueForProperty:[self actionProperty]];
    NSString* value = [[values valueForIdentifier:identifier] lowercaseString];
    //NSLog(@"Email address: %@",value);
    emailRange.location = 0;
    emailRange.length = [value length];
    [value getBytes:emailBytes maxLength:sizeof emailBytes usedLength:&emailBytesUsed encoding:NSUTF8StringEncoding options:0 range:emailRange remainingRange:NULL];
    //NSLog(@"Email address in array %.*s",emailBytesUsed,emailBytes);
    MD5(emailBytes, emailBytesUsed, emailMD5);
    
//    NSData*    emailHash;
//    emailHash = [NSData dataWithBytes:emailMD5 length:sizeof emailMD5];
//    NSLog(@"MD5 of email address %@",emailHash);
    
    NSString *URLString = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx%2.2hhx?s=512&r=x&d=404"
                                                    , emailMD5[0], emailMD5[1], emailMD5[2], emailMD5[3]
                                                    , emailMD5[4], emailMD5[5], emailMD5[6], emailMD5[7]
                                                    , emailMD5[8], emailMD5[9], emailMD5[10], emailMD5[11]
                                                    , emailMD5[12], emailMD5[13], emailMD5[14], emailMD5[15]
                          ];

    NSURL *gravatarURL = [NSURL URLWithString:URLString];
    //NSLog(@"Requesting Gravatar from %@",gravatarURL);
    
    NSHTTPURLResponse* gravatarResponse;
    
    NSData* image = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:gravatarURL] returningResponse:&gravatarResponse error:NULL];
    //NSLog(@"Response is %@",gravatarResponse);
    //NSLog(@"Status code is %u",[gravatarResponse statusCode]);
    //NSLog(@"Image data address is %p");
    if (image != nil && ([gravatarResponse statusCode] != 404))
    {
        [person setImageData:image];
    }
}

// Optional. Your action will always be enabled in the absence of this method. As
// above, this method is passed information about the data item rolled over.
- (BOOL)shouldEnableActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"shouldEnableActionForPerson:%p identifier:%@",person,identifier);
    return YES;
}

@end
