#!/bin/bash

for arg in "$@"; do
  task $arg modify wait:today+19h
done

