#include <stdio.h>
#include <math.h>

double rozdilOdchylek(double n1, double n2);
double mrizkovaKonstanta(double delta, double lambda1, double lambda2);

int main() {
	double delta = rozdilOdchylek(1.46, 1.42);
	printf("Rozdíl odchylek: %f\n", 180/(2*M_PI)*delta);
	printf("Mřížková konstanta: %f", mrizkovaKonstanta(delta, 400*pow(10,-9), 700*pow(10,-9)));
	return 0;
}

double rozdilOdchylek(double n1, double n2) {
	return asin(n1*sin(M_PI/3.0-asin(1.0/(2*n1))))-asin(n2*sin(M_PI/3.0-asin(1.0/(2*n2))));
}

double mrizkovaKonstanta(double delta, double lambda1, double lambda2) {
	return sqrt(pow(((lambda2-cos(delta)*lambda1)/(sin(delta))),2)+pow(lambda2,2));
}
