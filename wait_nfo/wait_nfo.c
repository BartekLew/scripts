#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef unsigned int uint;

#define BUFFER_SIZE 255
struct action{
    time_t start;
    uint   step, total;
    char   title[BUFFER_SIZE];
};

uint get_number_arg( int argc, char **argv );
void get_action_title( struct action *action );
void update_status( struct action action );
char *choose_time_unit( float **samples );

int main( int argc, char **argv ){
    struct action action = (struct action){
        .start = time(NULL),
        .total = get_number_arg( argc, argv )
    };

    for( action.step = 1; action.step <= action.total; action.step++ ){
        get_action_title( &action );
        update_status( action );
    }
    return 0;
}

uint get_number_arg( int argc, char **argv ){
    if( argc != 2 ){
        fprintf( stderr, "[wait_nfo] wrong command line\n ** 1 argument expected.\n" );
        exit(1);
    }

    uint result;
    if( sscanf( argv[1], "%u", &result ) != 1 ){
        fprintf( stderr, "[wait_nfo] wrong argument: %s\n", argv[1] );
        exit(1);
    }

    return result;
}

void get_action_title( struct action *action ){
    char *buffer = action->title;
    while( !fgets( buffer, BUFFER_SIZE, stdin ) );
    buffer[strlen(buffer)-1] = '\0';
}

void update_status( struct action action ){
    printf( "\r%u/%u: %s", action.step, action.total, action.title );
    
    if( action.step > 1 ){
        time_t current = time(NULL);
        float  elapsed = current - action.start,
               per_step = elapsed / action.step,
               estimated_total = per_step * action.total;
        char   *unit;

        unit = choose_time_unit( (float*[]){ &elapsed, &estimated_total, NULL } );
        
        printf( " TIME: %.2f / %.2f %s", elapsed, estimated_total, unit );
    }

    fflush(stdout);
}

struct unit{
    char *name;
    uint multiplier;
};

char *choose_time_unit( float **samples ){
struct unit units[] = { 
    (struct unit){.name = "seconds", .multiplier = 1 },
    (struct unit){.name = "minutes", .multiplier = 60 },
    (struct unit){.name = "hours", .multiplier = 60 },
    (struct unit){.name = "days", .multiplier = 24 },
    (struct unit){.name = "weeks", .multiplier = 7 }
};

    uint i;
    for( i = 0; i < sizeof( units ); i++ ){
        bool reached = false;
        for( float **sample = samples; *sample != NULL; sample++ ){
            **sample /= units[i].multiplier;
            if( **sample >= units[i+1].multiplier )
                reached = true;
        }

        if (!reached) break;
    }

    return units[i].name;
}

