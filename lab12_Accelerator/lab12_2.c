#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

#define ZYNQ_BASE			  0x80000000  
#define START_RUN_OFFSET      0x00000100  
#define STATUS_OFFSET         0x00000104  
#define NODE_LAYER_0 784
#define NODE_LAYER_1 16
#define NODE_LAYER_2 16
#define NODE_LAYER_3 16
#define NODE_LAYER_4 10

#define BUFFER_SIZE 2352
volatile unsigned int* io;
/*===========================================================================*/
void cal(){
	//printf("start run\n");
    // -------------------------------------------------------------------------
    //  start run
    // -------------------------------------------------------------------------
    //volatile unsigned int x=*(io+n);
    *(io+(START_RUN_OFFSET/4)) = 1;
    *(io+(START_RUN_OFFSET/4)) = 0;
    //while(*(io+n)!=x);

    //printf("polling busy\n");
    // -------------------------------------------------------------------------
    //  polling busy
    // -------------------------------------------------------------------------
    while ( *(io+(STATUS_OFFSET/4))!=(volatile unsigned int)0){
    	;//printf("0x%x\n",*(io+(STATUS_OFFSET/4)));
	}
	/*for (j=0;j<n;j++) outm[j] = *(io+j);
		for (j=0;j<n;j++){
			printf("%d = %32f \n",j,outm[j]);
			//	if(i%4==3) putchar(10);
		}
	printf("\n");*/
    //printf("operation finish\n");
}
int main(int argc, char *argv[])
{
	volatile int fd = open( "/dev/mem", O_RDWR);//volatile是一個變數聲明限定詞,可能會在任何時刻被意外的更新
	volatile int map_len = 1800;
	io = (volatile unsigned int *)mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ZYNQ_BASE);

	float w_h1[NODE_LAYER_1][NODE_LAYER_0];
	float w_h2[NODE_LAYER_2][NODE_LAYER_1];
	float w_h3[NODE_LAYER_3][NODE_LAYER_2];
	float w_o[NODE_LAYER_4][NODE_LAYER_3];
	float b_h1[NODE_LAYER_1];
	float b_h2[NODE_LAYER_2];
	float b_h3[NODE_LAYER_3];
	float b_o[NODE_LAYER_4];

	int v_h1[NODE_LAYER_1];
	int v_h2[NODE_LAYER_2];
	int v_h3[NODE_LAYER_3];

	int input[NODE_LAYER_0];
	float inputf[NODE_LAYER_0];
	FILE *fileprint;
	char weightfile[64],biasfile[64],filename[64];
	int i, j ,k;
	float results[NODE_LAYER_4];
	int max_idx;
	float max;
	float one=1;
	
	int m[64];
    int outm[800];	

    //get memory
    if(io == MAP_FAILED) {
		perror("Mapping memory for absolute memory access failed.\n");
		exit(1);
	}
	printf("Zynq_BASE mapping successful :\n0x%x to 0x%x, size = %d\n", ZYNQ_BASE, (int)io, map_len);

	/* training data */
	strcpy(filename, "model_bin_16.txt");
	fileprint = fopen(filename, "r");
	if (fileprint==NULL){
		puts("ERROR: read model.");
		exit(-1);
	}
	for (i=0;i<NODE_LAYER_1;i++)
		for (j=0;j<NODE_LAYER_0;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_h1[i][j]);
		
	for (i=0;i<NODE_LAYER_1;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_h1[i]);
		
	for (i=0;i<NODE_LAYER_2;i++)
		for (j=0;j<NODE_LAYER_1;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_h2[i][j]);
		
	for (i=0;i<NODE_LAYER_2;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_h2[i]);
		
	for (i=0;i<NODE_LAYER_3;i++)
		for (j=0;j<NODE_LAYER_2;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_h3[i][j]);
		
	for (i=0;i<NODE_LAYER_3;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_h3[i]);
	
	for (i=0;i<NODE_LAYER_4;i++)
		for (j=0;j<NODE_LAYER_3;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_o[i][j]);
		
	for (i=0;i<NODE_LAYER_4;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_o[i]);
	
	fclose(fileprint);
	
	/* input data */
	
	unsigned char buffer[BUFFER_SIZE];
	fileprint = fopen("grayImg.ppm", "r");
	
	if (fileprint==NULL){
		puts("err input");
		return 0;
	}
	
	fseek(fileprint, 14, SEEK_SET);/*skip title(magic number etc.)*/
	fread(buffer,1,BUFFER_SIZE,fileprint);
	
	for (i=0;i<NODE_LAYER_0;i++){
		input[i]=buffer[i*3];
		printf("%02x ",255-input[i]);
		if (i%28 == 27)
			printf("\n");
	}
	printf("\n");
	fclose(fileprint);

	/* Pixel format convertion. */
	for (i=0;i<NODE_LAYER_0;i++){
		input[i] = 255 - input[i];
		inputf[i] = ((float)input[i]) * (1.0/255.0);
	}
	/* Calculate hidden layer 1. */
	i=0;int tmp;
	for (i=0;i<NODE_LAYER_1;i++){
		v_h1[i] = 0.0;
		for (j=0;j<=NODE_LAYER_0;j++){
			if(j==NODE_LAYER_0){
				*(io)=b_h1[i];
				*(io+1)=(float)1;
			}else{
				*(io)=inputf[j];
				*(io+1)=w_h1[i][j];
			}
			if(j==0) *(io+2)=(float)0;
			else *(io+2)=tmp;
			*(io+3)=(float)1;
			cal();
			tmp=*(io+1);
			//printf("%d\n",tmp);
		}
		v_h1[i]=tmp;
		printf("%d\n",v_h1[i]);
		if(v_h1[i]<0.0)	v_h1[i] = 0.0;
	}
	printf("\n");
	// Calculate hidden layer 2.
	for (i=0;i<NODE_LAYER_2;i++){
		v_h2[i] = 0.0;
		for (j=0;j<=NODE_LAYER_1;j++){
			if(j==NODE_LAYER_1){
				*(io+j*2)=b_h2[i];
				*(io+j*2+1)=(float)1;
			}else{
				*(io+j*2)=v_h1[j];
				*(io+j*2+1)=w_h2[i][j];
			}
		}
		cal();
		v_h2[i]=*(io+NODE_LAYER_1);
		printf("%d\n",v_h2[i]);
		if(v_h2[i]<0.0)	v_h2[i] = 0.0;
	}	
	printf("\n");
	// Calculate hidden layer 3. 
	for (i=0;i<NODE_LAYER_3;i++){
		v_h3[i] = 0.0;
		for (j=0;j<=NODE_LAYER_2;j++){
			if(j==NODE_LAYER_2){
				*(io+j*2)=b_h3[i];
				*(io+j*2+1)=(float)1;
			}else{
				*(io+j*2)=v_h2[j];
				*(io+j*2+1)=w_h3[i][j];
			}
		}
		cal();
		v_h3[i]=*(io+NODE_LAYER_2-1);	
		printf("%d\n",v_h3[i]);
		if(v_h3[i]<0.0) v_h3[i] =0.0;
	}
	printf("\n");
	// Calculate output layer.
	for (i=0;i<NODE_LAYER_4;i++){
		results[i] = 0.0;
		for (j=0;j<=NODE_LAYER_3;j++){
			if(j==NODE_LAYER_3){
				*(io+j*2)=b_o[i];
				*(io+j*2+1)=(float)1;
			}else{
				*(io+j*2)=v_h3[j];
				*(io+j*2+1)=w_o[i][j];
			}
		}
		cal();
		results[i]=*(io+NODE_LAYER_3);	
	}	
	for (i=0;i<NODE_LAYER_4;i++)
		printf(" %f\n", results[i]);
	printf("\n");
	
	/* Find max value. */
	/*max = results[0];
	max_idx = 0;
	for (i=1;i<NODE_LAYER_4;i++)
		if(max<results[i]){
			max_idx = i;
			max = results[i];
		}
	
	printf("Final ans:%d\n",max_idx);//max_idx ?\BA核對\E7???	return true;
	*/
		
	munmap((void *)io, map_len);//釋放指標io指向的記憶體空間，並設釋放的記憶體大小  
	close(fd);
    return 0;
}
/*===========================================================================*/
