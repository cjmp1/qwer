#include <iostream>
#define MAX_ROBOT 100
#define MAX_OBJECT 100
using namespace std;

enum surface{
    LEFT,
    RIGHT,
    FAR,
    CENTER
};
enum robots{
    PANDA
};
enum obj{
    Red_block,
    Green_block,
    Blue_block,
    Yellow_block,
    None,
};

struct robot{
    surface pos;
    bool gripper_state;
    obj picked;
    robot(surface p){
        pos = p;
        gripper_state = false;
        picked = None;
    }
};
struct object{
    surface pos;
    bool is_top;
    obj under;
    object(surface p){
        pos = p;
        is_top = true;
        under = None;
    }
};

robot *robot_list[MAX_ROBOT];
object *object_list[MAX_OBJECT];

bool has_obj(robots x, obj y){
    return robot_list[x]->picked == y;
}
bool is_free(robots x){
    return robot_list[x]->picked == None;
}
bool on_surface_obj(obj x, surface y){
    return object_list[x]->pos == y;
}
bool on_surface_robot(robots x, surface y){
    return robot_list[x]->pos == y;
}
bool top_is_clear(obj x){
    return object_list[x]->is_top;
}
bool stacked(obj x, obj y){
    return object_list[x]->under == y;
}
bool is_top_obj(obj x, surface y){
    return (object_list[x]->pos == y && object_list[x]->is_top);
}

bool pre_move_robot(robots x, surface from, surface to);
bool pre_pick(robots x, obj o, surface s);
bool pre_drop(robots x, obj o, surface s);

void move_robot(robots x, surface from, surface to);
void pick(robots x, obj o, surface s);
void drop(robots x, obj o, surface s);

bool is_complete(){
    return (is_free(PANDA) && 
    on_surface_obj(Red_block, LEFT) && 
    on_surface_obj(Green_block, LEFT) && 
    on_surface_obj(Blue_block, LEFT) && 
    on_surface_obj(Yellow_block, LEFT) && 
    on_surface_robot(PANDA, CENTER));
}

int main(){

    // initial_state define

    robot *panda = new robot(CENTER);
    object *red_block = new object(LEFT);
    object *green_block = new object(LEFT);
    object *blue_block = new object(LEFT);
    object *yellow_block = new object(LEFT);

    robot_list[PANDA] = panda;
    object_list[Red_block] = red_block;
    object_list[Green_block] = green_block;
    object_list[Blue_block] = blue_block;
    object_list[Yellow_block] = yellow_block;

    // goal_predicates define

    return 0;
}

bool pre_move_robot(robots x, surface from, surface to){
    return (on_surface_robot(x, from));
}
bool pre_pick(robots x, obj o, surface s){
    return (on_surface_obj(o, s) && on_surface_robot(x, s) && top_is_clear(o) && is_top_obj(o, s) && is_free(x));
}
bool pre_drop(robots x, obj o, surface s){
    return ((! is_free(x)) && on_surface_robot(x,s) && has_obj(x, o));
}


void move_robot(robots x, surface from, surface to){
    robot_list[x]->pos = to;
    if(robot_list[x]->picked != None){
        object_list[robot_list[x]->picked]->pos = to;
    }
}
void pick(robots x, obj o, surface s){
    robot_list[x]->gripper_state = true;
    robot_list[x]->picked = o;
    object_list[o]->is_top = false;
    if(object_list[o]->under != None){
        object_list[object_list[o]->under]->is_top = true;
        object_list[o]->under = None;
    }
}
void drop(robots x, obj o, surface s){
    robot_list[x]->gripper_state = false;
    robot_list[x]->picked = None;
    for(int i = 0; i <= MAX_OBJECT; i++){
        if(object_list[i]->pos == s && object_list[i]->is_top){
            object_list[i]->is_top = false;
            object_list[o]->under = obj(i);
            break;
        }
    }
    object_list[o]->is_top = true;
}