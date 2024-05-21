#include <stdio.h>

int main() {
    int size;
    int numbers[100];
    scanf("%d", &size);
    for (int i = 0; i < size; i++) scanf("%d", &numbers[i]);
    for (int i = 0; i < size; i++) printf("%d ", numbers[i]);
    printf("\n");
    return 0;
}
