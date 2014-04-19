//
//  ExTank.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExTank.h"

@implementation ExTank

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.health forKey:@"health"];
    [encoder encodeObject:self.specLevel forKey:@"specLevel"];
    [encoder encodeInteger:self.colorID forKey:@"colorID"];
    
}

//[encoder en
//self. = [decoder de
//:self. f
//F
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.health = [decoder decodeIntegerForKey:@"health"];
        self.specLevel = [decoder decodeObjectForKey:@"specLevel"];
        self.colorID = [decoder decodeIntegerForKey:@"colorID"];

    }
    return self;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self){
        self.name = name;
        self.health = 100;
        self.colorID = 0;
        self.specLevel = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
