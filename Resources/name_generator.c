//
//  name_generator.c
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

#include "name_generator.h"

static char *rand_name(char buff[], size_t size) {
  
  const char abc[] = "abcdefghijklmnopqrstuvwxyz";
  const char vowels[] = "aeiouy";

  for (size_t i = 0; i < size; i++) {
    if (i % 2 == 1) {
      int abcSize = (int) (sizeof abc - 1);
      int key = (int) arc4random_uniform(abcSize);
      buff[i] = abc[key];
    } else {
      int vowelsSize = (int) (sizeof vowels - 1);
      int key = (int) arc4random_uniform(vowelsSize);
      buff[i] = vowels[key];
    }
  }
  buff[size] = '\0';
  return buff;
}

char *get_admin_name(void) {
  
  int firstNameSize = (int)arc4random_uniform(7) + 3;
  int secondNameSize = (int)arc4random_uniform(7) + 3;
  
  char buff[100];
  static char name[20] = "";
//  char *nameToReturn[];
  
//  char *firstName = rand_name(buff, firstNameSize);
//  char *lastname = rand_name(buff, secondNameSize);
//
//  strcat(name, firstName);
//  strcat(name, " ");
//  strcat(name, lastname);

    strcat(name, rand_name(buff, firstNameSize));
    strcat(name, " ");
    strcat(name, rand_name(buff, secondNameSize));
  
//  strcat(nameToReturn, rand_name(buff, firstNameSize));
//  strcat(nameToReturn, " ");
//  strcat(nameToReturn, rand_name(buff, secondNameSize));
  
  printf("%s \n", name);
  
 // char *nameToReturn = name;
  
 // char nameToReturn = malloc(sizeof(*name));
  
  return name;
}
