#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

extern float progProdASM(float *v1, float *v2, int N);
void initVector(float *v, int N);
float cFloatInnerProd(float *v1, float *v2, int N);
float calcRelErr(float ref, float cal);

int main()
{
    // semilla para los números aleatorios
    srandom(time(NULL));

    float *v1, *v2, ipC, ipAsm;
    int N = 1024;

    v1 = malloc(N * sizeof(float));

    v2 = malloc(N * sizeof(float));

    int i = 0;

    initVector(v1, N);
    initVector(v2, N);

    struct timespec ti, tf;
    double elapsed;

    clock_gettime(CLOCK_REALTIME, &ti);
    ipC = cFloatInnerProd(v1, v2, N);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsed = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("el tiempo en nanosegundos que toma la función en C es %lf\n", elapsed);
    printf("El resultado es: %f\n",ipC);
    clock_gettime(CLOCK_REALTIME, &ti);
    ipAsm = progProdASM(v1, v2, N);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsed = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("el tiempo en nanosegundos que toma la función en ASM es %lf\n", elapsed);
    printf("El resultado es: %f\n",ipAsm);

    float relerr = calcRelErr(ipC, ipAsm);

    printf("el error relativo es %f\n", relerr);

    free(v1);

    free(v2);

    return 0;
};

void initVector(float *v, int N)
{
    for (int i = 0; i < N; i++)
    {
        float e = random() % 255;
        v[i] = (sinf(e) + cosf(e));
    }
}

float cFloatInnerProd(float *v1, float *v2, int N)
{
    int i = 0;
    float sum = 0;
    for (i = 0; i < N; i++)
    {
        sum += v1[i] * v2[i];
    }
    return sum;
}

// error relativo de escalares:
// la idea es
// calcular el valor absoluto de la diferencia de las entradas
// calcular el valor absoluto de la referencia
// y dividir el primer valor entre el segundo
// a ese resultado se le llama el error relativo de cal respecto de ref
// mientras menor sea el resultado, mejor
float calcRelErr(float ref, float cal)
{
    return fabsf(ref - cal) / fabsf(ref);
}