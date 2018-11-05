#include "types.h"
#include "stat.h"
#include "user.h"

char buf[512];

void sed(int fd, char *name)
{
	int i, n;
	int inword;
	int findWord;
	
	findWord = 0;
	inword = 0;
	//int printLine = 0;
	while ((n = read(fd, buf, sizeof(buf))) > 0) {
		//printf(1, "while reading\n");
		for (i = 0; i<n; i++) {
			if (buf[i] == 't') {
				if (i < n - 3 && buf[i + 1] == 'h' && buf[i + 2] == 'e') {
					buf[i] = 'x';
					buf[i + 1] = 'y';
					buf[i + 2] = 'z';
					findWord++;
					//printLine = 1;
				}
			}
			if (strchr(" \r\t\n\v", buf[i])) {
				//printf(1, "strtchr\n");
				inword = 0;
			}
			else if (!inword) {
				//w++;
				inword = 1;
			}
		}
		printf(1, "%s\n", buf);
	}
	if (n < 0) {
		printf(1, "sed: read error\n");
		exit();
	}
	//printf(1, "%s\n", buf);
	printf(1, "Found and replaced %d occurances\n", findWord);
}

int main(int argc, char *argv[])
{
	int fd, i;

	if (argc <= 1) {
		argc = 2;
		argv[1] = "README";
	}

	for (i = 1; i < argc; i++) {
		if ((fd = open(argv[i], 0)) < 0) {
			printf(1, "sed: cannot open %s\n", argv[i]);
			exit();
		}
		printf(1, "reading file %s\n", argv[i]);
		sed(fd, argv[i]);
		close(fd);
	}
	exit();
}
