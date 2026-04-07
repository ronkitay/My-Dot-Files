#!/bin/bash

for arg in "$@"; do
  task $arg modify wait:sun+8h
done

