//
//  ExGameInfo.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExGameInfo.h"

@implementation ExGameInfo

-(void)encodeWithCoder:(NSCoder *)encoder{

    [encoder encodeObject:self.field forKey:@"field"];
    [encoder encodeObject:self.players forKey:@"players"];

    //TODO:other properties:

}

//[encoder en
//self. = [decoder de
//:self. f
//F
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {

        self.field = [decoder decodeObjectForKey:@"field"];
        self.players = [decoder decodeObjectForKey:@"players"];
        
    }
    return self;
}


- (id)init
{
    self = [super init];
    
    if (self){
        _players = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
