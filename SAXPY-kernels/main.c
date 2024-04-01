#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <math.h> 

// SAXPY x86-64 kernel
extern float* saxpy_asm(int n, float A, float* X, float* Y, float* Z);

// SAXPY C kernel
void saxpy(int n, float A, float* X, float* Y, float* Z) {
	printf("Output Z (C) --> ");
	int max = (n < 10) ? n : 10;
	for (int i = 0; i < n; i++) {
		Z[i] = A * X[i] + Y[i];
		
	}

	for (int i = 0;i < max; i++) {
		printf("%.2f", Z[i]);
		if (i + 1 != max) {
			printf(", ");
		}
	}
}

/* Function to generate an array with random floats within a specific range of -100 to 100*/
float* generate_array(int size, int seed) {
	float* arr = malloc(size * sizeof(float));
	if (arr == NULL) {
		printf("Memory allocation failed!\n");
		return NULL;
	}

	srand(seed); // Seed the random number generator

	for (int i = 0; i < size; i++) {
		float sign = (rand() % 2 == 0) ? 1.0f : -1.0f;
		float magnitude = (float)rand() / RAND_MAX; // Value between 0 and 1
		arr[i] = sign * magnitude * 100;
	}

	return arr;
}

// Timing functions
LARGE_INTEGER get_timestamp() {
	LARGE_INTEGER time;
	QueryPerformanceCounter(&time);
	return time;
}

double get_elapsed_time(LARGE_INTEGER start, LARGE_INTEGER end) {
	LARGE_INTEGER frequency;
	QueryPerformanceFrequency(&frequency);
	return (double)(end.QuadPart - start.QuadPart) / frequency.QuadPart;
}

int main() {
	int sizes[] = { 1048576, 16777216, 268435456}; // 2^20, 2^24, 2^28

	int n = 268435456;
	printf("Generating arrays of size %d...\n", n);
		
		
	float A = 3.0;

	// Generate the first array (X)
	float* X = generate_array(n, 14);
	// Generate the second array (Y)
	float* Y = generate_array(n, 15);


		
	printf("Inputs: \n");
	printf("n --> %d \n", n);
	printf("A --> %.2f \n", A);

	int max = (n < 10) ? n : 10;

	printf("X --> ");
	for (int i = 0; i < max; i++) {
		printf("%.2f", X[i]);
		if (i + 1 != max) {
			printf(", ");
		}
		else {
			printf(" ...");
		}
	}
	printf("\n");

	printf("Y --> ");
	for (int i = 0; i < max; i++) {
		printf("%.2f", Y[i]);
		if (i + 1 != max) {
			printf(", ");
		}
		else {
			printf(" ...");
		}
	}
	printf("\n");
	printf("\n");


	double assembly_time;
	double c_time;

	float* Z_assembly = malloc(n * sizeof(float));

	// SAXPY in Assembly
	LARGE_INTEGER start_asm = get_timestamp();
	Z_assembly = saxpy_asm(n, A, X, Y, Z_assembly);
	LARGE_INTEGER end_asm = get_timestamp();
	assembly_time = get_elapsed_time(start_asm, end_asm);

	float* Z_c = malloc(n * sizeof(float));

	// SAXPY in C 
	LARGE_INTEGER start_c = get_timestamp();
	saxpy(n, A, X, Y, Z_c);
	LARGE_INTEGER end_c = get_timestamp();
	c_time = get_elapsed_time(start_c, end_c);

	printf("\n");

	// Comparison check
	BOOLEAN values_match = TRUE;
	for (int i = 0; i < 10; i++) {
		if (Z_assembly[i] != Z_c[i]) {
			values_match = FALSE;
			printf("Discrepancy at index %d: Assembly = %.2f, C = %.2f\n", i, Z_assembly[i], Z_c[i]);
			break;
		}
	}
	if (values_match) {
		printf("The x86-64 kernel output is correct.\n");
	}

	free(Z_assembly);
	free(Z_c);

	printf("Execution time for size %d (C): %lf seconds\n", n, c_time);
	printf("Execution time for size %d (Assembly): %lf seconds\n", n, assembly_time);
	printf("\n");

	return 0;
	
}
