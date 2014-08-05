#include <linux/input.h>

#include "recovery_ui.h"
#include "common.h"
#include "extendedcommands.h"


int device_handle_key(int key_code, int visible) {
    if (visible) {
        switch (key_code) {
            case KEY_VOLUMEDOWN:
            case 217: // SEARCH
                return HIGHLIGHT_DOWN;

            case KEY_VOLUMEUP:
            case 139: // MENU
                return HIGHLIGHT_UP;

            case 158: // HOME
                return SELECT_ITEM;

            case 102: // BACK
                    return GO_BACK;

            case KEY_POWER:
                return SELECT_ITEM;
            default:
                return NO_ACTION;
        }
    }

    return NO_ACTION;
}
