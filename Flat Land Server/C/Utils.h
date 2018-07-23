//
//  Utils.h
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/18/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#include <stdio.h>

#define Init_opcode 0
#define Check_opcode 1
#define Update_opcode 2
#define MAX_NAME_LEN 6

enum ControlDirection{
    UP,
    DOWN,
    RIGHT,
    LEFT,
};

struct PlayerInitPacket{
    int8_t opcode;
    char name[6];
    int8_t id;
    int8_t config;
};

struct PlayerConnectionCheckPacket{
    int8_t opcode;
    int32_t hash;
};

struct PlayerControlPacket {
    int8_t opcode;
    enum ControlDirection direction;
    float angle;
};

typedef union{
    struct PlayerInitPacket initPacket;
    struct PlayerControlPacket controlPacket;
    struct PlayerConnectionCheckPacket connectionCheckPacket;
}PlayerPacket;

char* getPlayerName(struct PlayerInitPacket packet);
struct PlayerInitPacket* getInitPacket(char* name, int8_t id, int8_t config);
struct PlayerConnectionCheckPacket* getCheckPacket(int32_t hash);
struct PlayerControlPacket* getControlPacket(float angle,enum ControlDirection direction);

#endif /* Utils_h */
