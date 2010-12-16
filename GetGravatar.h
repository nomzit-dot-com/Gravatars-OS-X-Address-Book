//
//  GetGravatar.h
//  GetGravatar
//
//  Created by Philip Willoughby on 2009-12-15.
//  Copyright Philip Willoughby 2009. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "GetGravatar.h"

@interface GetGravatar : NSObject
{
}

// Returns the property this action is for.
- (NSString *)actionProperty;

// Returns the title for this action. The current person is passed in as person.
// If the actionProperty is a multiValue type, identifier will contain the identifier
// of the item the user rolled over. If the actionProperty is not a multiValue type
// identifier will be nil.
- (NSString *)titleForPerson:(ABPerson *)person identifier:(NSString *)identifier;

// This method is called when the user selects your action. As above, this method
// is passed information about the data item rolled over.
- (void)performActionForPerson:(ABPerson *)person identifier:(NSString *)identifier;

// Optional. Your action will always be enabled in the absence of this method. As
// above, this method is passed information about the data item rolled over.
- (BOOL)shouldEnableActionForPerson:(ABPerson *)person identifier:(NSString *)identifier;

@end

