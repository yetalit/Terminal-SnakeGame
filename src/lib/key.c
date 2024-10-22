/*
 * Some sources:
 * Article: https://web.archive.org/web/20170407122137/http://cc.byexamples.com/2007/04/08/non-blocking-user-input-in-loop-without-ncurses/
 * Rafael Zurita's repo : https://github.com/zrafa/onscreenkeyboard/blob/master/key.c
 */

#include<stdio.h>
#include<unistd.h>
#include<termios.h>
#include<sys/select.h>
#include<sys/time.h>

int kbhit()
{
    struct timeval tv;
    fd_set fds;
    tv.tv_sec = 0;
    tv.tv_usec = 0;
    FD_ZERO(&fds);
    FD_SET(STDIN_FILENO, &fds); //STDIN_FILENO is 0
    select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
    return FD_ISSET(STDIN_FILENO, &fds);
}

void nonblock(int state)
{
    struct termios ttystate;

    //get the terminal state
    tcgetattr(STDIN_FILENO, &ttystate);

    if (state==0)
    {
        //turn off canonical mode
        ttystate.c_lflag &= ~ICANON;
        //minimum of number input read.
        ttystate.c_cc[VMIN] = 1;
    }
    else if (state==1)
    {
        //turn on canonical mode
        ttystate.c_lflag |= ICANON;
    }
    //set the terminal attributes.
    tcsetattr(STDIN_FILENO, TCSANOW, &ttystate);

}

int listen_key()
{
	usleep(1);
	if (kbhit()!=0)
	{
		return fgetc(stdin);
	}
	return -1;
}

/*
int main() {
	nonblock(0);
	while (1) {
		int c = listen_key();
		if (c != -1){
			printf("\nyou hit %c. \n",c);
		}
	}
	return 0;
}
*/
