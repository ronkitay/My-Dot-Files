#!/bin/bash

for arg in "$@"; do
  task $arg modify wait:tomorrow+8h
done

