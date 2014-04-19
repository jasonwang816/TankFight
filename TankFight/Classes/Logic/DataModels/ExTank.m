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
    [encoder encodeFloat:self.attackLevel forKey:@"attackLevel"];
    [encoder encodeFloat:self.defenceLevel forKey:@"defenceLevel"];
    [encoder encodeFloat:self.speedLevel forKey:@"speedLevel"];
    [encoder encodeFloat:self.bulletLevel forKey:@"bulletLevel"];
    [encoder encodeFloat:self.radarLevel forKey:@"radarLevel"];
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
        self.attackLevel = [decoder decodeFloatForKey:@"attackLevel"];
        self.defenceLevel = [decoder decodeFloatForKey:@"defenceLevel"];
        self.speedLevel = [decoder decodeFloatForKey:@"speedLevel"];
        self.bulletLevel = [decoder decodeFloatForKey:@"bulletLevel"];
        self.radarLevel = [decoder decodeFloatForKey:@"radarLevel"];
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
        self.attackLevel = 1;
        self.defenceLevel = 1;
        self.speedLevel = 1;
        self.bulletLevel = 1;
        self.radarLevel = 1;
        self.colorID = 0;
    }
    
    return self;
}

@end
