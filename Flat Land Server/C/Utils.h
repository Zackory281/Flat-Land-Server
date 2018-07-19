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

#define MAX_NAME_LEN 6

enum ControlDirection{
    UP,
    DOWN,
    RIGHT,
    LEFT,
};

struct PlayerInitPacket{
    int8_t opcode;
    char name[MAX_NAME_LEN];
    int8_t id;
    int8_t config;
};

struct PlayerControlPacket {
    int8_t opcode;
    enum ControlDirection direction;
    float angle;
};

typedef union{
    struct PlayerInitPacket initPacket;
    struct PlayerControlPacket controlPacket;
}PlayerPacket;

char* getPlayerName(struct PlayerInitPacket packet);
int32_t getPlayerId(struct PlayerInitPacket *packet);

#endif /* Utils_h */
