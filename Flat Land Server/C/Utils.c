//
//  Utils.c
//  Flat Land Server
//
//  Created by Zackory Cramer on 7/18/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//

#include "Utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct PlayerInitPacket* getInitPacket(char* name, uint8_t id, uint8_t config){
    struct PlayerInitPacket *pack = malloc(sizeof(struct PlayerInitPacket));
    pack->opcode = Init_opcode;
    pack->id = id;
    pack->config = config;
    strcpy((pack->name), name);
    return pack;
}

struct PlayerControlPacket* getControlPacket(float dx, float dy, float angle){
    struct PlayerControlPacket *pack = malloc(sizeof(struct PlayerControlPacket));
    pack->opcode = Update_opcode;
    pack->angle = angle;
    pack->dx = dx;
    pack->dy = dy;
    return pack;
}

struct PlayerConnectionCheckPacket* getCheckPacket(int32_t hash){
    struct PlayerConnectionCheckPacket *pack = malloc(sizeof(struct PlayerConnectionCheckPacket));
    pack->opcode = Check_opcode;
    pack->hash = hash;
    return pack;
}

struct ServerOpPacket* getServerOpcodePacket(uint8_t code){
    struct ServerOpPacket *pack = malloc(sizeof(struct ServerOpPacket));
    pack->opcode = Server_op_opcode;
    pack->server_code = code;
    return pack;
}

char* getPlayerName(struct PlayerInitPacket packet){
    char* ptr = malloc(MAX_NAME_LEN);
    strcpy(ptr, packet.name);
    return ptr;
}
