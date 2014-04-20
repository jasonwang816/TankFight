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
    [encoder encodeInteger:self.team forKey:@"team"];
    [encoder encodeFloat:self.health forKey:@"health"];
    [encoder encodeCGPoint:self.position forKey:@"position"];
    [encoder encodeDouble:self.rotation forKey:@"rotation"];
    [encoder encodeObject:self.specLevel forKey:@"specLevel"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.health = [decoder decodeFloatForKey:@"health"];
        self.team = [decoder decodeIntegerForKey:@"team"];
        self.position = [decoder decodeCGPointForKey:@"position"];
        self.rotation = [decoder decodeDoubleForKey:@"rotation"];
        self.specLevel = [decoder decodeObjectForKey:@"specLevel"];

    }
    return self;
}

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *)name AndTeam:(NSInteger)team
{
    self = [super init];
    
    if (self){
        self.name = name;
        self.team = team;
        self.health = 100;
        self.position = pos;
        self.rotation = angle;
        self.specLevel = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
