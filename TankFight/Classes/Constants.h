//
//  Constants.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

//static const int NewtonLetterCount = 7;
//static const NSString *NewtonLetter[] = { @"c", @"o", @"c", @"o", @"s", @"2", @"d" };
//static const CGPoint NewtonLetterPosition[] = {{-2,0}, {-1,0}, {0,0}, {1,0}, {2,0}, {1.8,-2}, {2.8,-2}};
//static const BOOL NewtonLetterHasRope[] = {YES, YES, YES, YES, YES, NO, NO};
//
//static const float NewtonBackgroundLuminance = 0.1f;
//
//static const CGPoint NewtonButtonBackPosition = (CGPoint){0.10f, 0.90f};
//static const CGPoint NewtonButtonFirePosition = (CGPoint){0.90f, 0.90f};
//static const CGPoint NewtonButtonResetPosition = (CGPoint){0.90f, 0.80f};
//static const CGPoint NewtonLightPosition = (CGPoint){0.75f, 0.35f};
//
//static const CGPoint NewtonGravity = (CGPoint){0, -980.665};
//static const float NewtonOutlineFriction = 1.0f;
//static const float NewtonOutlineElasticity = 0.5f;
//static const float NewtonSphereFriction = 0.5;
//static const float NewtonSphereElasticity = 1.0;
//
//static const float NewtonSphereNormalMass = 1;
//static const float NewtonSphereSwingingMass = 0.25;
//static const float NewtonSphereMovingMass = 100;
//static const float NewtonRopeNormalMass = 1;
//
//static const BOOL NewtonRealRope = NO;
//static const int NewtonRopeSegments = 6;
//
//static const float NewtonParticleScale = 0.8f;
//static const float NewtonParticleDisplacement = 0.35f;
//
//// Added because the image of the sprite doesnt fill the image 100%
//// A transparent blended margin is kept, to make the image looks good then it rotates.
//static const float NewtonSphereMargin = 3;
//static const float NewtonSphereSpacing = 3;
//

static NSString * CT_TankBody = @"Default";
static NSString * CT_FieldBody = @"Default";
static NSString * CT_RadarBody = @"Default";
static NSString * CT_BulletBody = @"Default";


//static NSString * CT_TankBody = @"TankBody";
//static NSString * CT_FieldBody = @"FieldBody";
//static NSString * CT_RadarBody = @"RadarBody";
//static NSString * CT_BulletBody = @"BulletBody";

static const float CONST_BODY_WIDTH = 68.0f;
static const float CONST_BODY_HEIGHT = 37.0f;
static const float CONST_CANNON_WIDTH = 25.0f;
static const float CONST_CANNON_HEIGHT = 49.0f;
static const float CONST_BULLET_WIDTH = 6.0f;
static const float CONST_BULLET_HEIGHT = 12.0f;
static const float CONST_RADAR_WIDTH = 11.0f;
static const float CONST_RADAR_HEIGHT = 14.0f;

//typedef enum {
//    UserObjectType_Field,
//    UserObjectType_Tank,
//    UserObjectType_Radar,
//    UserObjectType_Bullet
//} CCUserObjectType;

typedef enum {
    CCUnitType_Field = 0,
    CCUnitType_Tank,
    CCUnitType_Cannon,
    CCUnitType_RadarLaser,
//    CCUnitType_Radar,
    CCUnitType_Bullet
} CCUnitType;
