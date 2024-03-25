#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

//extern void saxpy_run();
extern void saxpy_run_param(int n, float A, float* X, float* Y, float* Z);

void saxpy(int n, float A, float* X, float* Y, float* Z) {
	for (int i = 0; i < n; i++) {
		Z[i] = A * X[i] + Y[i];
	}
}

int main() {

	// General code for SAXPY in C
	int n = 11;
	float A = 2.0;
	float X[] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0 };
	float Y[] = { 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0 };
	float* Z = malloc(n * sizeof(float));

	saxpy_run_param(n, A, X, Y, Z);

	// Calling the assembly function
	//saxpy_run();

	// Perform the SAXPY operation
	//saxpy(n, A, X, Y, Z);

	// Display the first 10 elements (or up to n if n is less than 10)
	//printf("The first 10 elements of Z are:\n");
	//for (int i = 0; i < n && i < 10; i++) {
	//	printf("%.1f ", Z[i]);
	//}
	//printf("\n");
	//free(Z);
	

	return 0;
}
