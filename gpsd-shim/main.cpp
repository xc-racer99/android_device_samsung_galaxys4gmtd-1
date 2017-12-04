/*
 * Copyright (C) 2012 Daniel Bateman
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "AriesGps"

#include <stdio.h>
#include <unistd.h>
#include <utils/Log.h>
#include <errno.h>
#include <sys/personality.h>

#define GPSD_PATH "/vendor/bin/samsung-gpsd"

int main() {
    int currentPersonality = personality(0xFFFFFFFF);
    if (personality(currentPersonality | ADDR_NO_RANDOMIZE) == -1) {
        return 1;
    }

    execl(GPSD_PATH, GPSD_PATH, (char *) 0);

    // If we made it here, it failed (since exec replaces the running app).

    return 1;
}
