/**
 * PlayLPM
 *
 * Copyright (C) 2012 Paul Kocialkowski <contact@paulk.fr>
 *
 * playlpm is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * playlpm is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with playlpm.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOG_TAG "PlayLPM"
#include <cutils/log.h>

#define LPM_LOOP_DELAY		5
#define LPM_FRAMES_DIR		"/system/media/charging"
#define LPM_FRAMES_PREFIX	"charging-"
#define LPM_FRAMES_SUFFIX	".bgra"

void lpm_display_level(int level)
{
	char *frame_file;
	unsigned char *frame_data;
	int frame_size = -1;
	struct stat frame_stat;

	int fd = -1;

	memset(&frame_stat, 0, sizeof(frame_stat));

	asprintf(&frame_file, "%s/%s%d%s", LPM_FRAMES_DIR, LPM_FRAMES_PREFIX, level, LPM_FRAMES_SUFFIX);

	LOGD("frame file is: %s\n", frame_file);

	stat(frame_file, &frame_stat);
	frame_size = frame_stat.st_size;
	
	if(frame_size < 0)
	{
		LOGE("Wrong frame size, aborting");
		return;
	}

	fd = open(frame_file, O_RDONLY);
	free(frame_file);

	if(fd < 0)
	{
		LOGE("Failed to open frame file, aborting");
		return;
	}

	frame_data = malloc(frame_size);

	read(fd, frame_data, frame_size);

	close(fd);

	fd = open("/dev/graphics/fb0", O_WRONLY);
	if(fd < 0)
	{
		LOGE("Failed to open framebuffer node, aborting");
		return;
	}

	LOGD("Writing frame for level: %d", level);
	write(fd, frame_data, frame_size);

	close(fd);

	free(frame_data);
}

int lpm_battery_level(void)
{
	int capacity = -1;
	int level = -1;

	int fd = -1;
	int c = -1;
	char value[3];
	char status[6];

	fd = open("/sys/class/power_supply/battery/capacity", O_RDONLY);
	if(fd < 0)
	{
		LOGE("Failed to open capacity node, aborting");
		return 0;
	}

	c = read(fd, value, sizeof(value));
	value[c] = '\0';

	close(fd);

	capacity = atoi(value);
	if(capacity < 0 || capacity > 100)
	{
		LOGE("capacity value (%d) is unreliable, aborting", capacity);
		return 0;
	}

	// Truncate capacity to get a multiple of 10 as level
	level = ((capacity - (capacity % 10)) / 10) * 10;

	fd = open("/sys/class/power_supply/battery/status", O_RDONLY);
	if(fd < 0)
	{
		LOGE("Failed to open status node, aborting");
		return 0;
	}

	read(fd, status, sizeof(status));

	close(fd);

	// If status is reported as Full, assume 100% charged
	if(strncmp(status, "Full", 4) == 0)
	{
		level = 100;
	}

	LOGD("level is: %d\n", level);

	return level;
}

void lpm_backlight_brightness(char *brightness)
{
	int fd = -1;
	int length;

	if(brightness == NULL)
	{
		LOGE("brightness isn't set, aborting");
		return;
	}

	fd = open("/sys/class/backlight/s5p_bl/brightness", O_WRONLY);
	if(fd < 0)
	{
		LOGE("Failed to open brightness node, aborting");
		return;
	}

	length = strlen(brightness);

	LOGD("Setting brightness to: %s", brightness);
	write(fd, brightness, length);

	close(fd);
}

// This is the main loop function, where we check battery state
void lpm_loop(void)
{
	int level = -1;
	int l = -1;

	while(1)
	{
		level = lpm_battery_level();

		// Only refresh the image if the battery level changed
		if(level != l)
		{
			// Setting brightness to a very low level to reduce battery usage while charging
			lpm_backlight_brightness("5");
			lpm_display_level(level);
		}

		l = level;

		sleep(LPM_LOOP_DELAY);
	}
}

// Check if the phone is booting in charging mode
int lpm_check(void)
{
	int fd = -1;
	char value[2];

	fd = open("/sys/class/power_supply/battery/charging_mode_booting", O_RDONLY);
	if(fd < 0)
	{
		LOGE("Failed to open charging_mode_booting node, aborting");
		return 0;
	}

	read(fd, value, sizeof(value));

	close(fd);

	if(value[0] == '1')
	{
		LOGD("Phone is booting in charging mode");
		return 1;
	}

	return 0;
}

int main(int argc, char *argv[])
{
	// Start loop only if the phone is booting in charging mode
	if(lpm_check() == 1)
	{
		lpm_loop();
	}

	return 0;
}
