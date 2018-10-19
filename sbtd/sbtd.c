#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define die(MSG) { \
	fprintf(stderr, "sbtd: " MSG "\n"); \
	exit(1); \
}

#define input_fifo "sbtd.in"
#define output_fifo "sbtd.out"

void cleanup(int signal) {
	unlink(input_fifo);
	unlink(output_fifo);
	exit(0);
}
int main(int argc, char **argv){
	struct sigaction act = (struct sigaction) {
		.sa_handler = &cleanup
	};
	sigaction(SIGINT, &act,0);

	if(mkfifo(input_fifo, 0660)!=0)
		die("mkfifo " input_fifo);
	if(mkfifo(output_fifo, 0660)!=0)
		die("mkfifo " output_fifo);


	int input_pipe[2];
	if(pipe(input_pipe) != 0)
		die("pipe");

	int output_pipe[2];
	if(pipe(output_pipe) != 0)
		die("pipe");


	pid_t sbt_pid = fork();
	if(sbt_pid < 0)
		die("fork")

	else if(sbt_pid == 0) {
		close(input_pipe[1]);
		close(output_pipe[0]);
		dup2(input_pipe[0], STDIN_FILENO);
		dup2(output_pipe[1], STDOUT_FILENO);

		execl("/usr/bin/sbt", "/usr/bin/sbt", (char*) NULL);
		fprintf(stderr, "sbtd: cannot run sbt\n");
		exit(1);
	}

	pid_t writer_pid = fork();
	if(writer_pid < 0)
		die("fork")
	else if(writer_pid == 0) {
		close(input_pipe[0]);
		close(input_pipe[1]);
		close(output_pipe[1]);

		while(1) {
			int output = open(output_fifo, O_WRONLY);
			if(output <= 0)
				die("open " output_fifo);

			char buff[0x100];
			size_t in_size;

			while((in_size = read(output_pipe[0], buff, 0x100))>0)
				write(output, buff, in_size);

			close(output);
		}
	}
	close(input_pipe[0]);
	close(output_pipe[0]);
	close(output_pipe[1]);

	while(1) {
		int input = open(input_fifo, O_RDONLY);
		if(input <= 0)
			die("open " input_fifo);

		char buff[0x100];
		size_t in_size;
		while((in_size = read(input, buff, 0xff)) > 0)
			write(input_pipe[1], buff, in_size);

		close(input);
	}

	return 0;
}
